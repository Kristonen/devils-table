package main

import "core:math/linalg"
import rl "vendor:raylib"

WEAPON_COOLDOWN :: 0.5
WEAPON_RANGE :: 800
WEAPON_DAMAGE :: 10

Weapon :: struct{
	timer : f32,
	cooldown : f32,
	range : f32,
}

weapon_init :: proc() -> Weapon{
	return {
		timer = 0,
		cooldown = WEAPON_COOLDOWN,
		range = WEAPON_RANGE,
	}
}

weapon_update :: proc(weapon : ^Weapon, enemies : []Enemy, dt : f32){
	weapon.timer = max(0, weapon.timer - dt)
	if weapon.timer > 0 do return

	index, found := find_nearest_enemy(enemies, game.player.pos, weapon.range)
	if !found do return

	weapon.timer = weapon.cooldown
	dir := rl.Vector2Normalize(enemies[index].pos - game.player.pos)
	projectile_spawn(&game.projectiles, game.player.pos, dir)
}

find_nearest_enemy :: proc(enemies : []Enemy, from : rl.Vector2, max_range : f32) -> (index : int, found : bool){
	best := max_range * max_range
	for e, i in enemies{
		d := linalg.length2(e.pos - from)
		if d <= best{
			best = d
			index = i
			found = true
		}
	}
	return
}
