void cli(void)
{
    __asm__ volatile("cli");
}
void sti(void)
{
    __asm__ volatile("sti");
}

// Full system halt
__attribute__((noreturn)) void chalt(void)
{
    cli();
    for (;;) __asm__ volatile("hlt");
}

void halt(void)
{
    __asm__ volatile("hlt");
}

__attribute__((noreturn)) void idle(void)
{
    for (;;) halt();
}

// wait for interupt
void wfi(void)
{
    __asm__ volatile("sti; pause; hlt");
}

void nop(void)
{
	__asm__ volatile("nop");
}
