package main

import rl "vendor:raylib"

Input :: enum{
	Left
}

Input_Manager :: struct{
	pressed : [Input]bool,
	down : [Input]bool,
	released : [Input]bool,
}

input_update :: proc(input : ^Input_Manager){
	input.pressed[.Left] = rl.IsMouseButtonPressed(.LEFT)
	input.down[.Left] = rl.IsMouseButtonDown(.LEFT)
	input.released[.Left] = rl.IsMouseButtonReleased(.LEFT)
}
