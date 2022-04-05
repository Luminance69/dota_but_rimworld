return function()
    if Incidents.temperature_end > GameRules:GetGameTime() then return end

    if not Incidents:CheckKarma(Incidents.karmas["heat_wave"]) then return end

    local duration = RandomInt(max(1, Incidents:GetPowerLevel()) * RandomInt(30, 60))

    Incidents.temperature_end = GameRules:GetGameTime() + duration

    targets = {}

    for _, hero in pairs(Incidents.heroes) do
        table.insert(targets, hero:GetEntityIndex())
    end

    SendLetterToAll({
        type = "HeatWave",
        targets = targets,
    })

    Temperature.special_offset = Temperature.special_offset + 15

    UpdateAlarmForAll({
        type = "HeatWave",
        targets = targets,
        major = false,
        increment = true,
    })

    Timers:CreateTimer(duration, function()
        Temperature.special_offset = Temperature.special_offset - 15

        -- This doesn't work lul ;-;
        UpdateAlarmForAll({
            type = "HeatWave",
            targets = targets,
            major = false,
            increment = false,
        })
    end)
end
