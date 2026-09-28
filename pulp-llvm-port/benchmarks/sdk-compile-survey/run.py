#!/usr/bin/env python3
"""GAP9 SDK compile survey (backlog B30).

Compiles the GAP9 SDK's target C sources with GAP9 GCC (reference) and with
our LLVM, and buckets every LLVM failure by cause.

Phases (idempotent; results cached under --work):
  snapshot   copy the int-20 clang binary + resource headers into --work, so a
             concurrent rebuild of the fixed-path build dir cannot change the
             compiler mid-run (the version string is saved in snap/snap.json).
  configure  copy the SDK's app trees (examples, nn_menu, audio-framework) into
             a mirror whose other entries are symlinks (the SDK itself is never
             written), then run `cmake -B` (configure only, no build) on every
             app with CMAKE_EXPORT_COMPILE_COMMANDS, to get the exact per-file
             include paths and defines the SDK build uses. A venv with
             kconfiglib/xxhash/fdt is created for the SDK's Kconfig and
             device-tree generators; the SFU host tool is faked (-DSFU=/bin/true).
  db         merge the compile_commands.json files: one command per source,
             into <work>/compile_db.json.gz (never over the tracked snapshot).
             Later phases load <work>/compile_db.json.gz, else the tracked
             snapshot compile_db.json.gz (work-dir paths stored as @WORK@);
             if the cmake dirs it points at are missing (fresh --work, deleted
             scratch dir), configure + db are run in --work automatically.
  inventory  enumerate the SDK's target C sources by area; files that no
             configured app compiles get the flags of the nearest covered file
             in the same directory tree plus their own include dirs
             (flag_source = "inferred"). Host-side code is excluded (EXCLUDE).
  gcc        GAP9 GCC -O2 on every in-scope file (SDK flags minus -Werror).
  strict     our clang -O2 on the GCC-compilable files: the headline numbers.
  lenient    strict failures again with -Wno-error= for diagnostics clang (not
             GCC 7) makes errors; unknown builtins become external calls, so
             the back end is reached (crash search) and hidden errors surface.
  nodefs     strict successes again without the GAP9 predefined-macro shim.
  fp16probe  strict failures with float16 -> _Float16 (+zhinx), float16alt ->
             __bf16 (WRONG semantics, probe only) and CoreCount() -> 8: shows
             what remains behind the type errors.
  gccsdk     GAP9 GCC with the SDK's own warning flags INCLUDING -Werror, on
             the gcc-ok files (what the SDK build itself accepts).
  sdkflags   our clang as the SDK build drives it through the wrapper
             (../sdk-clang/bin/riscv32-unknown-elf-clang): -march=rv32imc_xgap9
             (predefines __gap9__ etc., no macro shim), the SDK's -W flags incl.
             -Werror (renamed/reordered as GCC resolves them), plus the
             wrapper's GCC-7 flags (GCC7_CODEGEN = -ffp-contract=fast;
             GCC7_DEFAULT_ERRORS without -Werror; CLANG_ONLY).  `strict` is unchanged: pure clang defaults.
  sdknowerror  sdkflags without -Werror (CONFIG_DISABLE_WERROR builds).
  parity     strict vs sdknowerror (both against gcc) and sdkflags (against
             gccsdk) -> sdkflags_parity.json.  Not part of `results`.
  dbsnapshot explicit only: refresh the tracked compile_db.json.gz snapshot.
  builtins   every __builtin_pulp_* the SDK uses, __has_builtin in our clang,
             call sites incl. #define wrappers (gap_*, Max/Min helpers).
  results    results.json, builtins.json, fix_ranking.json next to this script.

Usage: python3 run.py [--work DIR] [--jobs N] [--phases a,b,..] [--only REGEX] [--force]
Requires: cmake >= 3.19, dtc, python3-venv. Full run: ~15 min at -j12.
"""
import argparse, collections, glob, gzip, json, os, re, shlex, shutil
import subprocess, sys
from concurrent.futures import ThreadPoolExecutor

SDK = '/home/ubuntu/gap_sdk_release'
GCC_TC = '/home/ubuntu/gap_riscv_toolchain_ubuntu'
GCC = GCC_TC + '/bin/riscv32-unknown-elf-gcc'
CLANG = '/home/ubuntu/llvm-project/pulp-llvm-port/build/int-20/bin/clang'
HERE = os.path.dirname(os.path.abspath(__file__))

GCC_ARCH = ['-march=rv32imcxgap9', '-mPE=8', '-mFC=1', '-mint64']
LLVM_ARCH = ['--target=riscv32-unknown-elf', '-march=rv32imc_zfinx_xpulpv2',
             '-mabi=ilp32', '-mno-relax']
# GAP9 GCC predefines these; our clang does not (see report). A drop-in
# wrapper would add them, so the survey does too, and counts the files that
# need them separately (phase llvm, mode "nodefs").
COMPAT_DEFS = ['-D__gap9__', '-D__pulp__', '-D__pulp', '-D_pulp',
               '-D__riscv__', '-D_riscv']
LLVM_COMMON = ['-O2', '-c', '-fno-crash-diagnostics', '-ferror-limit=0',
               '-fno-color-diagnostics', '-Wno-unknown-warning-option',
               '-Wno-ignored-optimization-argument',
               '-isystem', GCC_TC + '/riscv32-unknown-elf/include']
# Diagnostics that clang 20 treats as errors by default but GCC 7 accepts.
LENIENT = ['-Wno-error=implicit-function-declaration',
           '-Wno-error=implicit-int', '-Wno-error=int-conversion',
           '-Wno-error=incompatible-pointer-types',
           '-Wno-error=incompatible-function-pointer-types',
           '-Wno-error=return-type', '-Wno-error=int-to-pointer-cast',
           '-Wno-error=pointer-to-int-cast',
           '-Wno-error=address-of-packed-member']

