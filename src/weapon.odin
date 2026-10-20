package main

import "core:math/linalg"
import rl "vendor:raylib"

WEAPON_COOLDOWN :: 0.5
WEAPON_RANGE :: 800
WEAPON_DAMAGE :: 10

Weapon_Def :: struct{
	name : string,
	cooldown : f32,
	range : f32,
	damage : f32,
}

WEAPON_PISTOL :: Weapon_Def{
	name = "Pistol",
	cooldown = 0.5,
	range = 800,
	damage = 15,
}

Weapon :: struct{
	timer : f32,
}

weapon_init :: proc() -> Weapon{
	return {
		timer = 0,
	}
}

weapon_update :: proc(weapon : ^Weapon, stats : Run_Stats, enemies : []Enemy, dt : f32){
	weapon.timer = max(0, weapon.timer - dt)
	if weapon.timer > 0 do return

	index, found := find_nearest_enemy(enemies, game.player.pos, stat_get(stats.weapon_range))
	if !found do return

	weapon.timer = stat_get(stats.weapon_cooldown)
	dir := rl.Vector2Normalize(enemies[index].pos - game.player.pos)
	projectile_spawn(&game.projectiles, game.player.pos, dir, stat_get(stats.projectile_speed))
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
