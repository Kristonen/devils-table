package main

import rl "vendor:raylib"

SPAWN_INTERVAL :: 1.0

Spawner :: struct{
	timer : f32,
	interval : f32,
	max_amount : int,
}

spawner_update :: proc(spawner : ^Spawner, dt : f32){
	spawner.timer = max(0, spawner.timer - dt)
}

spawner_try_spawn :: proc(spawner : ^Spawner, alive : int) -> bool{
	if alive >= spawner.max_amount do return false
	if spawner.timer > 0 do return false
	spawner.timer = spawner.interval
	return true
}
