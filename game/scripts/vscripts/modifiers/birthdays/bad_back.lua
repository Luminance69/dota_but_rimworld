-- Bad Back:
-- -10% Movement Speed
-- -20 Attack Speed

require("modifiers/birthdays/base_birthday")

modifier_bad_back = class(base_birthday)

function modifier_bad_back:IsDebuff() return true end

function modifier_bad_back:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, -- GetModifierMoveSpeedBonus_Percentage
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, -- GetModifierAttackSpeedBonus_Constant
    }
end

function modifier_bad_back:GetModifierMoveSpeedBonus_Percentage()
    return -10 * self:GetStackCount()
end

function modifier_bad_back:GetModifierAttackSpeedBonus_Constant()
    return -20 * self:GetStackCount()
end