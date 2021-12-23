--[[
	Wimp:
		-40% Status Resistance
]]

require("modifiers/traits/base_trait")

modifier_wimp = class(base_trait)

function modifier_wimp:IsDebuff() return true end

function modifier_wimp:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING, -- GetModifierStatusResistanceStacking
    }
end

function modifier_wimp:GetModifierStatusResistanceStacking()
    return 40
end

function modifier_wimp:OnCreated()
    self:SetStackCount(40)
end