#ifndef PRINT_H
#define PRINT_H 1

#include <types.h>

void printChar(char c, u64 x, u64 y, u32 color);
void print(const char *text, u64 x, u64 y, u32 color);

#undef PRINT_H
#endif
