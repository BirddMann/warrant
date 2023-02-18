Config              = {}
Config.JailBlip     = {x = 1854.00, y = 2622.00, z = 45.00}
Config.JailLocation = {x = 1641.64, y = 2571.08, z = 45.56}
Config.Locale       = 'sv'


Config.EnableBlip = true
Config.MapBlip = {
    Pos     	= {x = 1642.3242,y = 2529.6184,z = 45.6115},
    Sprite  	= 311, --icon
    Display	    = 4,
    Scale  	    = 0.6,
    Colour  	= 26,
    Name        = 'Prison Gym',
}

Config.Exersices = {
	{type = 'Bicep Curls', scenario = "world_human_muscle_free_weights", x = 1645.9837,y = 2536.1718,z = 45.6115},
	{type = 'Bicep Curls', scenario = "world_human_muscle_free_weights", x = 1643.37,y = 2523.54,z = 45.56},
	{type = 'Bicep Curls', scenario = "world_human_muscle_free_weights", x = 1671.2545166016,y = 2577.2412109375,z = 45.586555480957},
	{type = 'Bench Press', scenario = "prop_human_seat_muscle_bench_press_prison", x = 1665.2813720,y = 2580.5693359,z = 46.089706420898, fixedBenchPos = {x = 1665.281372,y = 2580.569335,z = 46.08970642, rot = 179.46}},
	{type = 'Bench Press', scenario = "prop_human_seat_muscle_bench_press_prison", x = 1640.79,y = 2532.69,z = 45.95, fixedBenchPos = {x = 1640.79,y = 2532.69,z = 45.95, rot = 220.0}},
	{type = 'Bench Press', scenario = "prop_human_seat_muscle_bench_press_prison", x = 1643.21,y = 2535.25,z = 45.95, fixedBenchPos = {x = 1643.21,y = 2535.25,z = 45.95, rot = 220.0}},
	{type = 'Bench Press', scenario = "prop_human_seat_muscle_bench_press_prison", x = 1638.31,y = 2529.64,z = 45.95, fixedBenchPos = {x = 1638.31,y = 2529.64,z = 45.95, rot = 220.0}},
	{type = 'Bench Press', scenario = "prop_human_seat_muscle_bench_press_prison", x = 1640.58,y = 2522.26,z = 45.95, fixedBenchPos = {x = 1640.58,y = 2522.26,z = 45.95, rot = 220.0}},
	{type = 'Bench Press', scenario = "prop_human_seat_muscle_bench_press_prison", x = 1635.92,y = 2526.59,z = 45.95, fixedBenchPos = {x = 1635.92,y = 2526.59,z = 45.95, rot = 220.0}},
	{type = 'Chin Ups', scenario = "prop_human_muscle_chin_ups", x = 1649.03,y = 2529.85,z = 45.6115, fixedChinPos = {x = 1649.03, y = 2529.85, z = 45.61, rot = 220.0}},
	{type = 'Chin Ups', scenario = "prop_human_muscle_chin_ups", x = 1643.14,y = 2527.96,z = 45.6115, fixedChinPos = {x = 1643.14,y = 2527.96,z = 45.6115, rot = 220.0}},
	{type = 'Chin Ups', scenario = "prop_human_muscle_chin_ups", x = 1665.7947998047,y = 2577.4772949219,z = 45.587451934814, fixedChinPos = {x = 1665.7947998047,y = 2577.4772949219,z = 45.58745194, rot = 267.488220}},
}

Config.ExersiceKey = 38 -- E
Config.ExersiceString = 'Press ~g~E ~s~to do some '
Config.AbortString = 'Press ~g~E ~s~to abort working out'
Config.ExersiceDuration = 30 -- in seconds
Config.FinishString = '~g~Exercise finished! ~s~Take a deep breath before continuing.'

