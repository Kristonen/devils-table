package main

import "core:fmt"
import rl "vendor:raylib"

game : Game

Game_Phase :: enum{
	Playing, Dead, Level_Up, Finished
}

Game :: struct{
	dt : f32,
	phase : Game_Phase,
	camera : rl.Camera2D,
	stats : Run_Stats,
	input : Input_Manager,
	goal : Goal,
	kills : int,
	alive : int,

	player : Player,
	weapon : Weapon,
	projectiles : [dynamic]Projectile,

	enemies : [dynamic]Enemy,
	spawner : Spawner,

	xp_gems : [dynamic]Xp_Gem,

	upgrades : [3]int,
	upgrade_count : int,
	hovered_upgrade : int,

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
		goal = Goal_Kill{
			amount = 20,
		},
		camera = {
			target = player.pos,
			offset = {WINDOW_WIDTH/2, WINDOW_HEIGHT/2},
			zoom = 1,
		},
		spawner = {
			max_amount = 2,
		},
		stats = stats_init(WEAPON_PISTOL, PROJECTILE_NORMAL),
	}
}

game_destroy :: proc(){
	// Was muss gereinigt werden
	delete(game.enemies)
	delete(game.projectiles)
	delete(game.xp_gems)
}

game_frame :: proc(){
	game_step()
	game_draw()
}

game_step :: proc(){
	input_update(&game.input)
	switch game.phase{
	case .Playing:
		game_update()
	case .Dead:
		if rl.IsKeyPressed(.SPACE) do game_init()
	case .Level_Up:
		game_level_up()
	case .Finished:
		game_init()
	}
}

game_update :: proc(){
	if game.phase == .Dead do return

	game.dt = rl.GetFrameTime()
	player_update(&game.player, game.dt)
	weapon_update(&game.weapon, game.stats, game.enemies[:], game.dt)
	enemy_update(game.enemies[:], game.player.pos, game.dt)
	spawner_update(&game.spawner, game.dt)
	camera_update(&game.camera, game.player, game.dt)
	projectile_update(&game.projectiles, game.dt)
	xp_gem_update(game.xp_gems[:], game.player.pos, stat_get(game.stats[.Pickup_Radius]), game.dt)
	goal_update(&game.goal, game.dt)

	if spawner_try_spawn(&game.spawner, game.alive){
		game.spawner.timer = SPAWN_INTERVAL
		game.alive += 1
		enemy_spawn(&game.enemies, game.player.pos)
	}

	if rl.IsKeyPressed(.F2){
		game.debug_mode = !game.debug_mode
	}


	game_collision()

	if game.player.hp <=0{
		game.phase = .Dead
	}else if game.player.pending_level_ups > 0{
		game.phase = .Level_Up
		game.upgrades, game.upgrade_count = upgrade_roll_choices()
	} else if goal_finished(game.goal, game.kills){
		game.phase = .Finished
	}
}

game_collision :: proc(){
	collide_projectiles_enemies()
	collide_enemies_player()
	collide_player_gems()
}

game_level_up :: proc(){
	mouse := rl.GetMousePosition()
	panel := upgrade_panel_rec(game.upgrade_count)
	game.hovered_upgrade = -1
	for card in 0..<game.upgrade_count{
		rec := upgrade_card_rec(card, panel)
		if rl.CheckCollisionPointRec(mouse, rec){
			game.hovered_upgrade = card
			break
		}
	}

	if game.hovered_upgrade != -1 && game.input.pressed[.Left] do game_pick_upgrade(game.hovered_upgrade)
}

game_pick_upgrade :: proc(slot : int){
	upgrade := UPGRADES[game.upgrades[slot]]
	upgrade_apply(&game.stats, upgrade)
	game.player.pending_level_ups -= 1
	if game.player.pending_level_ups > 0 do game.upgrades, game.upgrade_count = upgrade_roll_choices()
	else do game.phase = .Playing
}

game_draw :: proc(){
	rl.BeginDrawing()
	defer rl.EndDrawing()
	rl.ClearBackground(rl.BLACK)
	game_draw_mode()
	progress_bar_draw({50, WINDOW_HEIGHT - 200}, f32(game.player.hp), f32(game.player.max_hp), true)
	progress_bar_draw({50, WINDOW_HEIGHT - 100}, f32(game.player.xp), f32(player_needed_xp_for_next_level(game.player)), true, rl.BLUE)
	goal_draw(game.goal, game.kills)

	switch game.phase{
	case .Playing:
	case .Dead:
		game_draw_end()
	case .Level_Up:
		game_draw_level_up()
	case .Finished:
	}

	if game.debug_mode do game_debug_draw()
}

game_debug_draw :: proc(){
	rl.DrawFPS(WINDOW_WIDTH - 100, 50)
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

game_draw_level_up :: proc(){
	rl.DrawRectangleV({0, 0}, {WINDOW_WIDTH, WINDOW_HEIGHT}, rl.Fade(rl.BLACK, 0.7))
	panel := upgrade_panel_rec(game.upgrade_count)
	for index in 0..<game.upgrade_count{
		rec_upgrade := upgrade_card_rec(index, panel)
		upgrade := UPGRADES[game.upgrades[index]]
		upgrade_card_draw(rec_upgrade, index + 1, upgrade, index == game.hovered_upgrade)
	}
}
