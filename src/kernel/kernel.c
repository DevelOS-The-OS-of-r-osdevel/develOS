//graphics
#include <kernel/graphic/graphics.h>
#include <kernel/graphic/print.h>

// arch specific
#include <kernel/arch/x86_64/halt.h>

//drivers
#include <drivers/x86_64/fb/fb.h>

void kernelMain(void)
{
    {
        if (
            framebuffer_request.response == NULL ||
            framebuffer_request.response->framebuffer_count < 1
        ){
            hcf();
        }

        graphicsInit();
        clearScreen(BLACK);
    }

    //TODO:
    // scrolling system
    print("=======", 0, 0, BLUE); //colors should work too
    print("develOS", 0, 10, WHITE);

    hcf(); // otherwise we reboot
}
