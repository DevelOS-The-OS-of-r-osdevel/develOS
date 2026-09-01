#include "font.h"
#include <kernel/graphic/print.h>
#include <kernel/graphic/graphics.h>

#define FONT_WIDTH 8
#define FONT_HEIGHT 8

void printChar(char c, u64 x, u64 y, u32 color)
{
    u8 row;
    u8 bit;
    u8 character;

    character = (u8)c;

    if (character >= 132) return;

    for (row = 0; row < FONT_HEIGHT; row++)
    {
        for (bit = 0; bit < FONT_WIDTH; bit++)
        {
            if (font_8x8[character][row] & (0x80 >> bit))
            {
                drawPixel(
                    x + bit,
                    y + row,
                    color
                );
            }
        }
    }
}

void print(const char *text, u64 x, u64 y, u32 color)
{
    u64 startX;

    startX = x;

    while (*text)
    {
        if (*text == '\n')
        {
            x = startX;
            y += FONT_HEIGHT;
            text++;
            continue;
        }

        printChar(*text, x, y, color);

        x += FONT_WIDTH;
        text++;
    }
}
