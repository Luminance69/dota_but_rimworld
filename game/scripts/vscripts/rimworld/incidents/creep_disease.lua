LinkLuaModifier("modifier_creep_disease_minor", "modifiers/incidents/creep_disease", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_disease_major", "modifiers/incidents/creep_disease", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_disease_extreme", "modifiers/incidents/creep_disease", LUA_MODIFIER_MOTION_NONE)

return function()
    if not Incidents:CheckKarma(Incidents.karmas["creep_disease"]) then return end

    local team = RandomInt(2, 3)
    local creeps = FindUnitsInRadius(team, Vector(0, 0, 0), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    if #creeps < 1 then return end

    local targets = {}

    local chance = 1 / (Incidents:CheckPowerLevel() + 1)

    for _, creep in pairs(creeps) do
        if not creep:IsOwnedByAnyPlayer() and RandomFloat(0, 1) > chance then
            creep:AddNewModifier(creep, nil, "modifier_creep_disease_minor", nil)

            table.insert(targets, creep)
        end
    end

    if #targets < 1 then return end

    SendLetterToTeam(team, {
        type = "CreepDisease",
        targets = targets,
    })
end
