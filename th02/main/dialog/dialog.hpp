// ID of the next dialog box to be shown.
extern uint8_t dialog_box_cur;

// Loads the dialog text file for the current stage into the internal,
// statically allocated buffer, and resets [dialog_box_cur].
void dialog_load_and_init(void);

// Stage-specific hardcoded "scripts"
// ----------------------------------
// All of these start at [dialog_box_cur] within the text previously loaded via
// dialog_load_and_init(), and increment that variable for every box displayed.

enum dialog_sequence_t {
	DS_PREBOSS = 0,
	DS_POSTBOSS = 1,
	DS_COUNT = 2,

	_dialog_sequence_t_FORCE_INT16 = 0x7FFF,
};

// Shows the generic part of the current stage's given dialog [sequence], using
// hardcoded face IDs and box counts.
void pascal near dialog_script_generic_part_animate(dialog_sequence_t sequence);
// ----------------------------------
