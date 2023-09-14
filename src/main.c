#include <stdio.h>

int main () {
#ifdef __CALYPSI_TARGET_SYSTEM_C64__
  printf("HELLO WORLD!\n");
#else
  printf("Hello World!\n");
#endif
  return 0;
}
