Incidents = Incidents or class({})

Incidents.incidents = {
    ["creep_disease"] = 5,
    ["hero_sickness"] = 50,
    ["zzztt"] = 10,
    ["mad_neutral"] = 40,
    ["mass_neutral_insanity"] = 5,
    ["psychic_soothe"] = 10,
    ["psychic_drone"] = 8,
    ["invert_day"] = 5,
    ["gift"] = 5,
    ["cold_snap"] = 2,
    ["nothing"] = 10000,
}

function Incidents:Init()
    print("[Rimworld] Incidents Loaded!")

    self:LinkModifiers(Incidents.modifiers)

    Timers:CreateTimer(IsInToolsMode() and 2 or 30, self.DoIncident)
end

function Incidents:LinkModifiers(table)
    for k, v in pairs(table) do
        if type(v) == "table" then
            for _, j in pairs(v) do
                LinkLuaModifier("modifier_" .. k .. "_" .. j, "modifiers/incidents/" .. k, LUA_MODIFIER_MOTION_NONE)
            end
        else
            LinkLuaModifier("modifier_" .. v, "modifiers/incidents/" .. v, LUA_MODIFIER_MOTION_NONE)
        end
    end
end

function Incidents:DoIncident()
    local incident = GetWeightedChoice(Incidents.incidents)

    if self[incident] and self[incident]() then
        
        -- Do notification/sound etc. (maybe panorama? :P)
        
    end

    return 1
end

Incidents.creep_disease = function()
    print("creep disease")

    local team = RandomInt(2, 3)

    local creeps = FindUnitsInRadius(team, Vector(0, 0, 0), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    if #creeps < 1 then return false end

    for _, creep in pairs(creeps) do
        if not creep:IsOwnedByAnyPlayer() and RandomFloat(0, 1) < 0.5 then
            creep:AddNewModifier(creep, nil, "modifier_creep_disease_minor", nil)
        end
    end

    return true
end

Incidents.modifiers = {
    ["creep_disease"] = {
        "minor",
        "major",
        "extreme",
    },

    ["infection"] = {
        "minor",
        "major",
        "extreme",
    },

    ["psychic_drone"] = {
        "low",
        "medium",
        "high",
        "extreme",
    },

    "psychic_soothe",

    "creep_insanity",

    "cold_snap",
    "frostbite",
    "frozen_heart",

    "malaria",
    "flu",
    "plague",

    "muscle_parasites",
    "fibrous_mechanites",
    "sensory_mechanites",
}
