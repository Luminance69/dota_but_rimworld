Temperature = Temperature or class({})

Temperature.biomes = {
    ["temperate_forest"] = {
        ["name"] = "Temperate Forest",
        ["climate"] = "mild",
        ["temperatures"] = {15, 35, 0, 20},
    },
    ["rainforest"] = {
        ["name"] = "Rainforest",
        ["climate"] = "wet",
        ["temperatures"] = {35, 50, 30, 45},
    },
    ["extreme_desert"] = {
        ["name"] = "Extreme Desert",
        ["climate"] = "dry",
        ["temperatures"] = {-5, 55, -15, 35},
    },
    ["cold_bog"] = {
        ["name"] = "Cold Bog",
        ["climate"] = "wet",
        ["temperatures"] = {10, 30, -25, -5},
    },
    ["ice_sheet"] = {
        ["name"] = "Ice Sheet",
        ["climate"] = "dry",
        ["temperatures"] = {-5, 15, -30, -10},
    },
}

function Temperature:Init()
    print("[Rimworld] Temperature Loaded!")

    local mods = {
        "sweaty",
        "thirsty",
        "hypothermia",
        "heatstroke",
        "frostbite",
    }

    for _, mod in pairs(mods) do
        LinkLuaModifier("modifier_" .. mod, "modifiers/temperature/" .. mod, LUA_MODIFIER_MOTION_NONE)
    end

    Temperature.standard_temps = {5, 35}

    local keys = {}

    for k, _ in pairs(Temperature.biomes) do
        table.insert(keys, k)
    end

    Temperature.biome = Temperature.biomes[keys[RandomInt(1, #keys)]]

    print("Biome loaded: " .. Temperature.biome["name"])

    Temperature.climate = Temperature.biome["climate"]
    Temperature.temps = Temperature:GenerateTemperatures(Temperature.biome["temperatures"])

    local heroes = HeroList:GetAllHeroes()

    for _, hero in pairs(heroes) do
        if Temperature.climate == "wet" then
            hero:AddNewModifierSpecial(hero, nil, "modifier_sweaty", nil) 
        end

        if Temperature.climate == "dry" then
            hero:AddNewModifierSpecial(hero, nil, "modifier_thirsty", nil) 
        end
    end

    print("Climate loaded: " .. Temperature.climate)

    local temps = ""

    for _, v in pairs(Temperature.temps) do
        temps = temps .. tostring(v[1]) .. " => " .. tostring(v[2]) .. " | "
    end

    temps = string.sub(temps, 1, -3)

    print("Temps loaded: " .. temps)

    Temperature:UpdateSeason()

    -- Update which season it is at the start of each day
    Timers:CreateTimer(690, function() 
        Temperature:UpdateSeason()

        return 600
    end)

    Timers:CreateTimer(1, function()
        Temperature:UpdateTemperature()

        return 1
    end)
end

function Temperature:GenerateTemperatures(temps)
    local others = {(temps[1] + temps[3]) / 2, (temps[2] + temps[4]) / 2}
    local new_temps = {
        {temps[1], temps[2]},
        others,
        {temps[3], temps[4]},
        others,
    }

    return new_temps
end

function Temperature:UpdateSeason()
    if not Temperature.season then
        Temperature.season = RandomInt(1, 4)
    else
        Temperature.season = Temperature.season + 1

        if Temperature.season > 4 then
            Temperature.season = 1
        end
    end

    Temperature.temp_targets = Temperature.temps[Temperature.season]
end

function Temperature:UpdateTemperature()
    Temperature.temp_target = Temperature.temp_targets[GameRules:IsDaytime() and 2 or 1]

    if not Temperature.temp then
        Temperature.temp = Temperature.temp_target
    end

    -- Slowly move temp towards target
    if math.abs(Temperature.temp_target - Temperature.temp) < 0.2 then
        Temperature.temp = Temperature.temp_target
    else
        Temperature.temp = Temperature.temp + 0.05 * (Temperature.temp_target - Temperature.temp)
    end

    local heroes = HeroList:GetAllHeroes()

    for _, hero in pairs(heroes) do
        hero.temp_target = Temperature.temp_target

        local temp_offset = 0

        local buildings = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

        for _, building in pairs(buildings) do
            if building:GetUnitName() == "dota_fountain" then
                temp_offset = 30
            elseif building:IsAncient() then
                temp_offset = temp_offset < 20 and 20 or temp_offset
            elseif building:IsTower() then
                temp_offset = temp_offset < 10 and 10 or temp_offset
            end
        end

        local temp = Temperature.temp

        if math.abs(temp - 20) < temp_offset then
            temp = 20
        elseif temp > 20 then
            temp = temp - temp_offset
        else
            temp = temp + temp_offset
        end

        if IsServer() and hero:IsAlive() then
            if temp < Temperature.standard_temps[1] then
                if temp < Temperature.standard_temps[1] - 5 then
                    local hypothermia = hero:FindModifierByName("modifier_hypothermia") or hero:AddNewModifier(hero, nil, "modifier_hypothermia", nil)

                    hypothermia:IncrementStackCount()
                end
            else
                local hypothermia = hero:FindModifierByName("modifier_hypothermia")

                if hypothermia then
                    local stacks = hypothermia:GetStackCount()

                    stacks = stacks - math.ceil((temp - Temperature.standard_temps[1]) / 2)

                    if stacks > 0 then
                        hypothermia:SetStackCount(stacks)
                    else
                        hypothermia:Destroy()
                    end
                end
            end

            if temp > Temperature.standard_temps[2] then
                if temp > Temperature.standard_temps[2] + 5 then
                    local heatstroke = hero:FindModifierByName("modifier_heatstroke") or hero:AddNewModifier(hero, nil, "modifier_heatstroke", nil)

                    heatstroke:IncrementStackCount()
                end
            else
                local heatstroke = hero:FindModifierByName("modifier_heatstroke")

                if heatstroke then
                    local stacks = heatstroke:GetStackCount()

                    stacks = stacks - math.ceil((Temperature.standard_temps[2] - temp) / 2)

                    if stacks > 0 then
                        heatstroke:SetStackCount(stacks)
                    else
                        heatstroke:Destroy()
                    end
                end
            end
        end
    end
end