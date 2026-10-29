package main

import "core:math"
import "core:math/rand"
import rl "vendor:raylib"

SPAWN_DISTANCE :: 1200

Enemy_Kind :: enum{
	Standard, Grobian, Spezialist, Champion, Boss,
}

Enemy :: struct{
	kind : Enemy_Kind,
	pos : rl.Vector2,
	size : f32,
	speed : f32,
	damage : int,
	hp : f32,
	xp : int,
}

Enemy_Def :: struct{
	size : f32,
	speed : f32,
	hp : f32,
	damage : int,
	xp_value : int,
	color : rl.Color,
}

ENEMY_DEFS := [Enemy_Kind]Enemy_Def{
	.Standard = {size = 24, speed = 150, hp = 50, damage = 10, xp_value = 3, color = rl.RED},
	.Grobian = {size = 40, speed = 125, hp = 40, damage = 20, xp_value = 8, color = rl.GREEN},
	.Spezialist = {},
	.Champion = {},
	.Boss = {},
}

enemy_spawn :: proc(enemies : ^[dynamic]Enemy, center : rl.Vector2, kind : Enemy_Kind){
	angle := rand.float32() * math.TAU
	offset := rl.Vector2Rotate({SPAWN_DISTANCE, 0}, angle)
	enemy_def := ENEMY_DEFS[kind]
	append(enemies, Enemy{
		kind = kind,
		pos = center + offset,
		size = enemy_def.size,
		speed = enemy_def.speed,
		damage = enemy_def.damage,
		hp = enemy_def.hp,
		xp = enemy_def.xp_value,
	})
	// append(enemies, Enemy{
	// 	pos = center + offset,
	// 	size = rand.float32_range(16, 28),
	// 	speed = 150,
	// 	damage = 2,
	// 	hp = 50,
	// 	xp = rand.int_range(2, 8)
	// })
}

enemy_update :: proc(enemies : []Enemy, target : rl.Vector2, dt : f32){
	for &e in enemies{
		dir := rl.Vector2Normalize(target - e.pos)
		e.pos += dir * e.speed * dt
	}
}

enemy_draw :: proc(enemies : []Enemy){
	for e in enemies{
		half := rl.Vector2{e.size, e.size}/2
		rl.DrawRectangleV(e.pos - half, {e.size, e.size}, ENEMY_DEFS[e.kind].color)
	}
}

enemy_touches_player :: proc(enemy : Enemy, player : Player) -> bool{
	return rl.Vector2Distance(enemy.pos, player.pos) < enemy.size/2 + player.size/2
}

enemy_take_damage :: proc(enemy : ^Enemy, amount : f32){
	enemy.hp = max(0, enemy.hp - amount)
}

enemy_count_by_kind :: proc(enemies : []Enemy) -> (counts : [Enemy_Kind]int){
	for e in enemies{
		counts[e.kind] += 1
	}
	return
}
