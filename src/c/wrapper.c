#include <stdlib.h>
#include <stdio.h>

#include "print_proc.h"

const long value0 = 0;


void wrapper(long value);

int main(int argc, char *argv[]){
  if (argc <= 1) return EXIT_SUCCESS;

  int value = atoi(argv[1]);

  printf("input 0: %d\n", value);
  
  wrapper(value);
  
  return EXIT_SUCCESS;
}

void wrapper(long value){
  int ola[128] = {};
  ola[0] = 9;
  ola[120] = -3;

  print_hex(value);  
  print_u64(value);
  print_i64(value);  
  print_i32(value);  
  print_i16(value);   
}
