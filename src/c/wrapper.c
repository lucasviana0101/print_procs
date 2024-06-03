#include <stdlib.h>
#include <stdio.h>

#include "print_procs.h"


void wrapper(long value);

int main(int argc, char *argv[]){
  if (argc <= 2) return EXIT_SUCCESS;

  char *ptr;
  
  long value0 = strtol(argv[1], &ptr, 16);
  long value1 = strtol(argv[2], &ptr, 16);

  long value = value0 + value1;
  
  printf("input 0: %ld\n" "input 1: %ld\n" "value: %ld\n",
        value0,
        value1,
        value
  );
  
  wrapper(value);
  
  return EXIT_SUCCESS;
}

void wrapper(long value){
  print_hex((unsigned long)value);  

  print_u64((unsigned long)value);

  print_i64((long)value);

  print_i32((int)value);

  print_i16((short)value);
}
