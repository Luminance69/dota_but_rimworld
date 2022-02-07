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

    Timers:CreateTimer(IsInToolsMode() and 2 or 30, self.DoRandomIncident)

    ListenToGameEvent("entity_killed", function(keys)
        Incidents:OnDeath(keys)
    end, nil)
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

function Incidents:DoRandomIncident()
    local incident = GetWeightedChoice(Incidents.incidents)

    Incidents:DoIncident(incident)

    return 1
end

function Incidents:DoIncident(incident)
    if self[incident] then
        local keys = self[incident]()

        if keys then
            keys["name"] = keys["name"] or Incidents.names[incident]
            keys["description"] = keys["description"] or Incidents.descriptions[incident]
            keys["severity"] = keys["severity"] or Incidents.severity[incident]
            keys["sounds"] = keys["sounds"] or Incidents.sounds[incident]

            if keys["team"] then
                SendIncidentLetterTeam(keys["team"], keys)
            elseif keys["player"] then
                SendIncidentLetterPlayer(keys["player"], keys)
            else
                SendIncidentLetter(keys)
            end
        end
    end
end

Incidents.creep_disease = function()
    print("creep disease")

    local team = RandomInt(2, 3)

    local targets = {}

    local creeps = FindUnitsInRadius(team, Vector(0, 0, 0), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    if #creeps < 1 then return false end

    for _, creep in pairs(creeps) do
        if not creep:IsOwnedByAnyPlayer() and RandomFloat(0, 1) < 0.5 then
            creep:AddNewModifier(creep, nil, "modifier_creep_disease_minor", nil)

            table.insert(targets, creep:GetEntityIndex())
        end
    end

    return {["team"] = team, ["targets"] = targets}
end

function Incidents:OnDeath(keys)
    local killed = EntIndexToHScript(keys.entindex_killed)

    if not killed or killed:IsNull() or not killed:IsHero() then return end

    local player_id = killed:GetPlayerOwnerID()

    if player_id == -1 then return end

    if killed ~= PlayerResource:GetSelectedHeroEntity(player_id) then return end

    local team = killed:GetTeamNumber()
    
    local color = team == EntIndexToHScript(keys.entindex_attacker):GetTeamNumber() and "#ccc47f" or "#ca7471"

    local keys = {
        name = "Death",
        description = "One of your allies has died. Alexa, play despacito.",
        severity = color,
        sounds = "LetterArriveBadUrgentSmall",
        targets = killed,
    }

    SendIncidentLetterTeam(team, keys)
end

Incidents.modifiers = {
    ["creep_disease"] = {
        "minor",
        "major",
        "extreme",
    },

    --[[

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

    "malaria",
    "flu",
    "plague",

    "muscle_parasites",
    "fibrous_mechanites",
    "sensory_mechanites",
    ]]
}

Incidents.names = {
    ["creep_disease"] = "Creep Disease",
    ["zzztt"] = "Zzztt...",

    --[[
    ["hero_sickness"] = "",
    ["mad_neutral"] = "",
    ["mass_neutral_insanity"] = "",
    ["psychic_soothe"] = "",
    ["psychic_drone"] = "",
    ["invert_day"] = "",
    ["gift"] = "",
    ["cold_snap"] = "",
    ]]
}

Incidents.descriptions = {
    ["creep_disease"] = "Many of your creeps have been infected with a deadly illness.",
    ["zzztt"] = "One of your towers has short circuted causing it to explode.",

    --[[
    ["hero_sickness"] = "",
    ["mad_neutral"] = "",
    ["mass_neutral_insanity"] = "",
    ["psychic_soothe"] = "",
    ["psychic_drone"] = "",
    ["invert_day"] = "",
    ["gift"] = "",
    ["cold_snap"] = "",
    ]]
}

Severity = Severity or {
    White = "#ffffff",
    Blue = "#79afdb",
    Yellow = "#ccc47f",
    Red = "#ca7471",
}

Incidents.severity = {
    ["creep_disease"] = Severity.Red,
    ["zzztt"] = Severity.Yellow,

    --[[
    ["hero_sickness"] = Severity.Yellow,
    ["mad_neutral"] = Severity.Yellow,
    ["mass_neutral_insanity"] = Severity.Red,
    ["psychic_soothe"] = Severity.Blue,
    ["psychic_drone"] = Severity.Red,
    ["invert_day"] = Severity.White,
    ["gift"] = Severity.White,
    ["cold_snap"] = Severity.Red,
    ]]
}

Incidents.sounds = {
    ["creep_disease"] = "LetterArriveBadUrgent",
    ["zzztt"] = "LetterArriveBadUrgentSmall",

    --[[
    ["hero_sickness"] = "LetterArriveBadUrgentSmall",
    ["mad_neutral"] = "LetterArriveBadUrgentSmall",
    ["mass_neutral_insanity"] = "LetterArriveBadUrgentBig",
    ["psychic_soothe"] = "LetterArriveGood",
    ["psychic_drone"] = "LetterArriveBadUrgentSmall",
    ["invert_day"] = "LetterArrive",
    ["gift"] = "LetterArriveGood",
    ["cold_snap"] = "LetterArriveBadUrgentBig",
    ]]
}
