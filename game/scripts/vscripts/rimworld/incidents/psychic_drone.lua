LinkLuaModifier("modifier_psychic_drone_low", "modifiers/incidents/psychic_drone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_psychic_drone_medium", "modifiers/incidents/psychic_drone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_psychic_drone_high", "modifiers/incidents/psychic_drone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_psychic_drone_extreme", "modifiers/incidents/psychic_drone", LUA_MODIFIER_MOTION_NONE)

return function()
    if Incidents.psychic_end > GameRules:GetGameTime() then return end

    local intensities = {"low", "medium", "high", "extreme"}

    local tier = RandomInt(1, min(4, math.floor(Incidents:GetPowerLevel() * 0.75 + 1)))
    local intensity = intensities[tier]

    if not Incidents:CheckKarma(Incidents.karmas["psychic_drone"][tier]) then return end

    local duration = RandomInt(60, 60 + 30 * Incidents:GetPowerLevel())

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

            hero:AddNewModifierSpecial(hero, nil, "modifier_psychic_drone_" .. intensity, {duration = duration})
        end
    end

    SendLetterToAll({
        type = "PsychicDrone",
        targets = targets,
        special = {
            main = {
                gender = gender,
                intensity = intensity,
            }
        }
    })

    UpdateAlarmForAll({
        type = "PsychicDrone_" .. gender,
        targets = targets,
        major = tier > 2,
        increment = true,
    })

    Timers:CreateTimer(duration, function()
        -- This doesn't work lul ;-;
        UpdateAlarmForAll({
            type = "PsychicDrone_" .. gender,
            targets = targets,
            major = tier > 2,
            increment = false,
        })
    end)
end
