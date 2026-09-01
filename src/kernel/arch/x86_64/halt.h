#pragma once

#include <types.h>
//#include <limine/limine.h>


// halt
static inline void hcf(void)
{
    for (;;)
    {
        __asm__ volatile ("hlt");
    }
}

// simple delay
static inline void delay(u32 count)
{
    for (volatile u32 i = 0; i < count * 10000000; i++) //works btw o.o
    {
        __asm__ volatile ("nop");
    }
}


void cli(void);
void sti(void);
__attribute__((noreturn)) void chalt(void);
void halt(void);
__attribute__((noreturn)) void idle(void);
void wfi(void);
void nop(void);
