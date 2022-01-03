--[[
	Super-Immune:
		-50% Sickness Duration
]]

require("modifiers/traits/base_trait")

modifier_super_immune = class(base_trait)

function modifier_super_immune:IsDebuff() return false end

function modifier_super_immune:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP, -- OnTooltip
    }
end

function modifier_super_immune:GetIllnessDurationBonus()
    return -50
end

function modifier_super_immune:OnTooltip()
    return 50
end

function modifier_super_immune:OnCreated()
    self:SetStackCount(50)
end