#include <stdio.h>

int main () {
#ifdef COMMODORE
  printf("HELLO WORLD!\n");
#else
  printf("Hello World!\n");
#endif
  return 0;
}
