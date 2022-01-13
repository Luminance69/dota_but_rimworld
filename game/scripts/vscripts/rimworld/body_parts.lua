BodyParts = BodyParts or class({})

function BodyParts:Init()
    print("[Rimworld] BodyParts Loaded!")

    for slot, tbl in pairs(self.parts) do
        for _, part in pairs(tbl) do
            LinkLuaModifier("modifier_" .. slot .. "_" .. part, "modifiers/body_parts/" .. slot, LUA_MODIFIER_MOTION_NONE)
        end
    end

    local heroes = HeroList:GetAllHeroes()

    for _, hero in pairs(heroes) do
        if hero:IsRealHero() then
            self:InitiateBodyParts(hero)
        end
    end
    
    Timers:CreateTimer((IsInToolsMode() and 1) or RandomInt(300, 480), self.AddRandomItemStock)
end

function BodyParts:InitiateBodyParts(hero)
    hero.body_parts = {
    ["leg"] = {},
    ["arm"] = {},
    ["eye"] = {},
    ["heart"] = {},
    ["brain"] = {},
    }
    self:StartingParts(hero)
end

function BodyParts:StartingParts(hero)
    if RandomFloat(0, 1) < 0.4 then
        local slot = self:GetRandomSlot()
        local part = self:GetRandomPart(slot)

        if self:AddBodyPart(hero, slot, part) then
            self:StartingParts(hero)
        end
    end
end

function BodyParts:GetRandomSlot()
    local length = 0

    for _, _ in pairs(BodyParts.parts) do
        length = length + 1
    end

    local choice = RandomInt(1, length)

    for slot, _ in pairs(BodyParts.parts) do
        choice = choice - 1

        if choice == 0 then
            return slot
        end
    end
end

function BodyParts:GetRandomPart(slot)
    local tbl = BodyParts.parts[slot]

    return tbl[RandomInt(1, #tbl)]
end

function BodyParts:AddBodyPart(hero, slot, part)
    if not hero.body_parts or #hero.body_parts[slot] >= BodyParts.slots[slot] then
        return false
    end

    table.insert(hero.body_parts[slot], part)

    hero:AddNewModifier(hero, nil, "modifier_" .. slot .. "_" .. part, nil)

    if slot == "eye" then
        local modifier = hero:FindModifierByName("modifier_cataract")

        if modifier then hero:RemoveModifierByName("modifier_cataract") end
    end

    return true
end

function BodyParts:AddRandomItemStock()
    for team = 2, 3 do
        local slot = BodyParts:GetRandomSlot()
        local part = BodyParts:GetRandomPart(slot)

        BodyParts:AddStock(slot, part, team)
    end
    return RandomInt(300, 480)
end

function BodyParts:AddStock(slot, part, team)
    local item_name = "item_body_part_" .. slot .. "_" .. part

    GameRules:IncreaseItemStock(team, item_name, 1, -1)
end

BodyParts.slots = {
    ["leg"] = 2,
    ["arm"] = 2,
    ["eye"] = 2,
    ["heart"] = 1,
    ["brain"] = 1,
}

BodyParts.parts = {
    ["leg"] = {
        "bionic",
        "archotech",
        "stoneskin_gland",
    },
    ["arm"] = {
        "bionic",
        "archotech",
        "power_claws",
    },
    ["eye"] = {
        "bionic",
        "archotech",
        "eye_of_apollo",
    },
    ["heart"] = {
        "bionic",
        "archotech",
        "healing_enhancer",
    },
    ["brain"] = {
        "learning_assistant",
        "joywire",
    },
}
