package main

import rl "vendor:raylib"

Stat :: struct{
	base : f32,
	flat : f32,
	percent : f32,
}

Stat_Id :: enum{
	Weapon_Range,
	Weapon_Cooldown,
	Weapon_Damage,

	Projectile_Speed,

	Pickup_Radius,

	Enemy_HP,
	Enemy_Damage,
}

Run_Stats :: [Stat_Id]Stat

stats_init :: proc(weapon : Weapon_Def, projectile : Projectile_Def) -> Run_Stats{
	stats : Run_Stats
	stats[.Weapon_Range].base = weapon.range
	stats[.Weapon_Cooldown].base = weapon.cooldown
	stats[.Weapon_Damage].base = weapon.damage
	stats[.Projectile_Speed].base = projectile.speed
	stats[.Pickup_Radius].base = PLAYER_PICKUP_RADIUS
	return stats
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
