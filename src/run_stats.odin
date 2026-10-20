package main

import rl "vendor:raylib"

Run_Stats :: struct{
	weapon_range : Stat,
	weapon_cooldown : Stat,
	weapon_damage : Stat,

	projectile_speed : Stat,

	gem_pickup_radius : Stat,

	enemy_hp : Stat,
	enemy_damage : Stat,
}

Stat :: struct{
	base : f32,
	flat : f32,
	percent : f32,
}

stats_init :: proc(weapon : Weapon_Def, projectile : Projectile_Def) -> Run_Stats{
	return{
		weapon_range = {
			base = weapon.range,
		},
		weapon_cooldown = {
			base = weapon.cooldown,
		},
		weapon_damage = {
			base = weapon.damage,
		},
		projectile_speed = {
			base = projectile.speed,
		},
	}
}

stat_set_base :: proc(stat : ^Stat, base : f32){
	stat.base = base
}

stat_add_flat :: proc(stat : ^Stat, amount : f32){
	stat.flat += amount
}

stat_add_percent :: proc(stat : ^Stat, amount : f32){
	stat.percent += amount
}

stat_get :: proc{
	stat_get_with_base,
	stat_get_without_base,
}

stat_get_without_base :: proc(stat : Stat, base : f32) -> f32{
	return (base + stat.flat) * (1 + stat.percent)
}

stat_get_with_base :: proc(stat : Stat) -> f32{
	return (stat.base + stat.flat) * (1 + stat.percent)
}