# ----------------------------------------------------------------- areas
AREAS = [
    ('rtos/freertos', 'rtos/pmsis/os/freeRTOS/'),
    ('rtos/pmsis-implem', 'rtos/pmsis/implem/'),
    ('rtos/pmsis-bsp', 'rtos/pmsis/bsp/'),
    ('rtos/other', 'rtos/'),
    ('libs/mbedtls', 'libs/mbedtls/library/'),
    ('libs/other', 'libs/'),
    ('at/DSP_Libraries', 'tools/autotiler_v3/BasicKernels/DSP_Libraries/'),
    ('at/CNN_Libraries', 'tools/autotiler_v3/BasicKernels/CNN_Libraries'),
    ('at/other-kernels', 'tools/autotiler_v3/BasicKernels/'),
    ('audio-framework', 'tools/audio-framework/'),
    ('examples/dsp', 'examples/gap9/dsp/'),
    ('examples/nn', 'examples/gap9/nn/'),
    ('examples/audio', 'examples/gap9/audio_application/'),
    ('examples/basic', 'examples/gap9/basic/'),
    ('examples/other', 'examples/'),
    ('nn_menu', 'nn_menu/'),
    ('utils', 'utils/'),
]
# Target-code roots enumerated even when no configured app compiles them.
ENUM_ROOTS = ['rtos', 'libs', 'tools/autotiler_v3/BasicKernels',
              'tools/audio-framework/lib']
# Host-side or non-target code: never part of the survey.
EXCLUDE = [
    (r'^libs/mbedtls/(programs|3rdparty|tests)/', 'mbedtls host programs/tests'),
    (r'^rtos/pmsis/emul/', 'x86 PMSIS emulation'),
    (r'/mex/|/matlab_tools/|/python_tools/', 'host MATLAB/Python tooling'),
    (r'^tools/autotiler_v3/(Autotiler|Generators|Emulation)/', 'AutoTiler host code'),
    (r'^gvsoc|^utils/(gapy|openocd|hwtestbench|littlefs)', 'host/simulator code'),
    (r'CNN_Libraries/TestSoftMax\.c$', 'host test program'),
    (r'freeRTOS/freertos_kernel/portable/(MemMang/heap_[1-5]|Common/mpu_wrappers)\.c$',
     'upstream FreeRTOS alternative not used by the GAP9 port'),
    (r'ble/nina_b112/nina_b112_old\.c$', 'dead file'),
    (r'nina_w10/firmware/', 'firmware for a different (ESP32) chip'),
    (r'libs/frame_streamer/examples/', 'example needing its own app build'),
]


def area_of(rel):
    for name, pfx in AREAS:
        if rel.startswith(pfx):
            return name
    return 'other'


def excluded(rel):
    for rx, why in EXCLUDE:
        if re.search(rx, rel):
            return why
    return None


def sh(cmd, **kw):
    return subprocess.run(cmd, shell=isinstance(cmd, str), capture_output=True,
                          text=True, errors='replace', **kw)


# ----------------------------------------------------------------- configure
def phase_configure(a):
    w = a.work
    venv = os.path.join(w, 'venv')
    if not os.path.exists(venv + '/bin/python'):
        sh([sys.executable, '-m', 'venv', venv])
        sh([venv + '/bin/pip', 'install', '-q', 'kconfiglib', 'xxhash', 'fdt'])
    m = os.path.join(w, 'sdk')
    if not os.path.isdir(m):
        os.makedirs(m + '/tools')
        for e in os.listdir(SDK):
            if e in ('examples', 'nn_menu', 'tools', '.git'):
                continue
            os.symlink(os.path.join(SDK, e), os.path.join(m, e))
        for e in os.listdir(SDK + '/tools'):
            if e != 'audio-framework':
                os.symlink(os.path.join(SDK, 'tools', e), os.path.join(m, 'tools', e))
        for t in ('examples', 'nn_menu', 'tools/audio-framework'):
            shutil.copytree(os.path.join(SDK, t), os.path.join(m, t), symlinks=True)
    apps = sh("cd %s && find examples nn_menu tools/audio-framework -name CMakeLists.txt"
              " | xargs grep -l setup.cmake | sed 's|/CMakeLists.txt||' | sort" % SDK
              ).stdout.split()
    envsetup = ('export GAP_RISCV_GCC_TOOLCHAIN=%s; source %s/configs/gap9_evk_audio.sh'
                ' >/dev/null 2>&1; export PYTHONDONTWRITEBYTECODE=1;'
                ' export PATH=%s/bin:%s/bin:$PATH' % (GCC_TC, SDK, venv, GCC_TC))
    os.makedirs(w + '/bld', exist_ok=True)

    def one(app):
        b = os.path.join(w, 'bld', app.replace('/', '_'))
        if os.path.exists(b + '/compile_commands.json'):
            return app, 0
        cmd = ('%s; cd %s/%s && timeout 600 cmake -B %s -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
               ' -DPython_EXECUTABLE=%s/bin/python -DSFU=/bin/true > %s.log 2>&1'
               % (envsetup, m, app, b, venv, b))
        r = subprocess.run(['bash', '-c', cmd])
        return app, r.returncode
    with ThreadPoolExecutor(a.jobs) as ex:
        res = list(ex.map(one, apps))
    ok = sum(os.path.exists(os.path.join(w, 'bld', x.replace('/', '_'), 'compile_commands.json'))
             for x, _ in res)
    print('configure: %d apps, %d produced compile_commands.json' % (len(apps), ok))
    json.dump({'apps': apps}, open(w + '/apps.json', 'w'))


