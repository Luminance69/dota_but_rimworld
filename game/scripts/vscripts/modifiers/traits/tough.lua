--[[
	Tough:
		-15% Incoming Damage
]]

require("modifiers/traits/base_trait")

modifier_tough = class(base_trait)

function modifier_tough:IsDebuff() return false end

function modifier_tough:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, -- GetModifierIncomingDamage_Percentage
    }
end

function modifier_tough:GetModifierIncomingDamage_Percentage()
    return 15
end

function modifier_tough:OnCreated()
    self:SetStackCount(15)
end