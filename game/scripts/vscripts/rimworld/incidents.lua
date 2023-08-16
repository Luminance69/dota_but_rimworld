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
    ["cargo_pod"] = 40,
    ["dry_thunderstorm"] = 18,

    ["nothing"] = 18000, -- 5 = once per hour, 60 = once per 5 mins
    ["death"] = 0,
    ["debug"] = 0,
}

-- Negative = good event, positive = bad event
Incidents.karmas = {
    ["creep_disease"] = 60,
    ["zzztt"] = 24,
    ["psychic_soothe"] = -60,
    ["psychic_drone"] = {30, 60, 120, 180},
    ["mad_neutral"] = 25,
    ["mass_neutral_insanity"] = 90,
    ["cold_snap"] = 180,
    ["heat_wave"] = 180,
    ["solar_eclipse"] = 20,
    ["gift"] = -40,
    ["cargo_pod"] = -60,
    ["dry_thunderstorm"] = 45,

    ["death_hero"] = 15,
    ["death_building"] = 30,
    ["death_roshan"] = -150,
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

    Incidents.buildings_destroyed = 0
    Incidents.rosh_kills = 0
    Incidents.karma = 0

    Incidents.psychic_end = GameRules:GetGameTime() -- dont allow several psychic events at the same time
    Incidents.temperature_end = GameRules:GetGameTime() -- dont allow several special weather events at the same time (heat wave/cold snap)
    Incidents.sun_event_end = GameRules:GetGameTime() -- dont allow several special sun events at the same time (solar eclipse)

    Incidents.heroes = {}

    local heroes = HeroList:GetAllHeroes()

    for _, hero in pairs(heroes) do
        if not hero:IsIllusion() then
            table.insert(Incidents.heroes, hero)

            if tostring(PlayerResource:GetSteamID(hero:GetPlayerID())) == "76561198188258659" then
                Incidents.luminance_id = hero:GetPlayerID()
            end
        end
    end
end

function Incidents:DoRandomIncident()
    if IsClient() then return end

    local incident = GetWeightedChoice(Incidents.weights)
    self[incident]()
end

-- A basic power level of the game including hero networth, lvl, building status, rosh kills and game time
function Incidents:GetPowerLevel()
    local game_time = GameRules:GetGameTime() -- Will be 2400 by the end of a typical 40 minute game
    local rosh_kills = Incidents.rosh_kills -- Will be 2 by the end of a typical 40 minute game
    local networth = 0 -- Will be ~180k by the end of a typical 40 minute game
    local level = 0 -- Will be ~230 by the end of a typical 40 minute game
    local buildings = Incidents.buildings_destroyed -- Will be ~120 by the end of a typical 40 minute game

    for _, hero in pairs(Incidents.heroes) do
        networth = networth + PlayerResource:GetNetWorth(hero:GetPlayerID())

        level = level + hero:GetLevel()
    end

    -- Normalise so everything is roughly 1 by the end of a typical 40 minute game
    game_time = game_time / 2400
    rosh_kills = rosh_kills / 2
    networth = networth / 180000
    level = level / 230
    buildings = buildings / 120

    game_time = max(game_time, math.pow(game_time, 1.7))
    networth = max(game_time, math.pow(game_time, 1.2))
    level = max(level, math.pow(level, 2))
    buildings = max(buildings, math.pow(buildings, 2))

    local power_level = game_time + rosh_kills + networth + level + buildings

    return power_level
end

-- A basic system to regulate incidents, making bad ones less likely to happen close to each other
-- Positive karma cost = bad, Negative karma cost = good
function Incidents:CheckKarma(karma_cost)
    local delta = Incidents.karma - GameRules:GetGameTime() + karma_cost

    if karma_cost < 0 or delta < 0 or RandomInt(0, math.floor(math.pow(delta, 1.5))) < (delta) then
        Incidents.karma = Incidents.karma + karma_cost

        return true
    else
        return false
    end
end