# ----------------------------------------------------------------- db
def phase_db(a):
    w = a.work
    mir = os.path.join(w, 'sdk') + '/'
    db = {}
    for cc in sorted(glob.glob(w + '/bld/*/compile_commands.json')):
        app = os.path.basename(os.path.dirname(cc))
        for e in json.load(open(cc)):
            f = e['file'].replace(mir, SDK + '/')
            if not f.startswith(SDK + '/') or not f.endswith('.c'):
                continue            # generated files, asm, C++
            if not os.path.exists(f):
                continue            # AutoTiler/NNTool output, not generated yet
            args = shlex.split(e['command']) if 'command' in e else e['arguments']
            args = [x.replace(mir, SDK + '/') for x in args]
            keep, skip = [], False
            for x in args[1:]:
                if skip:
                    skip = False
                    continue
                if x in ('-o', '-c'):
                    skip = x == '-o'
                    continue
                if x == e['file'] or x == f:
                    continue
                keep.append(x)
            rel = f[len(SDK) + 1:]
            db.setdefault(rel, {'args': keep, 'dir': e['directory'].replace(mir, SDK + '/'),
                                'apps': []})['apps'].append(app)
    with gzip.open(os.path.join(w, 'compile_db.json.gz'), 'wt') as fh:
        json.dump(db, fh, sort_keys=True)
    print('db: %d C sources with real compile commands -> %s/compile_db.json.gz' % (len(db), w))


# The tracked compile_db.json.gz next to this script is a documented SNAPSHOT
# only (for reading, and as a fallback): its work-dir paths are replaced by the
# placeholder @WORK@ and substituted at load time.  Runs use the database the
# db phase writes into --work; `dbsnapshot` refreshes the tracked copy on
# explicit request only.
SNAP_DB = os.path.join(HERE, 'compile_db.json.gz')
WORK_TOKEN = '@WORK@'
RX_BLD = re.compile(r'(/[^\s"]*?)/bld/')


def _subst_db(db, old, new):
    for e in db.values():
        e['args'] = [x.replace(old, new) for x in e['args']]
        e['dir'] = e['dir'].replace(old, new)
    return db


def _bld_roots(argss, work):
    """The cmake build dirs <work>/bld/<app> that -I options point into (their
    generated devicetree/Kconfig headers; some -I subdirs such as BUILD_MODEL
    only appear in a full build, so only the app dirs are checked)."""
    pre = '-I' + work + '/bld/'
    return {os.path.join(work, 'bld', x[len(pre):].split('/')[0])
            for args in argss for x in args if x.startswith(pre)}


def load_db(a):
    """The database for --work: <work>/compile_db.json.gz if the db phase made
    it, else the tracked snapshot with @WORK@ (or a legacy absolute work dir)
    replaced by --work.  If the cmake build dirs it points at do not exist
    (fresh --work, deleted scratch dir), the configure and db phases are run
    in --work first."""
    work = os.path.abspath(a.work)
    wp = os.path.join(work, 'compile_db.json.gz')
    for attempt in (0, 1):
        src = wp if os.path.exists(wp) else SNAP_DB
        with gzip.open(src, 'rt') as fh:
            db = json.load(fh)
        _subst_db(db, WORK_TOKEN + '/', work + '/')
        # legacy snapshots recorded the absolute work dir they were made in
        for o in {m.group(1) for e in db.values() for x in e['args'] + [e['dir']]
                  for m in [RX_BLD.search(x)] if m} - {work}:
            _subst_db(db, o + '/bld/', work + '/bld/')
        missing = [d for d in _bld_roots((e['args'] for e in db.values()), work)
                   if not os.path.isdir(d)]
        if not missing:
            return db
        if attempt:
            sys.exit('db: %d cmake build dirs still missing after configure, e.g. %s'
                     % (len(missing), missing[0]))
        print('db: %d cmake build dirs missing under %s (fresh or deleted work dir):'
              ' running configure + db there' % (len(missing), work))
        phase_configure(a)
        phase_db(a)


def phase_dbsnapshot(a):
    """Explicit request only: refresh the tracked snapshot from --work, with
    the work dir replaced by @WORK@ so it is portable."""
    work = os.path.abspath(a.work)
    with gzip.open(os.path.join(work, 'compile_db.json.gz'), 'rt') as fh:
        db = json.load(fh)
    _subst_db(db, work + '/', WORK_TOKEN + '/')
    with gzip.open(SNAP_DB, 'wt') as fh:
        json.dump(db, fh, sort_keys=True)
    print('dbsnapshot: %d entries -> %s' % (len(db), SNAP_DB))


def phase_inventory(a):
    db = load_db(a)
    files = set(db)
    for r in ENUM_ROOTS:
        for p in sh('cd %s && find %s -name "*.c"' % (SDK, r)).stdout.split():
            files.add(p)
    inv = []
    covered = sorted(db)
    for rel in sorted(files):
        ent = {'file': rel, 'area': area_of(rel)}
        why = excluded(rel)
        if why and rel not in db:
            ent.update(scope='excluded', reason=why)
            inv.append(ent)
            continue
        if rel in db:
            ent.update(scope='in', flag_source='cmake', apps=db[rel]['apps'][:5],
                       n_apps=len(db[rel]['apps']), args=db[rel]['args'],
                       cwd=db[rel]['dir'])
        else:
            # nearest covered file sharing the longest directory prefix
            d = os.path.dirname(rel)
            best, bl = None, -1
            for c in covered:
                cp = os.path.commonpath([d, os.path.dirname(c)])
                l = len(cp.split('/')) if cp else 0
                if l > bl:
                    best, bl = c, l
            args = [x for x in db[best]['args']]
            own = os.path.join(SDK, os.path.dirname(rel))
            extra = ['-I' + own]
            for inc in ('include', '../include', '../../include', 'inc', '../inc'):
                p = os.path.normpath(os.path.join(own, inc))
                if os.path.isdir(p):
                    extra.append('-I' + p)
            ent.update(scope='in', flag_source='inferred', flags_from=best,
                       args=extra + args, cwd=own)
        inv.append(ent)
    json.dump(inv, open(os.path.join(a.work, 'inventory.json'), 'w'))
    c = collections.Counter((e['scope'], e.get('flag_source')) for e in inv)
    print('inventory:', dict(c))


def ensure_inventory(a):
    """inventory.json of --work, (re)made when missing or when the generated-
    header dirs it points at are gone (the db is then regenerated too)."""
    p = os.path.join(a.work, 'inventory.json')
    if os.path.exists(p):
        inv = json.load(open(p))
        dirs = _bld_roots((e['args'] for e in inv if e['scope'] == 'in'), a.work)
        if all(os.path.isdir(d) for d in dirs):
            return inv
    phase_inventory(a)
    return json.load(open(p))


