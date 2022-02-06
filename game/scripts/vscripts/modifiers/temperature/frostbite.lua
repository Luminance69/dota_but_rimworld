--[[
Frostbite:
    Permanent.
    -25% movespeed
    -20% base attack damage
    +50% illness chance
]]

modifier_frostbite = modifier_frostbite or class({})

function modifier_frostbite:IsPermanent() return true end
function modifier_frostbite:IsPurgable() return false end
function modifier_frostbite:IsDebuff() return true end

function modifier_frostbite:IsHidden() return false end

function modifier_frostbite:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, -- GetModifierMoveSpeedBonus_Percentage
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE, -- GetModifierBaseDamageOutgoing_Percentage
        MODIFIER_PROPERTY_TOOLTIP, -- OnTooltip
    }
end

function modifier_frostbite:GetModifierMoveSpeedBonus_Percentage() return -25 end
function modifier_frostbite:GetModifierBaseDamageOutgoing_Percentage() return -20 end

function modifier_frostbite:OnTooltip() return 50 end
function modifier_frostbite:GetIllnessChanceBonus() return 50 end