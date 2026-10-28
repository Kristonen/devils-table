package main

import "core:fmt"
import rl "vendor:raylib"

Goal :: union{
	Goal_Kill, Goal_Survive,
}

Goal_Kill :: struct{
	kills : int,
	amount : int,
}

Goal_Survive :: struct{
	time : f32,
	total : f32,
}

goal_update :: proc(goal : ^Goal, dt : f32){
	if survive, is_survive := &goal.(Goal_Survive); is_survive{
		survive.time += dt
	}
}

// goal_draw :: proc(goal : Goal, amount : int){
// 	if kill, is_kill := goal.(Goal_Kill); is_kill do goal_kill_draw(kill, amount)
// 	else if survive, is_survive := goal.(Goal_Survive); is_survive do goal_survive_draw(survive)
// }

goal_kill_draw :: proc(goal : Goal_Kill){
	text := fmt.ctprintf("%v/%v Enemies", goal.kills, goal.amount)
	goal_draw_text(text)
}

goal_survive_draw :: proc(goal : Goal_Survive){
	minutes := int((goal.total - goal.time) / 60)
	seconds := i32((goal.total - goal.time)) % 60
	text := fmt.ctprintf("%02d : %02d", minutes, seconds)
	goal_draw_text(text)
}

goal_draw_text :: proc(text : cstring){
	width := rl.MeasureText(text, 20)
	x : i32 = WINDOW_WIDTH/2 - width/2
	y : i32 = 50
	rl.DrawText(text, x, y, 20, rl.WHITE)
}

goal_progress :: proc(goal : Goal) -> f32{
	switch g in goal{
	case Goal_Kill:
		return clamp(f32(g.kills)/f32(g.amount), 0, 1)
	case Goal_Survive:
		return clamp(1 - g.time / g.total, 0, 1)
	case nil:
		return 0
	}
	return 0
}

goal_finished :: proc(goal : Goal) -> bool{
	return goal_progress(goal) >= 1
}

// goal_finished :: proc(goal : Goal) -> bool{
// 	switch g in goal{
// 	case Goal_Kill:
// 		return g.kills <= g.amount
// 	case Goal_Survive:
// 		return g.time >= g.total
// 	case nil:
// 		return false
// 	}
// 	return false
// }
