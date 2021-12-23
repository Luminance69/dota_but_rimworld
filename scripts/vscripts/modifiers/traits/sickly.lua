--[[
	Sickly:
		+200% Sickness Chance
]]

require("modifiers/traits/base_trait")

modifier_sickly = class(base_trait)

function modifier_sickly:IsDebuff() return true end

function modifier_sickly:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP, -- OnTooltip
    }
end

function modifier_sickly:GetIllnessChanceBonus()
    return 200
end

function modifier_sickly:OnTooltip()
    return 200
end

function modifier_sickly:OnCreated()
    self:SetStackCount(200)
end