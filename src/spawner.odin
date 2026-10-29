package main

import "core:math/rand"
import "core:fmt"
import rl "vendor:raylib"

SPAWN_INTERVAL :: 1.0

Spawn_Stage :: struct{
	from : f32,
	interval : f32,
	batch : int,
	limit : [Enemy_Kind]int,
}

Spawner :: struct{
	timer : f32,
	interval : f32,
	batch : int,
	limit : [Enemy_Kind]int,
}

SPAWN_STAGES := [?]Spawn_Stage{
	{
		from = 0,
		interval = 2,
		batch = 1,
		limit = {
			.Standard = 10,
			.Grobian = 0,
			.Spezialist = 0,
			.Champion = 0,
			.Boss = 0,
		}
	},
	{
		from = 0.1,
		interval = 1.5,
		batch = 2,
		limit = {
			.Standard = 20,
			.Grobian = 5,
			.Spezialist = 0,
			.Champion = 0,
			.Boss = 0,
		}
	},
	{
		from = 0.25,
		interval = 1,
		batch = 6,
	},
	{
		from = 0.50,
		interval = 0.5,
		batch = 8,
	},
	{
		from = 0.75,
		interval = 0.25,
		batch = 10,
	},
}

spawner_update :: proc(spawner : ^Spawner, dt : f32){
	spawner.timer = max(0, spawner.timer - dt)
}

spawner_ready :: proc(spawner : Spawner) -> bool{
	return spawner.timer <= 0
}

spawner_next_kind :: proc(spawner : Spawner, alive : [Enemy_Kind]int) -> (kind : Enemy_Kind, ok : bool){
	best_gap := 0
	for count, k in alive{
		gap := spawner.limit[k] - count
		if gap > best_gap{
			best_gap = gap
			kind = k
			ok = true
		}
	}
	return
}

spawn_stage_at :: proc(progress : f32) -> Spawn_Stage{
	result := SPAWN_STAGES[0]
	for stage in SPAWN_STAGES{
		if progress >= stage.from do result = stage
	}
	return result
}

spawner_try_spawn :: proc(spawner : ^Spawner, alive : [Enemy_Kind]int) -> (kind : Enemy_Kind, ok : bool){
	// if alive >= spawner.max_alive do return false
	if spawner.timer > 0 do return

	best_gap := 0
	for count, k in alive{
		gap := spawner.limit[k] - count
		if gap > best_gap{
			best_gap = gap
			kind = k
		}
	}
	if best_gap == 0 do return

	spawner.timer = spawner.interval
	return kind, true
}

spawner_pick_kind :: proc(spawner : Spawner) -> Enemy_Kind{
	total := 0
	for w in spawner.limit do total += w
	if total <= 0 do return .Standard

	roll := rand.int_max(total)
	for w, kind in spawner.limit{
		roll -= spawner.limit[kind]
		if roll < 0 do return kind
	}
	return .Standard
}
