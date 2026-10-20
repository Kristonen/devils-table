package main

import rl "vendor:raylib"

game_collision :: proc(){
	collide_projectiles_enemies()
	collide_enemies_player()
	collide_player_gems()
}

collide_projectiles_enemies :: proc(){
	for i := len(game.projectiles) - 1; i >= 0; i -= 1{
		hit : bool
		for j := len(game.enemies) - 1; j >= 0; j -= 1{
			p := game.projectiles[i]
			e := &game.enemies[j]
			if projectile_touches_enemy(p, e^){
				hit = true
				enemy_take_damage(e, stat_get(game.stats.weapon_damage))
				if e.hp <=0{
					xp_gem_spawn(&game.xp_gems, e.pos)
					unordered_remove(&game.enemies, j)
					break
				}
			}
		}
		if hit do unordered_remove(&game.projectiles, i)
	}
}

collide_enemies_player :: proc(){
	for e in game.enemies{
		if enemy_touches_player(e, game.player){
			player_take_damage(&game.player, e.damage)
		}
	}
}

collide_player_gems :: proc(){
	for i := len(game.xp_gems) - 1; i >= 0; i -= 1{
		g := game.xp_gems[i]
		if xp_gem_touches_player(g, game.player){
			player_add_xp(&game.player, g.value)
			unordered_remove(&game.xp_gems, i)
		}
	}
}
