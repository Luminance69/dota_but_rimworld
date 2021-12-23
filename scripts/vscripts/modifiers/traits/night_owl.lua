--[[
	Night Owl:
		+12 Mood during night
		-12 Mood during day
		+600 Night Vision
]]

require("modifiers/traits/base_trait")

modifier_night_owl = class(base_trait)

function modifier_night_owl:IsDebuff() return false end

function modifier_night_owl:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP, -- OnTooltip
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION, -- GetBonusNightVision
    }
end

function modifier_night_owl:GetMoodBonus()
    return GameRules:IsDaytime() and -12 or 12
end

function modifier_night_owl:OnTooltip()
    return GameRules:IsDaytime() and -12 or 12
end

function modifier_night_owl:GetBonusNightVision()
    return 600
end

function modifier_night_owl:OnCreated()
    self:StartIntervalThink(1)
end

function modifier_night_owl:OnIntervalThink()
    self:SetStackCount(GameRules:IsDaytime() and -12 or 12)
end