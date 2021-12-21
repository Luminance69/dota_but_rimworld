# dota_but_rimworld
Dota 2 but Rimworld

Incidents:

	Weight: 5
	Creep Disease:
		All allied creeps are infected with disease.
		-10/30/60% movement speed
		-10/30/60 attack speed
		-10/20/30% damage
		Upgrades after 8-16 seconds
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

	Weight: 8
	Zzztt...:
		One of your towers had a short circuit probably because fUCKing DAVE LEFT IT OUT IN THE RAIN
		Tower takes 50% damage
		deals damage to both teams in 800 aoe and destroys trees
	
	Weight: 40
	Mad Animal:
		A random neutral creep is enraged, targetting a random allied hero
		+50% damage resistance
		+50% movement speed
		+50 damage
		120s duration
		If controlled by helm of the dominator/overlord, the bonuses are lost.
	
	Weight: 5
	Mass Animal Insanity:
		5-10 random neutral creeps are enraged, targetting random heroes from both teams
		+50% damage resistance
		+50% movement speed
		+50 damage
		120s duration
		If controlled by helm of the dominator/overlord, the bonuses are lost.
		
	Weight: 8
	Psychic Drone:
		n/10 chance to be each gender, where n is the number of heroes of that gender
		-6/12/20/35 Mood
		90-180s duration
		
	Weight: 5
	Psychic Soothe:
		n/10 chance to be each gender, where n is the number of heroes of that gender
		+12 Mood
		90-180s duration
		
	Weight: 5
	Solar Eclipse/Artificial Sun:
		60-300s duration
		inverts day/night cycle
		
	Weight: 5
	Gift:
		+200-400 + (game_time/3) gold to each hero on your team
		
	Weight: 2
	Cold Snap:
		120-240s duration
		Floor becomes slippery
		Gain +1 stack of cold every second spent outside range of tower/ancient/fountain.
		-3/5/10 stacks every second spent inside range of tower/ancient/fountain.
		-1 stack every second after duration ends
		
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
			set 100 movespeed
			-200 attack speed
			-75% HP regen
			50 + stack count magic DPS
			permanent -25% movespeed
	
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
		-25% vision

	Weight: 5
	Gift:
		+500 + (25 to 50) * level gold

	Weight: 5
	Wisdom:
		*Only procs if hero is below lvl 30
		+700 + (25 to 50) * level experience

	Weight: 1
	Heart Attack:
		Take 15% max HP DPS for 20 seconds

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
	
	Tough:
		-15% Incoming Damage
	
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
		Basically atrophy aura
	
	Super-Immune:
		-50% Sickness Duration
	
	Sickly:
		+200% Sickness Chance

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
			Your hero will target a nearby enemy basic unit and kill it (basically troll ulti)
			30s duration (or when unit dies)
		
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
			Your hero gives up and runs around randomly
			60s duration

Body Parts:

	Each hero has 8 body parts; 2 legs, 2 arms, 2 eyes, 1 heart, 1 brain.

	Heroes can get part replacement through incidents.
	You cannot for example, get 3 bionic legs, or both a learning assistance and joywire.

	Leg:
		Bionic:
			+10% Movement Speed
			+3 Armor
		Archotech:
			+40% Movement Speed
			+5 Armor
		Stoneskin Gland:
			+25 Armor
			-40% Movement Speed
			Unable to hold any boots
	Arm:
		Bionic:
			+10% Attack Speed
			+10% Casting Point Reduction
			+3 Armor
		Archotech:
			+20% Attack Speed
			+50% Casting Point Reduction
			+5 Armor
		Power Claws:
			+400% attack damage
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
			+30% stats from head items
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
			+50% Healing Amplification
	Brain:		
		Learning Assistant:
			+25% Experience Gain
		Joywire:
			+30 Mood
			-15% Vision
			-15% Attack Speed
			-15% Movement Speed
			-15% Casting Point Reduction
