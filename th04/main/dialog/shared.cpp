#include "th04/main/dialog/shared.hpp"

#define DIALOG_BOX_TILE_W 16
#define DIALOG_BOX_TILE_H 4
#define DIALOG_BOX_TILE_COUNT 3

#define DIALOG_BOX_TILE_VRAM_W (DIALOG_BOX_TILE_W / BYTE_DOTS)
#define DIALOG_BOX_VRAM_W (DIALOG_BOX_W / BYTE_DOTS)

extern const dot_rect_t(DIALOG_BOX_TILE_W, DIALOG_BOX_TILE_H) DIALOG_BOX_TILES[
	DIALOG_BOX_TILE_COUNT
];

void pascal near dialog_box_put(uscreen_x_t left, uvram_y_t top, int tile)
;
