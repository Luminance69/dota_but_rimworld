return function()
    if Incidents.sun_event_end > GameRules:GetGameTime() then return end

    local duration = RandomInt(60, 300)

    Incidents.sun_event_end = GameRules:GetGameTime() + duration

    GameRules:BeginTemporaryNight(duration)

    SendLetterToAll({
        type = "SolarEclipse",
        targets = {},
        special = {
            main = {
                gender = gender,
            }
        }
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