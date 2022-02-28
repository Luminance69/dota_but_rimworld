Incidents = Incidents or class({})

Incidents.weights = {
    ["creep_disease"] = 14,
    ["zzztt"] = 28,
    ["psychic_soothe"] = 14,
    ["psychic_drone"] = 18,
    ["mad_neutral"] = 50,
    ["mass_neutral_insanity"] = 8,
    ["cold_snap"] = 12,
    ["heat_wave"] = 12,
    ["solar_eclipse"] = 20,
    ["gift"] = 20,
    
    ["nothing"] = 72000, -- 20 = once per hour, 240 = once per 5 mins
    ["death"] = 0,
}

function Incidents:Init()
    print("[Rimworld] Incidents Loaded!")

    -- Import incident modules to an executable index
    for k, _ in pairs(self.weights) do
        self[k] = require("rimworld/incidents/" .. k)
    end

    Timers:CreateTimer(IsInToolsMode() and 2 or 55, function()
        Incidents:DoRandomIncident()
        return 1
    end)

    ListenToGameEvent("entity_killed", function(keys)
        self["death"](keys)
    end, nil)

    Incidents.psychic_end = GameRules:GetGameTime() -- dont allow several psychic events at the same time
    Incidents.temperature_end = GameRules:GetGameTime() -- dont allow several special weather events at the same time (heat wave/cold snap)
    Incidents.sun_event_end = GameRules:GetGameTime() -- dont allow several special sun events at the same time (solar eclipse)
    Incidents.heroes = {}

    local heroes = HeroList:GetAllHeroes()

    for _, hero in pairs(heroes) do
        if not hero:IsIllusion() then
            table.insert(Incidents.heroes, hero)
        end
    end
end

function Incidents:DoRandomIncident()
    local incident = GetWeightedChoice(Incidents.weights)
    self[incident]()
end
