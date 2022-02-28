return function()
    if Incidents.temperature_end > GameRules:GetGameTime() then return end

    local duration = RandomInt(120, 240)

    Incidents.temperature_end = GameRules:GetGameTime() + duration

    targets = {}

    for _, hero in pairs(Incidents.heroes) do
        table.insert(targets, hero:GetEntityIndex())
    end

    SendLetterToAll({
        type = "ColdSnap",
        targets = targets,
    })

    Temperature.special_offset = Temperature.special_offset - 15

    UpdateAlarmForAll({
        type = "ColdSnap",
        targets = targets,
        major = false,
        increment = true,
    })

    Timers:CreateTimer(duration, function()
        Temperature.special_offset = Temperature.special_offset + 15

        -- This doesn't work lul ;-;
        UpdateAlarmForAll({
            type = "ColdSnap",
            targets = targets,
            major = false,
            increment = false,
        })
    end)
end