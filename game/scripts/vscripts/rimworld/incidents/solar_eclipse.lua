return function()
    if Incidents.sun_event_end > GameRules:GetGameTime() then return end

    if not Incidents:CheckKarma(Incidents.karmas["solar_eclipse"]) then return end

    local duration = RandomInt(60, 60 + 60 * Incidents:GetPowerLevel())

    Incidents.sun_event_end = GameRules:GetGameTime() + duration

    GameRules:BeginTemporaryNight(duration)

    SendLetterToAll({
        type = "SolarEclipse",
    })

    UpdateAlarmForAll({
        type = "SolarEclipse",
        targets = {},
        major = false,
        increment = true,
    })

    Timers:CreateTimer(duration, function()
        -- This doesn't work lul ;-;
        UpdateAlarmForAll({
            type = "SolarEclipse",
            targets = {},
            major = false,
            increment = false,
        })
    end)
end
