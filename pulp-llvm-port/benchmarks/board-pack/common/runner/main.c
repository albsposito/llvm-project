/* Placeholder app for scripts/run_prebuilt.sh: it is built with the local SDK only so that the
 * SDK's `run` target exists; pack.cmake then replaces its ELF with the prebuilt one
 * (-DPACK_PREBUILT_ELF=<elf>). If you see this line, the replacement did not happen. */
#include "pack.h"
int main(void)
{
    printf("board-pack runner placeholder: PACK_PREBUILT_ELF was not applied\n");
    return 1;
}
