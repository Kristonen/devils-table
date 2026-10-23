package main

import rl "vendor:raylib"

SPAWN_INTERVAL :: 1.0

Spawner :: struct{
	timer : f32,
	amount : int,
	max_amount : int,
}

spawner_update :: proc(spawner : ^Spawner, dt : f32){
	spawner.timer = max(0, spawner.timer - dt)
}

spawner_can_spawn :: proc(spawner : Spawner) -> bool{
	if spawner.amount >= spawner.max_amount do return false
	return spawner.timer == 0
}
