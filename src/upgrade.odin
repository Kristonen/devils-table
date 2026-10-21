package main

import "core:math/rand"
Mod_Kind :: enum{
	Flat, Percent,
}

Upgrade :: struct{
	name : string,
	desc : string,
	kind : Mod_Kind,
	target_stat : Stat_Id,
	amount : f32,
}

UPGRADES :: [?]Upgrade{
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
