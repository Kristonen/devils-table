package main

import rl "vendor:raylib"

SPAWN_INTERVAL :: 1.0

Spawn_Stage :: struct{
	part : int,
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
		part = 0,
		interval = 2,
		max_alive = 5,
	},
	{
		part = 25,
		interval = 1,
		max_alive = 10,
	},
	{
		part = 50,
		interval = 0.5,
		max_alive = 20,
	},
	{
		part = 75,
		interval = 0.25,
		max_alive = 30,
	},
}

spawner_update :: proc(spawner : ^Spawner, dt : f32){
	spawner.timer = max(0, spawner.timer - dt)
}

spawn_stage_check :: proc(spawner : ^Spawner, part : int){
	for stage in SPAWN_STAGES{
		if stage.part == part{
			spawner.interval = stage.interval
			spawner.max_amount = stage.max_alive
		}
	}
}

spawner_try_spawn :: proc(spawner : ^Spawner, alive : int) -> bool{
	if alive >= spawner.max_amount do return false
	if spawner.timer > 0 do return false
	spawner.timer = spawner.interval
	return true
}
