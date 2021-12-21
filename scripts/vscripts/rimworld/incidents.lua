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

    Timers:CreateTimer(IsInToolsMode() and 1 or 90, self.DoIncident)
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

    if self[incident] then
        self[incident]()

        -- Do notification/sound etc. (maybe panorama? :P)
    end

	return 1
end

Incidents.creep_disease = function(args)
    print("creep disease")
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