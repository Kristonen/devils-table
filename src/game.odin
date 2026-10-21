package main

import "core:fmt"
import rl "vendor:raylib"

game : Game

Game_Phase :: enum{
	Playing, Dead, Level_Up,
}

Game :: struct{
	dt : f32,
	phase : Game_Phase,
	camera : rl.Camera2D,
	stats : Run_Stats,

	player : Player,
	weapon : Weapon,
	projectiles : [dynamic]Projectile,

	enemies : [dynamic]Enemy,

	xp_gems : [dynamic]Xp_Gem,

	spawn_timer : f32,
	weapon_timer : f32,
	debug_mode : bool,
}

game_init :: proc(){
	game_destroy()
	player := player_init()
	game = {
		player = player,
		weapon = weapon_init(),
		camera = {
			target = player.pos,
			offset = {WINDOW_WIDTH/2, WINDOW_HEIGHT/2},
			zoom = 1,
		},
		stats = stats_init(WEAPON_PISTOL, PROJECTILE_NORMAL),
	}
	// stat_set_base(&game.stats.weapon_damage, 10)
	// stat_add_flat(&game.stats.weapon_damage, 40)
}

game_destroy :: proc(){
	// Was muss gereinigt werden
	delete(game.enemies)
	delete(game.projectiles)
	delete(game.xp_gems)
}

game_update :: proc(){
	if game.phase == .Dead do return

	game.dt = rl.GetFrameTime()
	player_update(&game.player, game.dt)
	weapon_update(&game.weapon, game.stats, game.enemies[:], game.dt)
	camera_update(&game.camera, game.player, game.dt)
	projectile_update(&game.projectiles, game.dt)
	xp_gem_update(game.xp_gems[:], game.player.pos, stat_get(game.stats[.Pickup_Radius]), game.dt)

	game.spawn_timer += game.dt
	if game.spawn_timer >= SPAWN_INTERVAL{
		game.spawn_timer = 0
		enemy_spawn(&game.enemies, game.player.pos)
	}

	if rl.IsKeyPressed(.F2){
		game.debug_mode = !game.debug_mode
	}

	enemy_update(game.enemies[:], game.player.pos, game.dt)
	game_collision()
	if game.player.hp <=0{
		game.phase = .Dead
	}else if game.player.pending_level_ups > 0{
		game.phase = .Level_Up
	}

	if rl.IsKeyPressed(.ONE){
		upgrade_apply(&game.stats, UPGRADES[3])
	}
}

game_draw :: proc(){
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.BLACK)
	game_draw_mode()
	progress_bar_draw({50, WINDOW_HEIGHT - 200}, f32(game.player.hp), f32(game.player.max_hp))
	progress_bar_draw({50, WINDOW_HEIGHT - 100}, f32(game.player.xp), f32(player_needed_xp_for_next_level(game.player)))

	switch game.phase{
	case .Playing:
	case .Dead:
		game_draw_end()
	case .Level_Up:

	}
}

game_draw_mode :: proc(){
	rl.BeginMode2D(game.camera)
	defer rl.EndMode2D()
	player_draw(game.player)
	enemy_draw(game.enemies[:])
	projectile_draw(game.projectiles[:])
	xp_gem_draw(game.xp_gems[:])
	if game.debug_mode do game_debug_draw_mode()
}

game_debug_draw_mode :: proc(){

	radius := stat_get(game.stats[.Weapon_Range])
	rl.DrawCircleV(game.player.pos, radius, {255, 0, 0, 150})

	radius = stat_get(game.stats[.Pickup_Radius])
	rl.DrawCircleV(game.player.pos, radius, {100, 100, 100, 150})


	// rl.DrawCircleLinesV(game.player.pos, radius, {100, 100, 100, 255})
}

game_draw_end :: proc(){
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.BLACK)
	text : cstring = "YOU ARE DEAD!\nPress Space to restart"
	width := rl.MeasureText(text, 50)
	x := i32(WINDOW_WIDTH/2 - width/2)
	y := i32(WINDOW_HEIGHT/2 - 25)
	rl.DrawText(text, x, y, 50, rl.WHITE)
}
