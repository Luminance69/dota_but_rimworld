--[[
	Neurotic:
		+20% Outgoing Damage
		+12 Mental Break Threshold
]]

require("modifiers/traits/base_trait")

modifier_neurotic = class(base_trait)

function modifier_neurotic:IsDebuff() return false end

function modifier_neurotic:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP, -- OnTooltip
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, -- GetModifierTotalDamageOutgoing_Percentage
    }
end

function modifier_neurotic:GetMentalBreakThresholdBonus()
    return 12
end

function modifier_neurotic:GetModifierTotalDamageOutgoing_Percentage()
    return 20
end

function modifier_neurotic:OnTooltip()
    return 12
end

function modifier_neurotic:OnCreated()
    self:SetStackCount(20)
end