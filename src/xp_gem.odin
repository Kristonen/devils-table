package main

import "core:fmt"
import rl "vendor:raylib"

Xp_Gem :: struct{
	pos : rl.Vector2,
	size : f32,
	value : int,
	is_follow : bool,
	follow_speed : f32,
}

xp_gem_spawn :: proc(gems : ^[dynamic]Xp_Gem, pos : rl.Vector2){
	append(gems, Xp_Gem{
		pos = pos,
		size = 12,
		value = 5,
		follow_speed = 800,
	})
}

xp_gem_update :: proc(gems : []Xp_Gem, to : rl.Vector2, radius : f32, dt : f32){
	for &g in gems{
		if !g.is_follow && xp_gem_in_reach(g, to, radius){
			g.is_follow = true
		}
		if !g.is_follow do continue

		dir := rl.Vector2Normalize(to - g.pos)
		g.pos += dir * g.follow_speed * dt
	}
}

xp_gem_draw :: proc(gems : []Xp_Gem){
	for g in gems{
		half := rl.Vector2{g.size, g.size}/2
		rl.DrawRectangleV(g.pos - half, {g.size, g.size}, rl.SKYBLUE)
	}

}

xp_gem_touches_player :: proc(gem : Xp_Gem, player : Player) -> bool{
	return rl.Vector2Distance(gem.pos, player.pos) < gem.size/2 + player.size/2
}

xp_gem_in_reach :: proc(gem : Xp_Gem, pos : rl.Vector2, radius : f32) -> bool{
	return rl.Vector2Distance(gem.pos, pos) < radius + gem.size/2
}
