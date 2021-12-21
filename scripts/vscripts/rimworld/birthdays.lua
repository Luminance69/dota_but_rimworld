Birthdays = Birthdays or class({})

Birthdays.incidents = {
    ["bad_back"] = 5222,
    ["dementia"] = 5,
    ["cataract"] = 5,
    ["heart_attack"] = 1,
    ["gift"] = 5,
    ["wisdom"] = 5,
}

function Birthdays:Init()
    print("[Rimworld] Birthdays Loaded!")

    for k, v in pairs(Birthdays.incidents) do
        LinkLuaModifier("modifier_" .. k, "modifiers/birthdays/" .. k, LUA_MODIFIER_MOTION_NONE)
    end

    local heroes = HeroList:GetAllHeroes()

    for _, hero in pairs(heroes) do
        if hero:IsRealHero() then
            Timers:CreateTimer(RandomInt(90, 690), function()
                self:DoBirthday(hero)

                return 600
            end)
        end
    end
end

function Birthdays:DoBirthday(hero)
    local incident = GetWeightedChoice(Birthdays.incidents)

    -- Don't do wisdom if hero is >= lvl 30
    while incident == "wisdom" and hero:GetLevel() >= 30 do
        incident = GetWeightedChoice(Birthdays.incidents)
    end

    if self[incident] then
        self[incident](hero)

           -- Do notification/sound etc. (maybe panorama? :P)
    end
end

Birthdays.bad_back = function(hero)
    local modifier = hero:FindModifierByName("modifier_bad_back")

    if not modifier then
        modifier = hero:AddNewModifier(hero, nil, "modifier_bad_back", {})
    end

    modifier:IncrementStackCount()
end

Birthdays.dementia = function(hero)
    local modifier = hero:FindModifierByName("modifier_dementia")

    if not modifier then
        modifier = hero:AddNewModifier(hero, nil, "modifier_dementia", {})
    end

    modifier:IncrementStackCount()
end

Birthdays.cataract = function(hero)
    local modifier = hero:FindModifierByName("modifier_cataract")

    if not modifier then
        modifier = hero:AddNewModifier(hero, nil, "modifier_cataract", {})
    end

    modifier:IncrementStackCount()
end

Birthdays.heart_attack = function(hero)
    hero:AddNewModifier(hero, nil, "modifier_heart_attack", {duration = RandomInt(10, 20)})
end

Birthdays.gift = function(hero) -- +500 + (25 to 50) * level gold
    hero:ModifyGoldFiltered(500 + RandomInt(25, 50) * hero:GetLevel(), true, DOTA_ModifyGold_GameTick)
end

Birthdays.wisdom = function(hero) -- +700 + (25 to 50) * level experience
    hero:AddExperience(700 + RandomInt(25, 50) * hero:GetLevel(), DOTA_ModifyXP_TomeOfKnowledge, false, true)
end
