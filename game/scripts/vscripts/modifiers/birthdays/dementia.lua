--[[
	Dementia:
		-10% Cast Point Reduction
		+5% cooldown time (Multiplicative)
]]

require("modifiers/birthdays/base_birthday")

modifier_dementia = class(base_birthday)

function modifier_dementia:IsDebuff() return true end

function modifier_dementia:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE, -- GetModifierPercentageCasttime
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING, -- GetModifierPercentageCooldownStacking
    }
end

function modifier_dementia:GetModifierPercentageCasttime()
    return -10 * self:GetStackCount()
end

function modifier_dementia:GetModifierPercentageCooldownStacking()
    return (-1 + 0.95 ^ self:GetStackCount()) * 100
end