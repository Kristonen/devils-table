package main

import rl "vendor:raylib"

PROJECTILE_SPEED :: 700
PROJECTILE_RADIUS :: 6
PROJECTILE_LIFETIME :: 2.0

Projectile_Def :: struct{
	speed : f32,
}

PROJECTILE_NORMAL :: Projectile_Def{
	speed = 750,
}

Projectile :: struct{
	pos : rl.Vector2,
	dir : rl.Vector2,
	life : f32,
	speed : f32,
}

projectile_spawn :: proc(projectiles : ^[dynamic]Projectile, from : rl.Vector2, dir : rl.Vector2, speed : f32){
	append(projectiles, Projectile{
		pos = from,
		dir = dir,
		life = PROJECTILE_LIFETIME,
		speed = speed,
	})
}

projectile_update :: proc(projectiles : ^[dynamic]Projectile, dt : f32){
	for i := len(projectiles) - 1; i >= 0; i -= 1{
		p := &projectiles[i]
		p.pos += p.dir * PROJECTILE_SPEED * dt
		p.life = max(0, p.life - dt)

		if p.life == 0{
			unordered_remove(projectiles, i)
		}
	}
}

projectile_draw :: proc(projectiles : []Projectile){
	for p in projectiles{
		rl.DrawCircleV(p.pos, PROJECTILE_RADIUS, rl.YELLOW)
	}
}

projectile_touches_enemy :: proc(projectile : Projectile, enemy : Enemy) -> bool{
	return rl.Vector2Distance(projectile.pos, enemy.pos) < PROJECTILE_RADIUS + enemy.size/2
}
