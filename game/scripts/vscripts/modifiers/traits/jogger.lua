--[[
	Jogger:
		+25% Movement Speed
]]

require("modifiers/traits/base_trait")

modifier_jogger = class(base_trait)

function modifier_jogger:IsDebuff() return false end

function modifier_jogger:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, -- GetModifierMoveSpeedBonus_Percentage
    }
end

function modifier_jogger:GetModifierMoveSpeedBonus_Percentage()
    return 25
end

function modifier_jogger:OnCreated()
    self:SetStackCount(25)
end