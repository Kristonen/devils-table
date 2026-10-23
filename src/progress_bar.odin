package main

import "core:fmt"
import rl "vendor:raylib"

PROGRESS_BAR_PADDING :: 5
PROGRESS_BAR_WIDTH :: 200
PROGRESS_BAR_HEIGHT :: 50

progress_bar_draw :: proc(pos : rl.Vector2, value : f32, max_value : f32, show_text : bool = false, fill_color : rl.Color = rl.RED){
	// Hintergrund Balken
	rl.DrawRectangleV(pos, {PROGRESS_BAR_WIDTH, PROGRESS_BAR_HEIGHT}, rl.GRAY)
	// Lebensbalken
	width := value/max_value * PROGRESS_BAR_WIDTH
	rl.DrawRectangleV(pos, {width, PROGRESS_BAR_HEIGHT}, fill_color)
	rec_healthbar := rl.Rectangle{
		x = pos.x,
		y = pos.y,
		width = PROGRESS_BAR_WIDTH,
		height = PROGRESS_BAR_HEIGHT,
	}
	rl.DrawRectangleLinesEx(rec_healthbar, PROGRESS_BAR_PADDING, rl.WHITE)

	if show_text{
		text := fmt.ctprintf("%v/%v", value, max_value)
		draw_text_centered(text, i32(pos.x) + PROGRESS_BAR_WIDTH/2, i32(pos.y) + PROGRESS_BAR_HEIGHT/2 - 10, 20, rl.WHITE)
	}
}
