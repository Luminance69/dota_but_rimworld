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
    print("[Rimworld] Birthdays Loaded!")

    for k, v in pairs(Birthdays.incidents) do
        LinkLuaModifier("modifier_" .. k, "modifiers/birthdays/" .. k, LUA_MODIFIER_MOTION_NONE)
    end

    local heroes = HeroList:GetAllHeroes()

    for _, hero in pairs(heroes) do
        if hero:IsRealHero() then
            Timers:CreateTimer(RandomInt(0, 1), function()
                self:DoBirthday(hero)

                return 600
            end)
        end
    end
end

function Birthdays:DoBirthday(hero)
    local weights = Birthdays.incidents

    if hero:HasModifier("modifier_tough") then
        weights["bad_back"] = weights["bad_back"] * 2
    end

    if hero:HasModifier("modifier_neurotic") then
        weights["dementia"] = weights["dementia"] * 2
    end

    if hero:HasModifier("modifier_joywire") then
        weights["dementia"] = weights["dementia"] * 3
    end

    if hero:GetLevel() >= 30 then
        weights["wisdom"] = 0
    end

    local incident = GetWeightedChoice(weights)

    if self[incident] and self[incident](hero) then
        -- Do notification/sound etc. (maybe panorama? :P)
    end
end

Birthdays.bad_back = function(hero)
    local modifier = hero:FindModifierByName("modifier_bad_back")

    if not modifier then
        modifier = hero:AddNewModifier(hero, nil, "modifier_bad_back", {})
    end

    modifier:IncrementStackCount()

    return true
end

Birthdays.dementia = function(hero)
    local modifier = hero:FindModifierByName("modifier_dementia")

    if not modifier then
        modifier = hero:AddNewModifier(hero, nil, "modifier_dementia", {})
    end

    modifier:IncrementStackCount()

    return true
end

Birthdays.cataract = function(hero)
    if #hero.body_parts["eye"] == 2 then return false end
    
    local modifier = hero:FindModifierByName("modifier_cataract")

    if not modifier then
        modifier = hero:AddNewModifier(hero, nil, "modifier_cataract", {})
    end

    modifier:IncrementStackCount()

    return true
end

Birthdays.heart_attack = function(hero)
    if #hero.body_parts["heart"] == 1 then return false end
    hero:AddNewModifier(hero, nil, "modifier_heart_attack", {duration = RandomInt(10, 20)})

    return true
end

Birthdays.gift = function(hero) -- +500 + (25 to 50) * level gold
    hero:ModifyGoldFiltered(500 + RandomInt(25, 50) * hero:GetLevel(), true, DOTA_ModifyGold_GameTick)

    return true
end

Birthdays.wisdom = function(hero) -- +700 + (25 to 50) * level experience
    hero:AddExperience(700 + RandomInt(25, 50) * hero:GetLevel(), DOTA_ModifyXP_TomeOfKnowledge, false, true)

    return true
end
