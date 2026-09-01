#include <drivers/x86_64/fb/fb.h>
#include <kernel/graphic/graphics.h>

static u8 *framebuffer;
static u64 width;
static u64 height;
static u64 pitch;
static u16 bpp;

void graphicsInit(void)
{
    struct limine_framebuffer *fb;
    fb = framebuffer_request.response->framebuffers[0];

    framebuffer = fb->address;
    width = fb->width;
    height = fb->height;
    pitch = fb->pitch;
    bpp = fb->bpp;
}

void drawPixel(u64 x, u64 y, u32 color)
{
    u32 *pixel;

    if (framebuffer == 0) return;
    if (x >= width || y >= height) return;

    pixel = (u32 *)(framebuffer + y * pitch + x * (bpp / 8));
    *pixel = color;
}

void clearScreen(u32 color)
{
    u64 x;
    u64 y;

    //draws pixel per pixel
    // TODO:
    // remove line after line
    for (y = 0; y < height; y++)
    {
        for (x = 0; x < width; x++)
        {
            drawPixel(x, y, color);
        }
    }
}
