Traits = Traits or class({})

function Traits:Init()
    print("[Rimworld] Traits Loaded!")

    for k, v in pairs(self.traits) do
        for _, trait in pairs(v) do
            LinkLuaModifier("modifier_" .. trait, "modifiers/traits/" .. trait, LUA_MODIFIER_MOTION_NONE)
        end
    end

    local heroes = HeroList:GetAllHeroes()

    for _, hero in pairs(heroes) do
        if hero:IsRealHero() then
            self:AddTraits(hero)
        end
    end
end

function Traits:AddTraits(hero)
    local traits = self:GetRandomTraits(RandomInt(2, 3))

    print("Adding traits to " .. hero:GetUnitName() .. ":")

    for _, trait in pairs(traits) do
        hero:AddNewModifier(hero, nil, "modifier_" .. trait, nil)

        print(trait)
    end
end

-- Ngl I'm really proud of this function
function Traits:GetRandomTraits(count)
    local groups = {}

    for _, group in pairs(self.traits) do
        table.insert(groups, group)
    end

    local traits = {}

    for i = 1, count do
        group = table.remove(groups, RandomInt(1, #groups))
        table.insert(traits, group[RandomInt(1, #group)])
    end

    return traits
end

Traits.traits = {
    {
        "nudist",
    },
    {
        "too_smart",
        "relaxed",
    },
    {
        "ascetic",
        "greedy",
    },
    {
        "night_owl",
    },
    {
        "optimist",
        "pesimist",
    },
    {
        "neurotic",
        "tough",
        "wimp",
    },
    {
        "jogger",
        "slowpoke",
    },
    {
        "nimble",
    },
    --[[
    {
        "bloodlust",
    },
    {
        "super_immune",
        "sickly",
    },
    ]]
}
