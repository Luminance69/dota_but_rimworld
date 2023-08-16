Birthdays = Birthdays or class({})

Birthdays.incidents = {
    ["bad_back"] = 10,
    ["dementia"] = 10,
    ["cataract"] = 10,
    ["heart_attack"] = 3,
    ["gift"] = 25,
    ["wisdom"] = 25,
}

function Birthdays:Init()
    print("[Rimworld] Birthdays Loaded!")

    for k, v in pairs(Birthdays.incidents) do
        LinkLuaModifier("modifier_" .. k, "modifiers/birthdays/" .. k, LUA_MODIFIER_MOTION_NONE)
    end

    local heroes = HeroList:GetAllHeroes()

    for _, hero in pairs(heroes) do
        if hero:IsRealHero() then
            Timers:CreateTimer(IsInToolsMode() and 5 or RandomInt(85, 685), function()
                self:DoBirthday(hero)

                return 600
            end)
        end
    end
end

function Birthdays:DoBirthday(hero)
    hero.age = hero.age and hero.age + 1 or RandomInt(20, 70)

    local weights = Birthdays.incidents

    if hero:HasModifier("modifier_tough") then
        weights["bad_back"] = weights["bad_back"] / 2
    end

    if hero:HasModifier("modifier_neurotic") then
        weights["dementia"] = weights["dementia"] * 2
    end

    if hero:HasModifier("modifier_joywire") then
        weights["dementia"] = weights["dementia"] * 3
    end

    if #hero.body_parts["eye"] == 1 then 
        weights["cataract"] = 5
    end

    if #hero.body_parts["eye"] == 2 then 
        weights["cataract"] = 0
    end

    if #hero.body_parts["heart"] == 1 then
        weights["heart_attack"] = 0
    end

    if hero:GetLevel() >= 30 then
        weights["wisdom"] = 0
    end

    local incident = GetWeightedChoice(weights)

    if self[incident] then
        self[incident](hero)
    end
end

Birthdays.bad_back = function(hero)
    local modifier = hero:FindModifierByName("modifier_bad_back")

    if not modifier then
        modifier = hero:AddNewModifierSpecial(hero, nil, "modifier_bad_back", {})
    else
        modifier:IncrementStackCount()
    end

    SendLetterToTeam(hero:GetTeamNumber(), {
        type = "BirthdayBad",
        targets = hero:GetEntityIndex(),
        special = {
            main = {
                illness = "Bad Back",
                age = tostring(hero.age),
            }
        }
    })

    return true
end

Birthdays.dementia = function(hero)
    local modifier = hero:FindModifierByName("modifier_dementia")

    if not modifier then
        modifier = hero:AddNewModifierSpecial(hero, nil, "modifier_dementia", {})
    else
        modifier:IncrementStackCount()
    end

    SendLetterToTeam(hero:GetTeamNumber(), {
        type = "BirthdayBad",
        targets = hero:GetEntityIndex(),
        special = {
            main = {
                illness = "Dementia",
                age = tostring(hero.age),
            }
        }
    })

    return true
end

Birthdays.cataract = function(hero)    
    local modifier = hero:FindModifierByName("modifier_cataract")

    if not modifier then
        modifier = hero:AddNewModifierSpecial(hero, nil, "modifier_cataract", {})
    else
        modifier:IncrementStackCount()
    end

    SendLetterToTeam(hero:GetTeamNumber(), {
        type = "BirthdayBad",
        targets = hero:GetEntityIndex(),
        special = {
            main = {
                illness = "Cataract",
                age = tostring(hero.age),
            }
        }
    })

    return true
end

Birthdays.heart_attack = function(hero)
    hero:AddNewModifierSpecial(hero, nil, "modifier_heart_attack", {})

    SendLetterToTeam(hero:GetTeamNumber(), {
        type = "BirthdayHeartAttack",
        targets = hero:GetEntityIndex(),
        special = {
            main = {
                age = tostring(hero.age),
            }
        }
    })

    return true
end

Birthdays.gift = function(hero) -- +500 + (25 to 50) * level gold
    local gold = 500 + RandomInt(25, 50) * hero:GetLevel()
    hero:ModifyGoldFiltered(gold, true, DOTA_ModifyGold_GameTick)

	local player = hero:GetPlayerOwner()
	if player then SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, hero, gold, player) end

    SendLetterToTeam(hero:GetTeamNumber(), {
        type = "BirthdayGift",
        targets = hero:GetEntityIndex(),
        special = {
            main = {
                gold = tostring(gold),
                age = tostring(hero.age),
            }
        }
    })

    return true
end

Birthdays.wisdom = function(hero) -- +700 + (25 to 50) * level experience
    exp = 700 + RandomInt(25, 50) * hero:GetLevel()
    hero:AddExperience(exp, DOTA_ModifyXP_TomeOfKnowledge, false, true)
    
	local player = hero:GetPlayerOwner()
	if player then SendOverheadEventMessage(player, OVERHEAD_ALERT_XP, hero, exp, player) end

    SendLetterToTeam(hero:GetTeamNumber(), {
        type = "BirthdayWisdom",
        targets = hero:GetEntityIndex(),
        special = {
            main = {
                exp = tostring(exp),
                age = tostring(hero.age),
            }
        }
    })

    return true
end
