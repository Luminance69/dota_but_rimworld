Birthdays = Birthdays or class({})

Birthdays.incidents = {
	["bad_back"] = 5,
	["dementia"] = 5,
	["cataract"] = 5,	

	["heart_attack"] = 1,

	["gift"] = 5,	
	["wisdom"] = 5,		
}

function Birthdays:Init()
    for k, v in pairs(self.incidents) do
        LinkLuaModifier("modifier_" .. k, "modifiers/birthday/" .. k, LUA_MODIFIER_MOTION_NONE)
    end
    
	local heroes = HeroList:GetAllHeroes()

	for _, hero in pairs(heroes) do
		if hero:IsRealHero() then
			Timers:CreateTimer(RandomInt(90, 690), self.DoBirthday, hero)
		end
	end
end

function Birthdays:DoBirthday(hero)
    local incident = GetWeightedChoice(self.incidents)

    -- Don't do wisdom if hero is >= lvl 30
    while incident == "wisdom" and hero:GetLevel() >= 30 do
        incident = GetWeightedChoice(self.incidents)
    end

	if self[incident] then
		self[incident](hero)

   		-- Do notification/sound etc. (maybe panorama? :P)
	end

	return 600
end

function Birthdays:bad_back(hero)
	local modifier = hero:FindModifierByName("modifier_bad_back")

	if not modifier then
		modifier = hero:AddNewModifier(hero, nil, "modifier_bad_back", {})
	end

	modifier:IncrementStackCount()
end

function Birthdays:dementia(hero)
	local modifier = hero:FindModifierByName("modifier_dementia")

	if not modifier then
		modifier = hero:AddNewModifier(hero, nil, "modifier_dementia", {})
	end

	modifier:IncrementStackCount()
end

function Birthdays:cataract(hero)
	local modifier = hero:FindModifierByName("modifier_cataract")

	if not modifier then
		modifier = hero:AddNewModifier(hero, nil, "modifier_cataract", {})
	end

	modifier:IncrementStackCount()
end

function Birthdays:heart_attack(hero)
	hero:AddNewModifier(hero, nil, "modifier_heart_attack", {duration = RandomInt(10, 20)})
end

function Birthdays:gift(hero) -- +500 + (25 to 50) * level gold
	hero:ModifyGoldFiltered(500 + RandomInt(25, 50) * hero:GetLevel(), true, DOTA_ModifyGold_GameTick)
end

function Birthdays:wisdom(hero) -- +700 + (25 to 50) * level experience
    hero:AddExperience(700 + RandomInt(25, 50) * hero:GetLevel(), DOTA_ModifyXP_TomeOfKnowledge, false, true)
end