# ----------------------------------------------------------------- compile
# probe only: bf16 is not Xf16alt, and CoreCount is folded the way GCC -mPE=8 does
FP16_SHIM = ['-Dfloat16=_Float16', '-Dfloat16alt=__bf16', '-D__builtin_pulp_CoreCount()=8']
MODES = {
    # mode: (compat defines, lenient, fp16 shim)
    'strict': (True, False, False),     # the headline configuration
    'lenient': (True, True, False),     # reaches the backend despite missing builtins
    'nodefs': (False, False, False),    # strict without the compat defines
    'fp16probe': (True, True, True),    # what remains once float16 types + constant CoreCount exist
    'sdkflags': None,                   # SDK warning flags incl. -Werror + GCC-7 compat, -march=rv32imc_xgap9
    'sdknowerror': None,                # the same without -Werror (CONFIG_DISABLE_WERROR builds)
}


# ---- sdkflags mode: the SDK's own build flags, as the clang wrapper
# (../sdk-clang/bin/riscv32-unknown-elf-clang) passes them.
# -march=rv32imc_xgap9 predefines __gap9__/__pulp__/__riscv__... itself, so no
# macro shim.  The SDK's warning flags (-Wall -Wextra -Werror -Wno-...) are kept
# (translated where clang spells them differently), and GCC7_COMPAT (defined in
# the wrapper, the single source of truth) makes clang's diagnostics behave as
# GAP9 GCC 7.1.1's do.
SDK_ARCH = ['--target=riscv32-unknown-elf', '-march=rv32imc_xgap9', '-mabi=ilp32', '-mno-relax']
SDK_WRAPPER = os.path.join(HERE, '..', 'sdk-clang', 'bin', 'riscv32-unknown-elf-clang')


def _wrapper_mod():
    import importlib.machinery, importlib.util
    ld = importlib.machinery.SourceFileLoader('gap9_clang_wrapper', SDK_WRAPPER)
    spec = importlib.util.spec_from_loader(ld.name, ld)
    m = importlib.util.module_from_spec(spec)
    ld.exec_module(m)
    return m


WRAP = _wrapper_mod()


def gcc_cmd(args, out, werror=False):
    keep = []
    for x in args:
        if x.startswith(('-march', '-mPE', '-mFC', '-mint64')) or re.match(r'^-O[0-9sgz]?$', x) \
           or (not werror and (x == '-Werror' or x.startswith('-Werror='))):
            continue
        keep.append(x)
    return [GCC] + GCC_ARCH + keep + ['-O2', '-c', '-o', out]


def llvm_flags(args, mode):
    if mode in ('sdkflags', 'sdknowerror'):
        return sdk_llvm_flags(args, werror=mode == 'sdkflags')
    keep, it = [], iter(args)
    for x in it:
        if x in ('-include', '-imacros', '-isystem', '-x'):
            keep += [x, next(it)]
            continue
        if x.startswith(('-D', '-U', '-I', '-std=', '-include')):
            keep.append(x)
        elif x.startswith('-f') and x not in ('-fno-tree-loop-distribute-patterns',
                                               '-fmessage-length=0'):
            keep.append(x)
        # everything else (-march/-mPE/-mFC/-mint64/-mno-memcpy/-O/-W/-g) dropped
    defs, len_, fp16 = MODES[mode]
    arch = list(LLVM_ARCH)
    extra = (COMPAT_DEFS if defs else []) + (LENIENT if len_ else [])
    if fp16:
        arch[1] = '-march=rv32imc_zfinx_zhinx_xpulpv2'
        extra += FP16_SHIM
    return arch + LLVM_COMMON + extra + keep


def sdk_llvm_flags(args, werror=True):
    keep, ws, it = [], [], iter(args)
    for x in it:
        if x in ('-include', '-imacros', '-isystem', '-x'):
            keep += [x, next(it)]
            continue
        if x.startswith(('-D', '-U', '-I', '-std=', '-include')):
            keep.append(x)
        elif x.startswith('-f') and x not in ('-fno-tree-loop-distribute-patterns',
                                               '-fmessage-length=0'):
            keep.append(x)
        elif x.startswith('-W') and not x.startswith(('-Wl,', '-Wa,', '-Wp,')):
            if werror or not (x == '-Werror' or x.startswith('-Werror=')):
                ws.append(x)
        # -march/-mPE/-mFC/-mint64/-mno-memcpy/-O/-g dropped (-O2 as for GCC)
    return (SDK_ARCH + LLVM_COMMON + ['-Wno-unused-command-line-argument']
            + WRAP.GCC7_CODEGEN + WRAP.gcc7_compat(ws) + WRAP.sdk_warning_flags(ws)
            + keep)  # the wrapper's order


def llvm_cmd(args, out, mode):
    return [CLANG] + llvm_flags(args, mode) + ['-o', out]


def run_one(cmd, src, cwd, logf, timeout=300):
    try:
        r = subprocess.run(cmd + [src], cwd=cwd if os.path.isdir(cwd) else SDK,
                           capture_output=True, text=True, errors='replace',
                           timeout=timeout, env=dict(os.environ, TMPDIR=os.path.dirname(logf)))
        rc, err = r.returncode, r.stderr
    except subprocess.TimeoutExpired:
        rc, err = 'timeout', 'TIMEOUT after %ds' % timeout
    with open(logf, 'w') as fh:
        fh.write('CMD: ' + ' '.join(shlex.quote(x) for x in cmd + [src]) + '\n' + err)
    return rc


def logpath(work, which, rel):
    return os.path.join(work, 'out', which, rel.replace('/', '__') + '.log')


def read_log(work, which, rel):
    try:
        t = open(logpath(work, which, rel), errors='replace').read()
    except FileNotFoundError:
        return None
    return t.split('\n', 1)[1] if t.startswith('CMD: ') else t


