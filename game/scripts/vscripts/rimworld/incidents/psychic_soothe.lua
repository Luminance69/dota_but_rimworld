LinkLuaModifier("modifier_psychic_soothe", "modifiers/incidents/psychic_soothe", LUA_MODIFIER_MOTION_NONE)

return function()
    if Incidents.psychic_end > GameRules:GetGameTime() then return end

    if not Incidents:CheckKarma(Incidents.karmas["psychic_soothe"]) then return end

    local duration = RandomInt(60, 60 + 30 * Incidents:CheckPowerLevel())

    Incidents.psychic_end = GameRules:GetGameTime() + duration

    local genders = LoadKeyValues("scripts/kv/gender.txt")

    local choices = {
        ["male"] = 0,
        ["female"] = 0,
        ["neutral"] = 0,
    }
    
    for _, hero in pairs(Incidents.heroes) do
        if PlayerResource:GetSelectedHeroEntity(hero:GetPlayerOwnerID()) == hero then
            choices[genders[hero:GetUnitName()]] = choices[genders[hero:GetUnitName()]] + 1
        end
    end

    local gender = GetWeightedChoice(choices)

    local targets = {}

    for _, hero in pairs(Incidents.heroes) do
        if genders[hero:GetUnitName()] == gender then
            table.insert(targets, hero:GetEntityIndex())
            
            hero:AddNewModifierSpecial(hero, nil, "modifier_psychic_soothe", {duration = duration})
        end
    end
    
    SendLetterToAll({
        type = "PsychicSoothe",
        targets = targets,
        special = {
            main = {
                gender = gender,
            }
        }
    })

    UpdateAlarmForAll({
        type = "PsychicSoothe_" .. gender,
        targets = targets,
        major = false,
        increment = true,
    })

    Timers:CreateTimer(duration, function()
        -- This doesn't work lul ;-;
        UpdateAlarmForAll({
            type = "PsychicSoothe_" .. gender,
            targets = targets,
            major = false,
            increment = false,
        })
    end)
end