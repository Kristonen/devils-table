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

input_update :: proc(manager : ^Input_Manager){
	input_mouse_update(manager, .Left, .LEFT)
}

input_mouse_update :: proc(manager : ^Input_Manager, input : Input, mouse : rl.MouseButton){
	manager.pressed[input] = rl.IsMouseButtonPressed(mouse)
	manager.down[input] = rl.IsMouseButtonDown(mouse)
	manager.released[input] = rl.IsMouseButtonReleased(mouse)
}

input_button_update :: proc(manager : ^Input_Manager, input : Input, button : rl.KeyboardKey){
	manager.pressed[input] = rl.IsKeyPressed(button)
	manager.down[input] = rl.IsKeyDown(button)
	manager.released[input] = rl.IsKeyReleased(button)
}
