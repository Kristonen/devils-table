package main

import "core:fmt"
import rl "vendor:raylib"

SPAWN_INTERVAL :: 1.0

Spawn_Stage :: struct{
	from : f32,
	interval : f32,
	max_alive : int,
}

Spawner :: struct{
	timer : f32,
	interval : f32,
	max_amount : int,
}

SPAWN_STAGES := [?]Spawn_Stage{
	{
		from = 0,
		interval = 2,
		max_alive = 5,
	},
	{
		from = 0.1,
		interval = 1.5,
		max_alive = 7,
	},
	{
		from = 0.25,
		interval = 1,
		max_alive = 10,
	},
	{
		from = 0.50,
		interval = 0.5,
		max_alive = 20,
	},
	{
		from = 0.75,
		interval = 0.25,
		max_alive = 30,
	},
}

spawner_update :: proc(spawner : ^Spawner, dt : f32){
	spawner.timer = max(0, spawner.timer - dt)
}

spawn_stage_at :: proc(progress : f32) -> Spawn_Stage{
	result := SPAWN_STAGES[0]
	for stage in SPAWN_STAGES{
		if progress >= stage.from do result = stage
	}
	return result
}

spawner_try_spawn :: proc(spawner : ^Spawner, alive : int) -> bool{
	if alive >= spawner.max_amount do return false
	if spawner.timer > 0 do return false
	spawner.timer = spawner.interval
	return true
}
