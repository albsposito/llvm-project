"""Fail-closed gtest evidence and monotonic combined lit/unit gate."""
import json
from pathlib import Path


def unit_report(path, rc):
    report = {"valid": False, "exit_code": rc, "tests": [], "failures": [], "errors": []}
    try:
        data = json.loads(Path(path).read_text())
        tests = [t for s in data["testsuites"] for t in s["testsuite"]]
        names = [t["classname"] + "." + t["name"] for t in tests]
        if not tests or len(tests) != data["tests"] or len(set(names)) != len(names):
            raise ValueError("empty, duplicate, or inconsistent unit test inventory")
        if any(t.get("status") != "RUN" or t.get("result") != "COMPLETED" for t in tests):
            raise ValueError("unit tests skipped or incomplete")
        failures = [{"test": n, "details": t["failures"]} for n, t in zip(names, tests) if t.get("failures")]
        if len(failures) != data["failures"] or data.get("errors", 0) or data.get("disabled", 0):
            raise ValueError("inconsistent unit outcome")
        if rc != (1 if failures else 0):
            raise ValueError("unit process exit disagrees with JSON")
        report.update(valid=True, tests=sorted(names), failures=failures)
    except (OSError, ValueError, KeyError, TypeError) as exc:
        report["errors"].append(str(exc))
    return report


def problem_keys(report):
    keys = {(p["test"], p["problem"]) for g in report["groups"] for p in g["tests"]}
    if len(keys) != report["problems"]:
        raise ValueError("inconsistent lit problem inventory")
    return keys


def combined_gate(before, after, rc):
    """Require no new problems/coverage loss and strict shrink unless already green."""
    try:
        a = problem_keys(after)
        au = after["unit"]
        if not au["valid"] or not au["tests"]:
            return "missing or invalid unit evidence"
        af = {f["test"] for f in au["failures"]}
        green = not a and not af
        if after["green"] != green or rc != (0 if green else 1):
            return "test command exit/report mismatch"
        if before is None:
            return None if green else "initial test gate is not green"
        b = problem_keys(before)
        bu = before["unit"]
        if not bu["valid"] or not bu["tests"]:
            return "baseline lacks valid unit evidence; regenerate baseline report"
        bf = {f["test"] for f in bu["failures"]}
        if not set(bu["tests"]) <= set(au["tests"]):
            return "unit test coverage decreased"
        if not a <= b or not af <= bf:
            return "lit or unit failure set grew"
        if (b or bf) and a == b and af == bf:
            return "combined lit/unit failure set did not shrink"
    except (KeyError, TypeError, ValueError) as exc:
        return "invalid test report: " + str(exc)
    return None
