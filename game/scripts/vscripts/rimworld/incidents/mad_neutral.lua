LinkLuaModifier("modifier_mad_neutral", "modifiers/incidents/mad_neutral", LUA_MODIFIER_MOTION_NONE)

return function()
    local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, Vector(0, 0, 0), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    if #units < 1 then return end

    if units[1]:GetUnitName() == "npc_dota_roshan" then table.remove(units, 1) end
        
    if #units < 1 then return end

    local unit = units[1]

    unit:AddNewModifier(unit, nil, "modifier_mad_neutral", nil)

    local type = unit:IsAncient() and "MadNeutralAncient" or "MadNeutral"

    SendLetterToAll({
        type = type,
        targets = unit:GetEntityIndex(),
    })
end