Moods = Moods or class({})

Moods.mental_breaks = {
    ["minor"] = {
        --"sad_wander",
        "hide_under_tower",
        --"insulting_spree",
    },
    --[[
    ["major"] = {
        "sadistic_rage",
        "slaughterer",
        "tantrum",
    },
    ["extreme"] = {
        "berserk",
        "catatonic",
        "give_up",
    },
    ]]
}

function Moods:Init()
    print("[Rimworld] Moods Loaded!")

    self:LinkModifiers(Moods.mental_breaks)

    local heroes = HeroList:GetAllHeroes()

    for _, hero in pairs(heroes) do
        if hero:IsRealHero() then
            hero:AddNewModifier(hero, nil, "modifier_mood", nil)
            Timers:CreateTimer(1, function()
                self:DoMoodUpdate(hero)

                return 1
            end)
        end
    end
end

function Moods:LinkModifiers(table)
    for _, v in pairs(table) do
        for _, j in pairs(v) do
            LinkLuaModifier("modifier_" .. j, "modifiers/mental_breaks/" .. j, LUA_MODIFIER_MOTION_NONE)
        end
    end

    LinkLuaModifier("modifier_insulted", "modifiers/mental_breaks/insulting_spree", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_catharsis", "modifiers/catharsis", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_mood", "modifiers/mood", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_break_risk_minor", "modifiers/mood", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_break_risk_major", "modifiers/mood", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_break_risk_extreme", "modifiers/mood", LUA_MODIFIER_MOTION_NONE)
end

function Moods:DoMoodUpdate(hero)
    hero:UpdateMood()

    if not hero:HasModifier("modifier_catharsis") then
        local mood = hero:GetMood()
        local thresholds = hero:GetMentalBreakThresholds()

        local mental_break

        if mood < thresholds[3] then
            if RandomInt(1, 50) == 1 then
                mental_break = Moods.mental_breaks["extreme"][RandomInt(1, #Moods.mental_breaks["extreme"])]
            end
        elseif mood < thresholds[2] then
            if RandomInt(1, 100) == 1 then
                mental_break = Moods.mental_breaks["major"][RandomInt(1, #Moods.mental_breaks["major"])]
            end
        elseif mood < thresholds[1] then
            if RandomInt(1, 200) == 1 then
                mental_break = Moods.mental_breaks["minor"][RandomInt(1, #Moods.mental_breaks["minor"])]
            end
        end

        if mental_break then
            hero:AddNewModifier(hero, nil, "modifier_" .. mental_break, nil)
            hero:AddNewModifier(hero, nil, "modifier_catharsis", {duration = 120})

            -- Do notification/sound etc. (maybe panorama? :P)
        end
    end

    return 1
end