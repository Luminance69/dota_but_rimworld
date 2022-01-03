--[[
	Nimble:
		+20% Evasion
		+40 Attack Speed
]]

require("modifiers/traits/base_trait")

modifier_nimble = class(base_trait)

function modifier_nimble:IsDebuff() return false end

function modifier_nimble:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_EVASION_CONSTANT, -- GetModifierEvasion_Constant
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, -- GetModifierAttackSpeedBonus_Constant
    }
end

function modifier_nimble:GetModifierEvasion_Constant()
    return 20
end

function modifier_nimble:GetModifierAttackSpeedBonus_Constant()
    return 40
end

function modifier_nimble:OnCreated()
    self:SetStackCount(20)
end