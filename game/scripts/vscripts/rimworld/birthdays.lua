Birthdays = Birthdays or class({})

Birthdays.incidents = {
    ["bad_back"] = 10,
    ["dementia"] = 10,
    ["cataract"] = 10,
    ["heart_attack"] = 2,
    ["gift"] = 10,
    ["wisdom"] = 10,
}

function Birthdays:Init()
    print("[Rimworld] Birthdays Loaded!")

    for k, v in pairs(Birthdays.incidents) do
        LinkLuaModifier("modifier_" .. k, "modifiers/birthdays/" .. k, LUA_MODIFIER_MOTION_NONE)
    end

    local heroes = HeroList:GetAllHeroes()

    for _, hero in pairs(heroes) do
        if hero:IsRealHero() then
            Timers:CreateTimer(RandomInt(85, 685), function()
                self:DoBirthday(hero)

                return 600
            end)
        end
    end
end

function Birthdays:DoBirthday(hero)
    local weights = Birthdays.incidents

    if hero:HasModifier("modifier_tough") then
        weights["bad_back"] = weights["bad_back"] / 2
    end

    if hero:HasModifier("modifier_neurotic") then
        weights["dementia"] = weights["dementia"] * 2
    end

    if hero:HasModifier("modifier_joywire") then
        weights["dementia"] = weights["dementia"] * 3
    end

    if #hero.body_parts["eye"] == 1 then 
        weights["cataract"] = 5
    end

    if #hero.body_parts["eye"] == 2 then 
        weights["cataract"] = 0
    end

    if #hero.body_parts["heart"] == 1 then
        weights["heart_attack"] = 0
    end

    if hero:GetLevel() >= 30 then
        weights["wisdom"] = 0
    end

    local incident = GetWeightedChoice(weights)

    if self[incident] and self[incident](hero) then
        print("Birthday: " .. hero:GetUnitName() .. " - " .. incident)
        -- Do notification/sound etc. (maybe panorama? :P)
    end
end

Birthdays.bad_back = function(hero)
    local modifier = hero:FindModifierByName("modifier_bad_back")

    if not modifier then
        modifier = hero:AddNewModifierSpecial(hero, nil, "modifier_bad_back", {})
    else
        modifier:IncrementStackCount()
    end

    return true
end

Birthdays.dementia = function(hero)
    local modifier = hero:FindModifierByName("modifier_dementia")

    if not modifier then
        modifier = hero:AddNewModifierSpecial(hero, nil, "modifier_dementia", {})
    else
        modifier:IncrementStackCount()
    end

    return true
end

Birthdays.cataract = function(hero)    
    local modifier = hero:FindModifierByName("modifier_cataract")

    if not modifier then
        modifier = hero:AddNewModifierSpecial(hero, nil, "modifier_cataract", {})
    else
        modifier:IncrementStackCount()
    end

    return true
end

Birthdays.heart_attack = function(hero)
    hero:AddNewModifierSpecial(hero, nil, "modifier_heart_attack", {duration = RandomInt(10, 20)})

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
