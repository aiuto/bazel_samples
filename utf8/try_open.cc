/* Try opening files with both utf-8 NFC and NFD paths.
 *
 */

#include <cstring>
#include <iostream>
#include <stdio.h>

int try_open(const char* name, int expected_len) {
  if (strlen(name) != expected_len) {
    std::cout << "For file name " << name << ", expected "
              << expected_len << " bytes, got " << strlen(name)
              << std::endl;
  }
  FILE *inp = fopen(name, "r");
  if (inp == NULL) {
    std::cout << "Could not open " << name << std::endl;
    return 1;
  } else {
    std::cout << "PASS: " << name << std::endl;
  }
  fclose(inp);
  return 0;
}


int main(int argc, char *argv[]) {
  // UTF-8, NFC encoding
  try_open("1-a", 3);
  try_open("2-λ", 4);
  try_open("3-世", 5);
  try_open("sübdir/2-λ", 12);

  // UTF-8, NFD encoding
  try_open("su\314\210bdir/2-λ", 13);
  return 0;
}
