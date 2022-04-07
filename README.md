# dota_but_rimworld

Dota 2 but Rimworld

Incidents:

	Ok theres a bunch of stuff ive changed to do with karma and power level of incidents, i will go back and fix this before merging branch probably™

    (Implemented!)
    Weight: 5
    Creep Disease:
    	50% of allied creeps are infected with disease.
    	-10/30/60% movement speed
    	-10/30/60 attack speed
    	-10/20/30% damage
    	Upgrades after 10-20 seconds
    	At the end of the third stage, creeps have a 50% chance to be cured and a 50% chance to die

    Weight: 50
    Hero Sickness:
    	All sicknesses reduce Mood by 8

    	Contageon:
    		Flu:
    			Slightly transmissible
    			-25% movement speed
    			-50 attack speed
    			-20% damage
    			120-240s duration

    		Malaria:
    			Somewhat transmissible
    			-30% movement speed
    			-30 attack speed
    			-10% damage
    			90-120s duration

    		Plague:
    			Very transmissible
    			-40% movement speed
    			-60 attack speed
    			-20% damage
    			45-75s duration

    	Infection:
    		-5/20/50% movement speed
    		-10/40/70 attack speed
    		-10/20/30% damage
    		Upgrades every 40-80 seconds
    		120-240s total duration

    	Muscle Parasites:
    		-30% movement speed
    		300-600s duration

    	Fibrous Mechanites:
    		Triple normal sickness Mood debuff
    		+25% Movement Speed
    		+10% Outgoing Damage
    		300-600s duration

    	Sensory Mechanites:
    		Triple normal sickness Mood debuff
    		+75% Vision
    		300-600s duration

	(Implemented)
    Weight: 8
    Zzztt...:
    	One of your towers had a short circuit probably because fUCKing DAVE LEFT IT OUT IN THE RAIN
    	the formula for this is confusing, basically does a randomly sized and powerful explosion with damage based on a % of the towers max hp.

	Weight: 8
	Solar Flare:
		All towers on the map are disabled for 30-60 seconds.
		Backdoor protection is also disabled for this time.

	(Implemented)
    Weight: 40
    Mad Animal:
    	A random neutral creep is enraged, targetting the nearest dire/radiant units until killed.
    	+50% damage resistance
    	+50% movement speed
    	+25 + (GameTime / 30) damage
    	If controlled by helm of the dominator/overlord, the bonuses are lost.

    Weight: 8
    Animal Hunting Hero:
    	A random ancient creep targets a nearby enemy hero to kill.
    	+50% damage resistance
    	+50% movement speed
    	+25 + (GameTime / 30) damage
    	If controlled by helm of the overlord, the bonuses are lost.

	(Implemented)
    Weight: 5
    Mass Animal Insanity:
    	3 + RandomInt(GameTime / 600, GameTime / 300) random neutral creeps are enraged, targetting the nearest dire/radiant units until killed.
    	+50% damage resistance
    	+50% movement speed
    	+25 + (GameTime / 30) damage
    	If controlled by helm of the dominator/overlord, the bonuses are lost.

	(Implemented)
    Weight: 8
    Psychic Drone:
    	n/10 chance to be each gender, where n is the number of heroes of that gender
    	-6/12/20/35 Mood
    	90-180s duration

	(Implemented)
    Weight: 5
    Psychic Soothe:
    	n/10 chance to be each gender, where n is the number of heroes of that gender
    	+12 Mood
    	90-180s duration

	(Implemented)
    Weight: 5
    Solar Eclipse:
    	60-300s duration
    	Forces night time

	(Implemented)
    Weight: 5
    Gift:
    	+150 + (game_time/3-5) gold to each hero on your team

	(Implemented)
    Weight: 3
    Cold Snap:
    	120-240s duration
    	Reduces temperature by 15 degrees.

	(Implemented)
    Weight: 3
    Heat Wave:
    	120-240s duration
    	Increases temperature by 15 degrees.

	(Implemented)
    Weight: 10
    Cargo Pods (apparel/weapons):
    	A random item is dropped on a random location on the map.

    (Implemented)
    Weight: 7
    Dry thunderstorm:
    	20-40 second duration.
    	A random 3000 unit radius circle on the map is bombarded by zeus lightning bolts.

    Weight: 4
    Boomalope Infusion:
    	All units on the map are infused with the DNA of a boomalope, causing them to explode violently on death.

    Weight: 10
    Raid:
    	A group of neutral units with randomly assigned skins appear at a random location on the map at least 2000 units from the nearest non outpost building.
    	Power level scales with team power levels.
    	Spawn location is biased based on which team is winning.
    	They run at nearby radiant and dire units attacking them.

    Weight: 3
    Siege:
    	A group of neutral units with randomly assigned skins appear at a random location on the map at least 2000 units from the nearest non outpost building.
    	Power level scales with team power levels.
    	Spawn location is biased based on which team is winning.
    	They shoot rockets at random radiant and dire units until killed.
    	Rockets are basically the effects of various spells; heat seeking missiles, blast off shard, rocket flare, homing missile, call down, sunstrike, LSA.

    Weight: 5
    Mech Cluster:
    	A group of neutral buildings with randomly assigned robotic (tinker, clockwerk etc.) skins appear at a random location on the map at least 2000 units from the nearest non outpost building.
    	Power level scales with team power levels.
    	Spawn location is biased based on which team is winning.
    	Also spawns with a randomly chosed building:
    		Psychic Droner:
    			Basically a psychic drone incident. Gets more powerful over time.
    		Toxic Spewer:
    			All units not nearby a building slowly gain a toxic buildup modifier.
    			This increases cast points, cooldowns, reduces movement speed, attack speed, regeneration.
    			If reaches 100% the unit dies.
    		Sun Blocker:
    			Forces night time.
    			Reduces temperature by 5 degrees.
    		Artificial Sun:
    			Forces day time.
    			Increases temperature by 5 degrees.
    		Psychic Suppressor:
    			Increases cast points and cooldowns of all heroes, more severe the lower their mental break threshold is.
    		Hail Generator:
    			A hailstorm falls on the area, dealing physical damage randomly to units.
    			Reduces temperature by 5 degrees.
    		EMI Dynamo:
    			All items are muted.
    		Climate Adjuster:
    			Reduces/increases temperature by 15 degrees, whichever is more dangerous.

