#include "defconv.h"

// Blits the rectangle from (⌊x/16⌋*16, y) to (⌈((x + w)/16)*16⌉, (y + h))
// from VRAM page 1 to the same position on VRAM page 0.
void DEFCONV egc_copy_rect_1_to_0_16(screen_x_t x, vram_y_t y, int w, int h);