def phase_compile(a, which):
    w = a.work
    inv = ensure_inventory(a)
    resf = os.path.join(w, 'compile_%s.json' % which)
    res = json.load(open(resf)) if os.path.exists(resf) and not a.force else {}
    todo = [e for e in inv if e['scope'] == 'in']
    if which not in ('gcc',):
        g = json.load(open(os.path.join(w, 'compile_gcc.json')))
        todo = [e for e in todo if g.get(e['file'], {}).get('rc') == 0]
    if which in ('nodefs', 'fp16probe', 'lenient'):
        s = json.load(open(os.path.join(w, 'compile_strict.json')))
        want_ok = which == 'nodefs'
        todo = [e for e in todo if (s.get(e['file'], {}).get('rc') == 0) == want_ok]
    if a.only:
        todo = [e for e in todo if re.search(a.only, e['file'])]
    todo = [e for e in todo if e['file'] not in res or a.only]
    d = os.path.join(w, 'out', which)
    os.makedirs(d, exist_ok=True)

    def one(e):
        o = logpath(w, which, e['file'])[:-4] + '.o'
        if which in ('gcc', 'gccsdk'):
            cmd = gcc_cmd(e['args'], o, werror=which == 'gccsdk')
        else:
            cmd = llvm_cmd(e['args'], o, which)
        return e['file'], {'rc': run_one(cmd, os.path.join(SDK, e['file']), e['cwd'],
                                         logpath(w, which, e['file']))}
    with ThreadPoolExecutor(a.jobs) as ex:
        for f, r in ex.map(one, todo):
            res[f] = r
    json.dump(res, open(resf, 'w'), indent=0, sort_keys=True)
    c = collections.Counter('ok' if r['rc'] == 0 else 'fail' for r in res.values())
    print('%s: %s' % (which, dict(c)))


# ----------------------------------------------------------------- classify
RX_DIAG = re.compile(r'^(?P<loc>[^\n]*?):(?P<line>\d+):(?:\d+:)? (?P<sev>(?:fatal )?error|warning): '
                     r'(?P<msg>.*)$', re.M)
RX_BUILTIN = re.compile(r"(?:use of unknown builtin|call to undeclared (?:library )?function|"
                        r"implicit declaration of function) '(__builtin_\w+)'")
ORDER = ['crash', 'timeout', 'unknown -march/option', 'missing builtin', 'unsupported type',
         'gcc-only language feature', 'inline asm', 'builtin argument check',
         'clang-stricter default error', 'missing header', 'other']


def diagnostics(err):
    """Yield (severity, message, context) for each diagnostic; context is the
    text up to the next diagnostic (notes, 'expanded from macro' lines)."""
    ms = list(RX_DIAG.finditer(err))
    for i, m in enumerate(ms):
        end = ms[i + 1].start() if i + 1 < len(ms) else len(err)
        yield m.group('sev'), m.group('msg'), err[m.end():end]


def crash_info(rc, err):
    if rc == 'timeout':
        return 'timeout'
    if not ('PLEASE submit a bug report' in err or 'Stack dump:' in err or
            (isinstance(rc, int) and rc not in (0, 1))):
        return None
    det = []
    asrt = re.search(r"Assertion `(.*?)' failed", err)
    if asrt:
        det.append('Assertion `%s\' failed' % asrt.group(1)[:200])
    elif re.search(r'Segmentation fault|SIGSEGV|Program arguments', err):
        det.append('segfault/signal')
    passes = re.findall(r"Running pass '([^']+)' on (?:function|module) '([^']*)'", err)
    if passes:
        det.append("pass '%s' on %s" % passes[-1])
    return ' | '.join(det) or 'crash (rc=%s)' % rc


def classify_llvm(rc, err):
    """-> (categories {cat: sorted details}, builtins Counter)."""
    cats = collections.defaultdict(set)
    builtins = collections.Counter()
    cr = crash_info(rc, err)
    if cr:
        cats['timeout' if cr == 'timeout' else 'crash'].add(cr)
    cascade = []
    for sev, msg, ctx in diagnostics(err):
        b = RX_BUILTIN.search(msg)
        if b:
            name = b.group(1)
            builtins[name] += 1
            if name == '__builtin_shuffle':
                cats['gcc-only language feature'].add('__builtin_shuffle')
            elif name.startswith('__builtin_pulp_'):
                cats['missing builtin'].add(name)
            else:
                cats['missing builtin'].add(name)
            continue
        if sev == 'warning':
            continue
        if re.search(r"(from|to|with an expression of) incompatible type 'int'|passing 'int' to "
                     r"parameter of incompatible type", msg):
            cascade.append(msg)                     # result of an implicit int builtin call
        elif re.search(r"float16alt|'(f16a|F16A|v2ah|V2AH)'", msg):
            cats['unsupported type'].add('float16alt (GCC builtin type)')
        elif re.search(r"'(float16|f16|F16|v2h|V2H|v4h)'|float16\b|_Float16|__fp16", msg):
            cats['unsupported type'].add('float16 (GCC builtin type)')
        elif re.search(r'unknown argument|unsupported option|unsupported argument|'
                       r'invalid arch name|unknown target', msg):
            cats['unknown -march/option'].add(msg[:160])
        elif re.search(r'invalid instruction mnemonic|unrecognized instruction|'
                       r'invalid operand for instruction|unknown register|invalid output constraint|'
                       r'invalid input constraint|constraint|inline asm|operand must be|'
                       r'instruction requires', msg) or '<inline asm>' in ctx[:200]:
            cats['inline asm'].add(msg[:160])
        elif re.search(r'initializer element is not a compile-time constant', msg) and \
                'CoreCount' in ctx:
            cats['gcc-only language feature'].add('__builtin_pulp_CoreCount() folded to a '
                                                  'constant (-mPE) in a static initializer')
        elif re.search(r'function definition is not allowed here|nested function', msg):
            cats['gcc-only language feature'].add('nested function')
        elif re.search(r'fields must have a constant size|variable length array in structure', msg):
            cats['gcc-only language feature'].add('VLA in struct')
        elif re.search(r"call to undeclared function|incompatible (function )?pointer types|"
                       r"incompatible integer to pointer|incompatible pointer to integer|"
                       r"type specifier missing|non-void function .* should return a value|"
                       r"cast to smaller integer type|call to undeclared library function", msg):
            cats['clang-stricter default error'].add(re.sub(r"'[^']*'", "'X'", msg)[:100])
        elif 'file not found' in msg:
            cats['missing header'].add(msg[:160])
        elif re.search(r'argument (value|should be|to .* must be)|must be a constant|'
                       r'outside the valid range', msg):
            cats['builtin argument check'].add(msg[:160])
        else:
            cats['other'].add(msg[:200])
    if cascade and not cats:
        cats['unsupported type'].add('vector conversion: ' + cascade[0][:120])
    if rc != 0 and not cats:
        first = [l for l in err.splitlines() if l.strip()]
        cats['other'].add(first[0][:200] if first else 'rc=%s, no message' % rc)
    return {k: sorted(v) for k, v in cats.items()}, builtins


