package main

import "core:fmt"
import rl "vendor:raylib"

Goal :: union{
	Goal_Kill, Goal_Survive,
}

Goal_Kill :: struct{
	amount : int,
}

Goal_Survive :: struct{
	time : f32,
}

// goal_update :: proc(goal : ^Goal, dt : f32){
// 	if survive, is_survive := &goal.(Goal_Survive); is_survive{
// 		survive.time -= dt
// 	}
// }

// goal_draw :: proc(goal : Goal, amount : int){
// 	if kill, is_kill := goal.(Goal_Kill); is_kill do goal_kill_draw(kill, amount)
// 	else if survive, is_survive := goal.(Goal_Survive); is_survive do goal_survive_draw(survive)
// }

goal_kill_draw :: proc(goal : Goal_Kill, amount : int){
	text := fmt.ctprintf("%v/%v Enemies", amount, goal.amount)
	goal_draw_text(text)
}

goal_survive_draw :: proc(goal : Goal_Survive, time : f32){
	minutes := int(time / 60)
	seconds := i32(time) % 60
	text := fmt.ctprintf("%02d : %02d", minutes, seconds)
	goal_draw_text(text)
}

goal_draw_text :: proc(text : cstring){
	width := rl.MeasureText(text, 20)
	x : i32 = WINDOW_WIDTH/2 - width/2
	y : i32 = 50
	rl.DrawText(text, x, y, 20, rl.WHITE)
}

goal_finished :: proc(goal : Goal, amount : int) -> bool{
	switch g in goal{
	case Goal_Kill:
		return g.amount <= amount
	case Goal_Survive:
		return g.time <= 0
	case nil:
		return false
	}
	return false
}
