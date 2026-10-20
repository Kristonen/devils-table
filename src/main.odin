package main

import "core:fmt"
import "core:mem"
import rl "vendor:raylib"

WINDOW_WIDTH :: 1920
WINDOW_HEIGHT :: 1080

main :: proc(){

	track : mem.Tracking_Allocator
	mem.tracking_allocator_init(&track, context.allocator)
	defer mem.tracking_allocator_destroy(&track)
	context.allocator = mem.tracking_allocator(&track)

	defer{
		if len(track.allocation_map) > 0{
			fmt.printf("=== %v Memory Leaks gefunden ===\n", len(track.allocation_map))
			for _, entry in track.allocation_map{
				fmt.printf("- %v Bytes allokiert bei %v\n", entry.size, entry.location)
			}
		}

		if len(track.bad_free_array) > 0{
			fmt.printf("=== %v ungültige Frees gefunden! ===\n", len(track.bad_free_array))
			for entry in track.bad_free_array{
				fmt.printf("- Invalide Free bei %v\n", entry.location)
			}
		}
	}


	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Slaughter them all")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	game_init()
	defer game_destroy()

	for !rl.WindowShouldClose(){
		switch game.phase{
		case .Playing:
			game_update()
			game_draw()
		case .Dead:
			game_draw_end()
			if rl.IsKeyPressed(.SPACE){
				game_init()
			}
		}
		free_all(context.temp_allocator)
	}
}
