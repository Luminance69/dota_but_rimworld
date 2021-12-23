--[[
	Greedy:
		+12 Mood if highest networth ally
		-5 Mood per lower networth ally
]]

require("modifiers/traits/base_trait")

modifier_greedy = class(base_trait)

function modifier_greedy:IsDebuff() return self.mood_bonus < 0 end

function modifier_greedy:GetMentalBreakThresholdBonus()
    return self.mood_bonus
end

function modifier_greedy:GetMoodBonus()
    return self.mood_bonus
end

function modifier_greedy:OnCreated()
    self.mood_bonus = 12
    self:SetHasCustomTransmitterData(true)
    if IsClient() then return end

    self:StartIntervalThink(1)
end

function modifier_greedy:OnIntervalThink()
    local parent = self:GetParent()
    local team = parent:GetTeamNumber()
    local networth = PlayerResource:GetNetWorth(parent:GetPlayerID())
    local heroes = HeroList:GetAllHeroes()

    local allies = {}

    for _, hero in pairs(heroes) do
        if hero:GetTeamNumber() ~= team and hero:GetPlayerOwnerID() ~= parent:GetPlayerOwnerID() then
            allies[hero:GetPlayerOwnerID()] = true
        end
    end

    count = 0

    for id, _ in pairs(allies) do
        if networth > PlayerResource:GetNetWorth(id) then
            count = count + 1
        end
    end

    if count == 0 then
        self.mood_bonus = 12
    else
        self.mood_bonus = 5 * count
    end

    self:SetStackCount(math.abs(self.mood_bonus))
end

function modifier_greedy:AddCustomTransmitterData( )
    return
    {
        mood_bonus = self.mood_bonus,
    }
end

function modifier_greedy:HandleCustomTransmitterData( data )
    self.mood_bonus = data.mood_bonus
end