(All implemented (except visuals)!)
Biomes, Temperature and Climate:

    Biomes:
    	A biome is randomly chosen at the start of the game.
    	Each biome has a temperature expressed as the low/high (night/day) temperature of summer/winter, with autumn and spring being half way between the two.
    	Each biome also has a climate (wet/dry)

    	Neutral (temperate forest):
    		Default ambient temp of 15/35|0/20 degrees
    	Hot + Wet (rainforest):
    		Default ambient temp of 35/50|30/45 degrees
    	Hot + Dry (extreme desert):
    		Default ambient temp of -5/55|-15/35 degrees
    	Cold + Wet (cold bog):
    		Default ambient temp of 10/30|-25/-5 degrees
    	Cold + Dry (ice sheet):
    		Default ambient temp of -5/15|-30/-10 degrees

    Climate:
    	Wet:
    		Double chance for all illnesses
    		Sweaty:
    			-8 Mood
    			-10% Attack Speed
    			-10% Cast Point Reduction
    			Removed while temperature is below 30
    	Dry:
    		Thirsty:
    			-8 Mood
    			Entering the fountain or the river, or drinking from a bottle removes thirsty for 120 seconds.

    Temperature:
    	Global temperature is updated every second. Temperature for each unit is then offset based on how close they are to the nearest allied building, also updated once per second.
    	Standard temperature range is 5-35.
    	Buildings provide an offset to each unit's temperature within 1000 units of 15/20/30 degrees for towers/ancient/fountain. Does not stack.

    	Hypothermia:
    		Gain 1 stack every second while the temperature is more than 5 below min.
    		Lose 1 stack every second per 2 degrees above min (rounded up).

    		25 stacks:
    			-10% movespeed
    			-20 attack speed
    			-25% HP regen

    		50 stacks:
    			-30% movespeed
    			-50 attack speed
    			-50% HP regen
    			25 magic DPS

    		100 stacks:
    			-100% movespeed
    			-200 attack speed
    			-100% HP regen
    			stack count - 50 magic DPS

    			Frostbite:
    				Permanent.
    				-25% movespeed
    				-20% base attack damage
    				+50% illness chance

    	Heatstroke:
    		Gain 1 stack every second while the temperature is more than 5 above max.
    		Lose 1 stack every second per 2 degrees below max (rounded up).

    		25 stacks:
    			-10% movespeed
    			-20 attack speed

    		50 stacks:
    			-30% movespeed
    			-50 attack speed
    			50 pure DPS

    		100 stacks:
    			-50% movespeed
    			-100 attack speed
    			0.05% max hp pure dmg per second per stack

(All implemented!)
Birthdays:

    Happens every 10 minutes after a random time in the first 10 minutes.

    Weight: 5
    Bad Back:
    	-10% movement speed
    	-20 attack speed

    Weight: 5
    Dementia:
    	-10% Cast Point Reduction
    	+5% cooldown time (Multiplicative)

    Weight: 5
    Cataract:
    	-25% vision (Multiplicative)

    Weight: 5
    Gift:
    	+500 + (25 to 50) * level gold

    Weight: 5
    Wisdom:
    	*Only procs if hero is below lvl 30
    	+700 + (25 to 50) * level experience

    Weight: 1
    Heart Attack:
    	Take 2% max hp damage every [0.75 - severity / 2] seconds.
    	Severity starts at 0.4 and decreases by 0.04 or increases by 0.06 every [0.75 - self.severity / 2] seconds.
		Using a healing salve reduces severity by a further 0.04 every [0.75 - self.severity / 2] seconds.

