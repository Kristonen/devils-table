package main

import "core:fmt"
import rl "vendor:raylib"

collide_projectiles_enemies :: proc(){
	for i := len(game.projectiles) - 1; i >= 0; i -= 1{
		for j := len(game.enemies) - 1; j >= 0; j -= 1{
			e := &game.enemies[j]
			if !projectile_touches_enemy(game.projectiles[i], e^) do continue
			enemy_take_damage(e, stat_get(game.stats[.Weapon_Damage]))
			fmt.println(stat_get(game.stats[.Weapon_Damage]))
			if e.hp <=0{
				xp_gem_spawn(&game.xp_gems, e.pos, e.xp)
				unordered_remove(&game.enemies, j)
				game.kills += 1
				break
			}
			unordered_remove(&game.projectiles, i)
			break
		}
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
	radius := stat_get(game.stats[.Pickup_Radius])
	for i := len(game.xp_gems) - 1; i >= 0; i -= 1{
		g := game.xp_gems[i]
		if xp_gem_touches_player(g, game.player){
			player_add_xp(&game.player, g.value)
			unordered_remove(&game.xp_gems, i)
		}
	}
}
