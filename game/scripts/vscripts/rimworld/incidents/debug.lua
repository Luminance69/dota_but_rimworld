return function()
    local player = PlayerResource:GetPlayer(Incidents.luminance_id)

    SendLetterToPlayer(
        player,
        {
            type = "Debug",
            special = {
                main = {
                    karma = string.format("%.4f", Incidents.karma - GameRules:GetGameTime()),
                    power_level = string.format("%.4f", Incidents:GetPowerLevel()),
                }
            }
        }
    )
end
