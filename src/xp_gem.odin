package main

import rl "vendor:raylib"

Xp_Gem :: struct{
	pos : rl.Vector2,
	size : f32,
	value : int,
}

xp_gem_spawn :: proc(gems : ^[dynamic]Xp_Gem, pos : rl.Vector2){
	append(gems, Xp_Gem{
		pos = pos,
		size = 12,
		value = 3,
	})
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