(All implemented!)
Traits:

    2-3 Traits are randomly assigned to each hero at the start of the game.

    Nudist:
    	+12 Mood if no clothing equipped
    	-4 Mood per clothing item equipped


    Too Smart:
    	+50% XP Gain
    	+12 Mental Break Threshold

    Relaxed:
    	-25% XP Gain
    	-8 Mental Break Threshold


    Ascetic:
    	+12 Mood if lowest networth ally
    	-5 Mood per higher networth ally

    Greedy:
    	+12 Mood if highest networth ally
    	-5 Mood per lower networth ally


    Night Owl:
    	+12 Mood during night
    	-12 Mood during day
    	+600 Night Vision


    Optimist:
    	+8 Mood

    Pesimist:
    	-8 Mood


    Neurotic:
    	+20% Outgoing Damage
    	+12 Mental Break Threshold
    	Double chance for dementia

    Tough:
    	-15% Incoming Damage
    	Half chance for bad back

    Wimp:
    	-40% Status Resistance


    Jogger:
    	+25% Movement Speed

    Slowpoke:
    	-25% Movement Speed


    Nimble:
    	+20% Evasion
    	+40 Attack Speed

    Bloodlust:
    		+[2/4/6/8/11/14/18] Mood for n "bloody" items equipped
    		+[3/5/7/8/8/...] Mood for 120s after watching a hero die
    		+[3/5/7/8/8/...] extra Mood if the parent made the kill
    	-- Unique count for deaths and kills
    -- hpsum = sum of lost hp within vision radius
    		(hpsum/50)x turn rate
    		hpsum/(hpsum+7500) chance for 1.2x crit


    Super-Immune:
    	-50% Sickness Duration

    Sickly:
    	+200% Sickness Chance

(All implemented!)
Mental Breaks:

    Happens based on hero's mood

    Minor:
    	Sad Wander:
    		Your hero goes on a sad wander randomly
    		10s duration
    		-50% movement speed

    	Hide Under Tower:
    		Your hero hides in the nearest tower
    		20s duration

    	Insulting Spree:
    		Your hero insults allies, causing their mood to decrease
    		30s duration

    Major:
    	Sadistic Rage:
    		Your hero will kill the nearest enemy units (basically troll ulti)
    		30s duration

    	Slaughterer:
    		Your hero will kill the nearest friendly basic units (basically ww ulti)
    		30s duration

    	Tantrum:
    		Forces your hero to attack itself
    		10s duration or 25% HP

    Extreme:
    	Berserk:
    		Your hero will kill the nearest allied hero
    		30s duration (or when unit dies)

    	Catatonic:
    		Your hero is stunned
    		60s duration

    	Give Up:
    		Your hero gives up and walks towards the enemies base
    		30s duration

(All implemented!)
Body Parts:

    Each hero has 8 body parts; 2 legs, 2 arms, 2 eyes, 1 heart, 1 brain.
    You cannot for example, get 3 bionic legs, or both a learning assistance and joywire.

    (implemented) 1. your hero can start with them, maybe like a 40% chance for a random one
    (implemented) 2. you can buy them from the shop, which will gain random stock occasionally
    (will do later) 3. you can get given them by incidents

    Leg:
    	Bionic:
    		+10% Movement Speed
    		+3 Armor
    	Archotech:
    		+40% Movement Speed
    		+5 Armor
    	Stoneskin Gland:
    		-40% Movement Speed
    		+25 Armor
    		Unable to hold any boots
    Arm:
    	Bionic:
    		+10% Attack Speed
    		+10% Cast Point Reduction
    		+3 Armor
    	Archotech:
    		+20% Attack Speed
    		+50% Cast Point Reduction
    		+5 Armor
    	Power Claws:
    		+150% attack damage
    		Unable to use items with handles / gloves
    Eye:
    	Bionic:
    		+25% Vision
    		+2 Armor
    	Archotech:
    		+75% Vision
    		+4 Armor
    	Eye of Apollo:
    		+30% Vision
    		+20% stats from head items
    Heart:
    	Bionic:
    		+10 Strength
    		+100 Health
    		+0.4% Max HP Regen
    	Archotech:
    		+18 Strength
    		+175 Health
    		+0.6% Max HP Regen
    	Healing Enhancer:
    		+75% Healing/Regen Amplification
    		-50% Sickness Duration
    Brain:
    	Learning Assistant:
    		+25% Experience Gain
    	Joywire:
    		+30 Mood
    		-15% Vision
    		-15% Attack Speed
    		-15% Movement Speed
    		-15% Cast Point Reduction

Things to add:

    Noise when hero dies
    Incidents
    Consider the following stuff:
    	Ways to affect comfortable temperature
    	Assorted mood buffs/debuffs:
    		Expectations: 30/20/10/0/-10 mood for <1500/4000/75000/15000/15000+ networth
    		Pain: -3/-6/-10/-15 for missing 25/50/75/90% HP
    		Darkness: -20% movement speed & -4 mood when not near a building at night time
    		Aroura: no darkness debuff, +6 mood
    		Ally died: -2 mood while an ally is dead
    		Slept in the heat/cold: randomly given out at the start of each day time, -3 mood, lasts 450 seconds.
    		Generic sadgeness, randomly given, lasts a random time, -3 to -5 mood:
    		Awful bedroom, hungry, tired, ate without table
    		At the start of every game difficulty is chosen, changing the base mood from between 25 and 42
