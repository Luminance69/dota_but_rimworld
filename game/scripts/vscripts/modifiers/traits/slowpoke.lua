--[[
	Slowpoke:
		-25% Movement Speed
]]

require("modifiers/traits/base_trait")

modifier_slowpoke = class(base_trait)

function modifier_slowpoke:IsDebuff() return true end

function modifier_slowpoke:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, -- GetModifierMoveSpeedBonus_Percentage
    }
end

function modifier_slowpoke:GetModifierMoveSpeedBonus_Percentage()
    return -25
end

function modifier_slowpoke:OnCreated()
    self:SetStackCount(25)
end