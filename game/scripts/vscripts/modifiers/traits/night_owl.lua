--[[
	Night Owl:
		+12 Mood during night
		-12 Mood during day
		+600 Night Vision
]]

require("modifiers/traits/base_trait")

modifier_night_owl = class(base_trait)

function modifier_night_owl:IsDebuff() return self.bonus and self.bonus < 0 end

function modifier_night_owl:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP, -- OnTooltip
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION, -- GetBonusNightVision
    }
end

function modifier_night_owl:GetMoodBonus()
    return self.bonus
end

function modifier_night_owl:OnTooltip()
    return self.bonus
end

function modifier_night_owl:GetBonusNightVision()
    return 600
end

function modifier_night_owl:OnCreated()
    self:SetHasCustomTransmitterData(true)

    self:SetStackCount(12)

    if IsClient() then return end
    
    self:StartIntervalThink(1)
end

function modifier_night_owl:OnIntervalThink()
    self.bonus = GameRules:IsDaytime() and -12 or 12
    self:SendBuffRefreshToClients()
end

function modifier_night_owl:AddCustomTransmitterData()
    return {
        bonus = self.bonus,
    }
end

function modifier_night_owl:HandleCustomTransmitterData(data)
    self.bonus = data.bonus
end
