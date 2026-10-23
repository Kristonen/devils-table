package main

import "core:fmt"
import "core:math/rand"
import rl "vendor:raylib"

CARD_WIDTH :: 350
CARD_HEIGHT :: 450
CARD_GAP :: 40
CARD_PADDING :: 20

Mod_Kind :: enum{
	Flat, Percent,
}

Upgrade :: struct{
	name : cstring,
	desc : cstring,
	kind : Mod_Kind,
	target_stat : Stat_Id,
	amount : f32,
}

UPGRADES := [?]Upgrade{
	{
		name = "More Damage",
		desc = "Increase the damage by 2",
		kind = .Flat,
		target_stat = .Weapon_Damage,
		amount = 2,
	},
	{
		name = "Hau drauf!",
		desc = "Increase the damage by 50%",
		kind = .Percent,
		target_stat = .Weapon_Damage,
		amount = 0.5,
	},
	{
		name = "Faster",
		desc = "Increase the attack rate by 0.2",
		kind = .Percent,
		target_stat = .Weapon_Rate,
		amount = 0.2,
	},
	{
		name = "Langfinger",
		desc = "Increase the loot radius by 20",
		kind = .Flat,
		target_stat = .Pickup_Radius,
		amount = 20,
	},
}
upgrade_apply :: proc(stats : ^Run_Stats, upgrade : Upgrade){
	switch upgrade.kind{
	case .Flat:
		stat_add_flat(&stats[upgrade.target_stat], upgrade.amount)
	case .Percent:
		stat_add_percent(&stats[upgrade.target_stat], upgrade.amount)
	}
}

upgrade_roll_choices :: proc() -> (choices : [3]int, count : int){
	choices = {-1, -1, -1}

	pool : [len(UPGRADES)]int
	for i in 0..<len(pool){
		pool[i] = i
	}
	rand.shuffle(pool[:])

	count = min(len(UPGRADES), len(choices))
	for i in 0..< count{
		choices[i] = pool[i]
	}
	return
}

upgrade_card_draw :: proc(card : rl.Rectangle, number : int, upgrade : Upgrade, is_hovered : bool){
	color := !is_hovered ? rl.GRAY : rl.LIGHTGRAY
	rl.DrawRectangleRec(card, color)
	center_x := i32(card.x) + i32(card.width/2)
	y := i32(card.y) + CARD_PADDING

	draw_text_centered(fmt.ctprintf("%v", number), center_x, y, 48, rl.GOLD)
	draw_text_centered(upgrade.name, center_x, y + 80, 32, rl.WHITE)
	draw_text_centered(upgrade.desc, center_x, y + 160, 18, rl.BLACK)
}

upgrade_panel_rec :: proc(count : int) -> rl.Rectangle{
	width := f32((CARD_WIDTH + CARD_GAP) * count) - CARD_GAP
	return {
		x = WINDOW_WIDTH/2 - width/2,
		y = WINDOW_HEIGHT/2 - CARD_HEIGHT/2,
		width = width,
		height = CARD_HEIGHT,
	}
}

upgrade_card_rec :: proc(index : int, panel : rl.Rectangle) -> rl.Rectangle{
	return{
		x = panel.x + f32((CARD_WIDTH + CARD_GAP) * index),
		y = panel.y,
		width = CARD_WIDTH,
		height = CARD_HEIGHT,
	}
}

draw_text_centered :: proc(text : cstring, center_x : i32, y : i32, size : i32, color : rl.Color){
	width := rl.MeasureText(text, size)
	rl.DrawText(text, center_x - width/2, y, size, color)
}
