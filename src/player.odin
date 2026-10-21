package main

import "core:fmt"
import rl "vendor:raylib"

MAX_HP :: 100
PLAYER_INVUL_TIME :: 0.8
PLAYER_PICKUP_RADIUS :: 80.0
XP_NEXT_LEVEL :: 5

Player :: struct{
	pos : rl.Vector2,
	size : f32,
	speed : f32,
	hp : int,
	max_hp : int,
	invul_time : f32,
	level : int,
	xp : int,
}

player_init :: proc() -> Player{
	return {
		pos = {500, 500},
		speed = 400,
		size = 32,
		hp = 10,
		max_hp = MAX_HP,
		level = 1,
		xp = 0,
	}
}

player_update :: proc(player : ^Player, dt : f32){
	dir : rl.Vector2
	if rl.IsKeyDown(.W) do dir.y -= 1
	if rl.IsKeyDown(.S) do dir.y += 1
	if rl.IsKeyDown(.D) do dir.x += 1
	if rl.IsKeyDown(.A) do dir.x -= 1
	dir = rl.Vector2Normalize(dir)
	player.invul_time = max(0, player.invul_time - dt)
	player.pos += dir * player.speed * dt
}

player_draw :: proc(player : Player){
	half := rl.Vector2{player.size, player.size}/2
	rl.DrawRectangleV(player.pos - half, {player.size, player.size}, rl.WHITE)
}

player_take_damage :: proc(player : ^Player, amount : int){
	if player.invul_time > 0 do return
	player.invul_time = PLAYER_INVUL_TIME
	player.hp = max(0, player.hp - amount)
}

player_add_xp :: proc(player : ^Player, amount : int){
	player.xp += amount
	for{
		needed := player_needed_xp_for_next_level(player^)
		if player.xp < needed do break
		player.xp -= needed
		player.level += 1
	}
}

player_needed_xp_for_next_level :: proc(player : Player) -> int{
	return player.level * XP_NEXT_LEVEL
}