Config.Jobs = {
	{type = 'Weld', scenario = "world_human_welding", x = 1685.56,y = 2553.37,z = 45.56, fixedPos = {x = 1685.56,y = 2553.37,z = 45.56, rot = 333.7}},
	{type = 'Weld', scenario = "world_human_welding", x = 1652.44,y = 2563.69,z = 45.56, fixedPos = {x = 1652.44,y = 2563.69,z = 45.56, rot = 4.03}},
	{type = 'Weld', scenario = "world_human_welding", x = 1629.70,y = 2563.96,z = 45.56, fixedPos = {x = 1629.70,y = 2563.96,z = 45.56, rot = 359.86}},
	{type = 'Weld', scenario = "world_human_welding", x = 1609.85,y = 2540.15,z = 45.56, fixedPos = {x = 1609.85,y = 2540.15,z = 45.56, rot = 144.74}},
	{type = 'Weld', scenario = "world_human_welding", x = 1608.68,y = 2566.95,z = 45.56, fixedPos = {x = 1608.68,y = 2566.95,z = 45.56, rot = 46.24}},
	{type = 'Weld', scenario = "world_human_welding", x = 1624.20,y = 2577.43,z = 45.56, fixedPos = {x = 1624.20,y = 2577.43,z = 45.56, rot = 273.96}},
	{type = 'Weld', scenario = "world_human_welding", x = 1643.87,y = 2491.60,z = 45.56, fixedPos = {x = 1643.87,y = 2491.60,z = 45.56, rot = 189.62}},
	{type = 'Weld', scenario = "world_human_welding", x = 1680.19,y = 2480.63,z = 45.56, fixedPos = {x = 1680.19,y = 2480.63,z = 45.56, rot = 130.28}},
	{type = 'Weld', scenario = "world_human_welding", x = 1699.54,y = 2475.03,z = 45.56, fixedPos = {x = 1699.54,y = 2475.03,z = 45.56, rot = 229.18}},
	{type = 'Weld', scenario = "world_human_welding", x = 1706.45,y = 2481.16,z = 45.56, fixedPos = {x = 1706.45,y = 2481.16,z = 45.56, rot = 234.42}},
	{type = 'Weld', scenario = "world_human_welding", x = 1737.4565429688,y = 2505.3505859375,z = 45.564979553223, fixedPos = {x = 1737.4565429688,y = 2505.3505859375,z = 45.564979553223, rot = 346.9}},
	{type = 'Weld', scenario = "world_human_welding", x = 1760.0653076172,y = 2518.7961425781,z = 45.564979553223, fixedPos = {x = 1760.0653076172,y = 2518.7961425781,z = 45.564979553223, rot = 354.42}},
	{type = 'Weld', scenario = "world_human_welding", x = 1761.5518798828,y = 2540.2873535156,z = 45.564979553223, fixedPos = {x = 1761.5518798828,y = 2540.2873535156,z = 45.564979553223, rot = 5.26}},
	{type = 'Weld', scenario = "world_human_welding", x = 1757.1242675781,y = 2568.6828613281,z = 45.564979553223, fixedPos = {x = 1757.1242675781,y = 2568.6828613281,z = 45.564979553223, rot = 4.01}},
	{type = 'Weld', scenario = "world_human_welding", x = 1699.4224853516,y = 2533.2175292969,z = 45.564865112305, fixedPos = {x = 1699.4224853516,y = 2533.2175292969,z = 45.564865112305, rot = 286.2}},
	{type = 'Weld', scenario = "world_human_welding", x = 1670.7436523438,y = 2583.6103515625,z = 45.586654663086, fixedPos = {x = 1670.7436523438,y = 2583.6103515625,z = 45.586654663086, rot = 270.2}},
	{type = 'Weld', scenario = "world_human_hammering", x = 1670.8715820313,y = 2588.5534667969,z = 45.586616516113, fixedPos = {x = 1670.8715820313,y = 2588.5534667969,z = 45.586616516113, rot = 286.2}},
	{type = 'Weld', scenario = "world_human_hammering", x = 1667.7712402344,y = 2589.2158203125,z = 45.58708190918, fixedPos = {x = 1667.7712402344,y = 2589.2158203125,z = 45.58708190918, rot = 25.2}},
	{type = 'Weld', scenario = "world_human_welding", x = 1664.9083251953,y = 2589.1428222656,z = 45.587558746338, fixedPos = {x = 1664.9083251953,y = 2589.1428222656,z = 45.587558746338, rot = 14.2}},
	{type = 'Weld', scenario = "prop_human_bum_bin", x = 1666.0954589844,y = 2593.5654296875,z = 45.587112426758, fixedPos = {x = 1666.0954589844,y = 2593.5654296875,z = 45.587112426758, rot = 359.2}},
	{type = 'Weld', scenario = "prop_human_bum_bin", x = 1667.3311767578,y = 2593.6042480469,z = 45.586879730225, fixedPos = {x = 1667.3311767578,y = 2593.6042480469,z = 45.586879730225, rot = 359.2}},
	{type = 'Weld', scenario = "prop_human_bum_bin", x = 1668.7680664063,y = 2593.4516601563,z = 45.586612701416, fixedPos = {x = 1668.7680664063,y = 2593.4516601563,z = 45.586612701416, rot = 359.2}},
	{type = 'Weld', scenario = "prop_human_bum_bin", x = 1670.0152587891,y = 2593.3015136719,z = 45.586364746094, fixedPos = {x = 1670.0152587891,y = 2593.3015136719,z = 45.586364746094, rot = 359.2}},
	{type = 'Weld', scenario = "prop_human_bum_bin", x = 1664.9158935547,y = 2593.6352539063,z = 45.587314605713, fixedPos = {x = 1664.9158935547,y = 2593.6352539063,z = 45.587314605713, rot = 359.2}},
}


-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements
Config.Uniforms = {
	prison_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1']  = 146, ['torso_2']  = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 0,   ['pants_1']  = 3,
			['pants_2']  = 7,   ['shoes_1']  = 12,
			['shoes_2']  = 12,
			['bags_1']  = -1,
			['chain']  = -1,  	['bproof_1']  = -1,
			['helmet_1']  = -1, ['helmet_2']  = -1,
			['glasses_1']  = -1,['mask_1']  = -1
		},
		female = {
			['tshirt_1'] = 3,   ['tshirt_2'] = 0,
			['torso_1']  = 38,  ['torso_2']  = 3,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 2,   ['pants_1']  = 3,
			['pants_2']  = 15,  ['shoes_1']  = 66,
			['shoes_2']  = 5,
			['bags_1']  = -1,
			['chain']  = -1,  	['bproof_1']  = -1,
			['helmet_1']  = -1, ['helmet_2']  = -1,
			['glasses_1']  = -1,['mask_1']  = -1
		}
	}
}