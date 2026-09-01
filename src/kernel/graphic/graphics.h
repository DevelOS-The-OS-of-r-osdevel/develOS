#ifndef GRAPHICS_H
#define GRAPHICS_H 1

#include <types.h>

#include "colors.h"

void graphicsInit(void);
void clearScreen(u32 color);
void drawPixel(u64 x, u64 y, u32 color);

#undef GRAPHICS_H
#endif
