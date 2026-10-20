package main

import "core:math/linalg"
import "core:math"
import rl "vendor:raylib"

CAMERA_FOLLOW_SPEED :: 8.0

camera_update :: proc(camera : ^rl.Camera2D, player : Player, dt : f32){
	t := 1 - math.exp(-CAMERA_FOLLOW_SPEED * dt)
	camera.target = linalg.lerp(camera.target, player.pos, t)
}
