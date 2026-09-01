#include <limine/limine.h>
#include <types.h>

__attribute__((used, section(".requests")))
volatile struct limine_framebuffer_request framebuffer_request =
{
    .id = LIMINE_FRAMEBUFFER_REQUEST_ID,
    .revision = 0,
    .response = NULL
};