def primary(cats):
    for k in ORDER:
        if k in cats:
            det = cats[k]
            return k, (', '.join(det) if k == 'missing builtin' else det[0])
    return 'ok', ''


def classify_gcc(err):
    for sev, msg, ctx in diagnostics(err):
        if sev.endswith('error'):
            if 'No such file or directory' in msg:
                return 'missing header (generated at build time or config-specific)', msg
            return 'other', msg[:200]
    return 'other', (err.strip().splitlines() or [''])[0][:200]
# ----------------------------------------------------------------- builtins
def phase_builtins(a):
    """Which builtins the SDK uses, which our clang lacks, and how often each
    is used: direct spellings plus call sites of the #define wrappers
    (gap_*, Max/Min helpers, ...) that expand to it, up to 3 levels."""
    roots = ('rtos libs tools/autotiler_v3/BasicKernels tools/autotiler_v3/Emulation '
             'tools/audio-framework/lib examples nn_menu utils/ssbl utils/gap_cli')
    paths = sh("cd %s && find %s -name '*.[ch]'" % (SDK, roots)).stdout.split()
    texts = {}
    for rel in paths:
        if excluded(rel) and not rel.startswith('tools/autotiler_v3/Emulation/'):
            continue
        texts[rel] = open(os.path.join(SDK, rel), errors='replace').read()
    rx_b = re.compile(r'\b(__builtin_pulp_\w+|__builtin_shuffle)\b')
    names = set()
    for t in texts.values():
        names |= set(rx_b.findall(t))
    rx_def = re.compile(r'^[ \t]*#[ \t]*define[ \t]+(\w+)\(([^)]*)\)(.*)$', re.M)
    rx_id = re.compile(r'\b\w+\b')
    rx_call = re.compile(r'\b(\w+)\s*\(')
    body_ids = collections.defaultdict(set)      # macro -> identifiers in its bodies
    calls = {}
    for rel, t in texts.items():
        for m in rx_def.finditer(t):
            body_ids[m.group(1)] |= set(rx_id.findall(m.group(3)))
        calls[rel] = collections.Counter(rx_call.findall(rx_def.sub('', t)))
    wrap = {}
    for n in names:
        found, frontier = set(), {n}
        for _ in range(3):
            new = {mac for mac, ids in body_ids.items()
                   if mac not in found and mac != n and ids & frontier}
            found |= new
            frontier = new
            if not new:
                break
        wrap[n] = found
    uses = collections.Counter()
    cfiles = collections.defaultdict(set)
    for rel, cc in calls.items():
        for n in names:
            k = cc.get(n, 0) + sum(cc.get(w_, 0) for w_ in wrap[n])
            if n == '__builtin_shuffle':
                k = cc.get(n, 0)
            if k:
                uses[n] += k
                if rel.endswith('.c'):
                    cfiles[n].add(rel)
    src = ''.join('#if !__has_builtin(%s)\n#warning MISSING %s\n#endif\n' % (n, n)
                  for n in sorted(names))
    p = os.path.join(a.work, 'hasb.c')
    open(p, 'w').write(src)
    r = sh([CLANG] + LLVM_ARCH + ['-E', p, '-o', '/dev/null'])
    missing = set(re.findall(r'MISSING (\w+)', r.stderr))
    res = {n: {'defined_in_clang': n not in missing, 'call_sites': uses[n],
               'c_files_calling': len(cfiles[n]), 'wrappers': sorted(wrap[n])[:12]}
           for n in sorted(names)}
    json.dump(res, open(os.path.join(a.work, 'builtins_text.json'), 'w'), indent=1)
    print('builtins: %d names used by the SDK, %d missing in clang' %
          (len(res), sum(1 for v in res.values() if not v['defined_in_clang'])))


