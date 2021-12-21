BodyParts = BodyParts or class({})

function BodyParts:Init()
    for slot, table in pairs(self.incidents) do
        for _, part in pairs(table) do
            LinkLuaModifier("modifier_" .. part, "modifiers/body_parts/" .. slot, LUA_MODIFIER_MOTION_NONE)
        end
    end

    local heroes = HeroList:GetAllHeroes()

	for _, hero in pairs(heroes) do
		if hero:IsRealHero() then
            self:InitiateBodyParts(hero)
		end
	end
end

function BodyParts:InitiateBodyParts(hero)
    hero.body_parts = {
    ["leg"] = {},
    ["arm"] = {},
    ["eye"] = {},
    ["heart"] = {},
    ["brain"] = {},
    }
end

function BodyParts:AddBodyPart(hero, part)
    local slot = self:GetPartSlot(part)

    if #hero.body_parts[slot] >= BodyParts.slots[slot] then
        return false
    end

    table.insert(hero.body_parts[slot], part)

    hero:AddNewModifier(hero, nil, "modifier_" .. part, nil)
end

function BodyParts:GetPartSlot(part)
    local slots = {}

    for slot, table in pairs(self.parts) do
        for _, part in pairs(table) do
            slots[part] = slot
        end
    end

    return slots
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