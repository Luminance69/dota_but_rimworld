Incidents = Incidents or class({})

Incidents.weights = {
    -- ["cold_snap"] = 2,
    ["creep_disease"] = 5,
    -- ["gift"] = 5,
    -- ["hero_sickness"] = 50,
    -- ["invert_day"] = 5,
    -- ["mad_neutral"] = 40,
    -- ["mass_neutral_insanity"] = 5,
    -- ["psychic_drone"] = 8,
    -- ["psychic_soothe"] = 10,
    -- ["zzztt"] = 10,
    ["nothing"] = 10000,
}

function Incidents:Init()
    print("[Rimworld] Incidents Loaded!")

    -- Import incident modules to an executable index
    for k, _ in pairs(self.weights) do
        self[k] = require("rimworld/incidents/" .. k)
    end

    Timers:CreateTimer(IsInToolsMode() and 2 or 30, function()
        Incidents:DoRandomIncident()
        return 30 end
    )
end

function Incidents:DoRandomIncident()
    local incident = GetWeightedChoice(Incidents.weights)
    self[incident]()
end