# ----------------------------------------------------------------- results
def phase_results(a):
    w = a.work
    inv = ensure_inventory(a)
    comp = {m: (json.load(open('%s/compile_%s.json' % (w, m)))
                if os.path.exists('%s/compile_%s.json' % (w, m)) else {})
            for m in ('gcc', 'strict', 'lenient', 'nodefs', 'fp16probe')}
    bt = json.load(open(w + '/builtins_text.json'))
    rows = []
    bfiles = collections.defaultdict(set)
    for e in inv:
        f = e['file']
        row = {'file': f, 'area': e['area']}
        if e['scope'] != 'in':
            row.update(gcc='excluded', llvm='n/a', bucket='excluded', detail=e['reason'])
            rows.append(row)
            continue
        row['flag_source'] = e['flag_source']
        if e['flag_source'] == 'inferred':
            row['flags_from'] = e['flags_from']
        if comp['gcc'][f]['rc'] != 0:
            b, d = classify_gcc(read_log(w, 'gcc', f))
            row.update(gcc='fail', llvm='n/a', bucket='harness setup: ' + b, detail=d)
            rows.append(row)
            continue
        row['gcc'] = 'ok'
        src = comp['strict'][f]['rc']
        cats, bl = classify_llvm(src, read_log(w, 'strict', f))
        for n in bl:
            bfiles[n].add(f)
        row['llvm'] = 'ok' if src == 0 and not cats else 'fail'
        if f in comp['lenient']:
            lrc = comp['lenient'][f]['rc']
            lcats, lbl = classify_llvm(lrc, read_log(w, 'lenient', f))
            # a backend crash is only visible once the front end gets through
            for k in ('crash', 'timeout'):
                if k in lcats:
                    cats[k] = lcats[k]
            rest = {k: v for k, v in lcats.items() if k not in ('missing builtin',)}
            row['lenient'] = ('ok' if lrc == 0 and not lcats else
                              'only-missing-builtins' if not rest else 'fail')
            row['lenient_categories'] = lcats
        if f in comp['fp16probe']:
            prc = comp['fp16probe'][f]['rc']
            pcats, _ = classify_llvm(prc, read_log(w, 'fp16probe', f))
            rest = {k: v for k, v in pcats.items() if k != 'missing builtin'}
            row['fp16probe'] = ('ok' if prc == 0 and not pcats else
                                'only-missing-builtins' if not rest else 'fail')
            row['fp16probe_categories'] = pcats
        if f in comp['nodefs']:
            row['llvm_without_compat_defines'] = 'ok' if comp['nodefs'][f]['rc'] == 0 else 'fail'
        row['bucket'], row['detail'] = primary(cats)
        row['categories'] = cats
        if row['llvm'] != 'ok':
            row['needs'] = sorted(needs(row))
        rows.append(row)
    json.dump(rows, open(os.path.join(HERE, 'results.json'), 'w'), indent=1)
    bout = {}
    for n in sorted(set(bt) | set(bfiles)):
        v = bt.get(n, {'defined_in_clang': False, 'call_sites': 0, 'c_files_calling': 0})
        bout[n] = dict(v, files_failing_on_it=len(bfiles.get(n, ())))
    json.dump(bout, open(os.path.join(HERE, 'builtins.json'), 'w'), indent=1, sort_keys=True)
    summarize(rows)
    greedy(rows)


def items_of(cats):
    out = set()
    for k, v in cats.items():
        if k == 'missing builtin':
            out |= set(v)
        elif k == 'unsupported type':
            out.add('float16/float16alt types')
        elif k in ('gcc-only language feature', 'builtin argument check', 'crash', 'timeout'):
            out |= {'%s: %s' % (k, x[:90]) for x in v}
        else:
            out.add(k)
    return out


def needs(row):
    """Everything that must be fixed before this file compiles: strict errors,
    plus what the lenient (backend reached) and fp16probe (types provided) runs
    uncovered behind them."""
    n = items_of(row['categories'])
    if 'lenient_categories' in row:
        n |= items_of(row['lenient_categories'])
    if 'float16/float16alt types' in n and 'fp16probe_categories' in row:
        n |= items_of(row['fp16probe_categories']) - {'timeout: timeout'}
        n.add('float16/float16alt types')
    return n


def greedy(rows):
    fail = [set(r['needs']) for r in rows if r.get('needs')]
    chosen, done, steps = set(), 0, []
    allitems = collections.Counter(i for n in fail for i in n)
    while True:
        best, bgain = None, 0
        for it in allitems:
            if it in chosen:
                continue
            gain = sum(1 for n in fail if not n <= chosen and n <= chosen | {it})
            if gain > bgain or (gain == bgain and best and allitems[it] > allitems[best]):
                best, bgain = it, gain
        if not best or bgain == 0:
            break
        chosen.add(best)
        done += bgain
        steps.append({'fix': best, 'files_unlocked': bgain, 'cumulative': done,
                      'files_needing': allitems[best]})
    json.dump({'steps': steps, 'item_counts': allitems.most_common(),
               'never_unlocked': sum(1 for n in fail if not n <= chosen)},
              open(os.path.join(HERE, 'fix_ranking.json'), 'w'), indent=1)
    for s_ in steps[:25]:
        print('%4d %4d  %s' % (s_['files_unlocked'], s_['cumulative'], s_['fix']))


def summarize(rows):
    A = {}
    for r in rows:
        t = A.setdefault(r['area'], collections.Counter())
        t['files'] += 1
        if r['gcc'] == 'excluded':
            continue
        t['in_scope'] += 1
        if r['gcc'] == 'ok':
            t['gcc_ok'] += 1
            t['llvm_ok'] += r['llvm'] == 'ok'
    print('%-20s %6s %6s %6s %6s %7s' % ('area', 'files', 'scope', 'gcc', 'llvm', 'parity'))
    tot = collections.Counter()
    for k, t in sorted(A.items()) + [('TOTAL', None)]:
        if t is None:
            t = tot
        else:
            tot.update(t)
        print('%-20s %6d %6d %6d %6d %6.1f%%' % (k, t['files'], t['in_scope'], t['gcc_ok'],
              t['llvm_ok'], 100.0 * t['llvm_ok'] / (t['gcc_ok'] or 1)))
    print(collections.Counter(r['bucket'] for r in rows if r['gcc'] == 'ok').most_common())


RX_WERROR = re.compile(r'\[-Werror,(-W[\w-]+)\]')


