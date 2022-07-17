// The intended palette for a boss, with no effects applied. Used as the
// reference palette for undoing color flashing in boss_hit_update_and_render().
// MODDERS: Merge with the [stage_palette].
extern Palette4 boss_palette;

#define boss_palette_snap_inlined() { \
	int col; \
	int comp; \
	palette_copy(boss_palette, z_Palettes, col, comp); \
}

// Overwrites [boss_palette] with [z_Palettes].
void boss_palette_snap(void);

// Sets both [z_Palettes] and the hardware palette to [boss_palette].
void boss_palette_show(void);
