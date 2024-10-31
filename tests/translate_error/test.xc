#include <stdlib.h>

using foobar<typename a> = a;

int main() {
  // new not defined for template aliases
  size_t a = new foobar<size_t>(1, 2, 3);
}