def phase_parity(a):
    """strict vs the SDK-flags modes, like for like:
         strict      clang defaults, no -Werror          vs gcc    (no -Werror)
         sdknowerror SDK -W flags, no -Werror, compat     vs gcc
         sdkflags    SDK -W flags incl. -Werror, compat   vs gccsdk (GCC with the SDK's -Werror)
    A file counts as ok only if clang exits 0 AND the log has no survey
    category (so an unknown builtin demoted to a warning is still a failure).
    Writes sdkflags_parity.json next to this script."""
    w = a.work
    inv = ensure_inventory(a)
    comp = {}
    for m in ('gcc', 'gccsdk', 'strict', 'sdkflags', 'sdknowerror'):
        p = '%s/compile_%s.json' % (w, m)
        comp[m] = json.load(open(p)) if os.path.exists(p) else {}

    def ok(m, f):
        r = comp[m].get(f)
        if r is None:
            return None
        cats, _ = classify_llvm(r['rc'], read_log(w, m, f) or '')
        return r['rc'] == 0 and not cats
    rows, A = {}, collections.defaultdict(collections.Counter)
    werror_only = collections.defaultdict(list)
    for e in inv:
        f = e['file']
        if e['scope'] != 'in' or comp['gcc'].get(f, {}).get('rc') != 0:
            continue
        r = {'area': e['area'], 'gccsdk': comp['gccsdk'].get(f, {}).get('rc') == 0}
        for m in ('strict', 'sdkflags', 'sdknowerror'):
            r[m] = ok(m, f)
        rows[f] = r
        t = A[e['area']]
        t['gcc'] += 1
        t['gccsdk'] += r['gccsdk']
        for m in ('strict', 'sdkflags', 'sdknowerror'):
            t[m] += bool(r[m])
        t['sdkflags_vs_gccsdk'] += bool(r['sdkflags']) and r['gccsdk']
        if r['sdkflags'] is False and r['gccsdk']:
            log = read_log(w, 'sdkflags', f) or ''
            hard = [m_ for m_ in RX_DIAG.finditer(log) if m_.group('sev').endswith('error')
                    and not RX_WERROR.search(m_.group('msg'))]
            if not hard:
                werror_only[' '.join(sorted(set(RX_WERROR.findall(log))))].append(f)
    tot = collections.Counter()
    for t in A.values():
        tot.update(t)
    hdr = '%-20s %5s %6s %6s %6s %6s %6s' % ('area', 'gcc', 'strict', 'nowerr', 'gccW', 'sdkfl', 'sdk/W')
    print(hdr)
    for k, t in sorted(A.items()) + [('TOTAL', tot)]:
        print('%-20s %5d %6d %6d %6d %6d %6d' % (k, t['gcc'], t['strict'], t['sdknowerror'],
              t['gccsdk'], t['sdkflags'], t['sdkflags_vs_gccsdk']))
    pc = lambda n, d: round(100.0 * n / (d or 1), 1)
    summ = {
        'strict': {'ok': tot['strict'], 'of': tot['gcc'], 'parity': pc(tot['strict'], tot['gcc'])},
        'sdknowerror': {'ok': tot['sdknowerror'], 'of': tot['gcc'],
                        'parity': pc(tot['sdknowerror'], tot['gcc'])},
        'sdkflags': {'ok': tot['sdkflags_vs_gccsdk'], 'of': tot['gccsdk'],
                     'parity': pc(tot['sdkflags_vs_gccsdk'], tot['gccsdk']),
                     'ok_any': tot['sdkflags']},
        'sdkflags_fail_only_on_Werror': {k: sorted(v) for k, v in werror_only.items()},
        'clang': json.load(open(os.path.join(w, 'snap', 'snap.json')))['version']
        if os.path.exists(os.path.join(w, 'snap', 'snap.json')) else CLANG,
    }
    for k in ('strict', 'sdknowerror', 'sdkflags'):
        print('%-12s %4d / %d = %.1f%%' % (k, summ[k]['ok'], summ[k]['of'], summ[k]['parity']))
    for k, v in sorted(werror_only.items(), key=lambda kv: -len(kv[1])):
        print('sdkflags fails only on -Werror %s: %d files' % (k, len(v)))
    json.dump({'summary': summ, 'areas': {k: dict(t) for k, t in sorted(A.items())},
               'files': rows}, open(os.path.join(HERE, 'sdkflags_parity.json'), 'w'),
              indent=1, sort_keys=True)


def phase_snapshot(a):
    """Copy the clang binary + resource headers into --work so a concurrent
    rebuild of the fixed-path build dir cannot change the compiler mid-run."""
    global CLANG
    src = os.path.realpath(CLANG)
    d = os.path.join(a.work, 'snap')
    os.makedirs(d + '/bin', exist_ok=True)
    shutil.copy2(src, d + '/bin/clang')
    res = os.path.join(os.path.dirname(os.path.dirname(src)), 'lib', 'clang')
    shutil.rmtree(d + '/lib/clang', ignore_errors=True)
    shutil.copytree(res, d + '/lib/clang')
    ver = sh([d + '/bin/clang', '--version']).stdout.splitlines()[0]
    json.dump({'source': src, 'version': ver}, open(d + '/snap.json', 'w'))
    print('snapshot:', ver)


def use_snapshot(a):
    global CLANG
    p = os.path.join(a.work, 'snap', 'bin', 'clang')
    if os.path.exists(p):
        CLANG = p


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--work', default=os.environ.get('SURVEY_WORK', '/tmp/sdk-compile-survey-work'),
                    help='scratch dir (SDK app-tree copies, cmake dirs, objects, logs; ~1 GB)')
    ap.add_argument('--jobs', type=int, default=12)
    ap.add_argument('--phases', default='snapshot,configure,db,inventory,gcc,strict,lenient,nodefs,'
                    'fp16probe,gccsdk,sdkflags,sdknowerror,builtins,results,parity')
    ap.add_argument('--only', help='regex: (re)compile only matching files')
    ap.add_argument('--force', action='store_true', help='ignore cached compile results')
    a = ap.parse_args()
    a.work = os.path.abspath(a.work)
    os.makedirs(a.work, exist_ok=True)
    use_snapshot(a)
    for p in a.phases.split(','):
        if p == 'snapshot':
            phase_snapshot(a)
            use_snapshot(a)
        elif p == 'configure':
            phase_configure(a)
        elif p == 'db':
            phase_db(a)
        elif p == 'dbsnapshot':
            phase_dbsnapshot(a)
        elif p == 'inventory':
            phase_inventory(a)
        elif p in ('gcc', 'gccsdk') + tuple(MODES):
            phase_compile(a, p)
        elif p == 'parity':
            phase_parity(a)
        elif p == 'builtins':
            phase_builtins(a)
        elif p == 'results':
            phase_results(a)
        else:
            sys.exit('unknown phase ' + p)


if __name__ == '__main__':
    main()
