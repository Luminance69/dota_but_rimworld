return function()
    if not Incidents:CheckKarma(Incidents.karmas["mass_neutral_insanity"]) then return end

    local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, Vector(0, 0, 0), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    local targets = {}
    
    local count = 3 + RandomInt(GameRules:GetGameTime() / 600, GameRules:GetGameTime() / 300)

    for _, unit in pairs(units) do
        if unit:GetUnitName() ~= "npc_dota_roshan" then    
            table.insert(targets, unit:GetEntityIndex())
            
            unit:AddNewModifier(unit, nil, "modifier_mad_neutral", nil)

            count = count - 1

            if count == 0 then break end
        end
    end

    SendLetterToAll({
        type = "MassNeutralInsanity",
        targets = targets,
    })
end