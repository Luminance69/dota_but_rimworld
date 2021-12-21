-- Sad Wander:
-- Your hero goes on a sad wander
-- 10s duration
-- -50% movement speed

require("modifiers/mental_breaks/base_mental_break")

modifier_sad_wander = class(base_mental_break)

function modifier_sad_wander:GetTexture() return "mental_breaks/minor" end

function modifier_sad_wander:OnCreated()
    self:SetDuration(10, true)

    self:StartIntervalThink(2)
end

function modifier_sad_wander:OnIntervalThink()
    if IsClient() then return end
    
    self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin() + RandomVector(600))
end

function modifier_sad_wander:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, -- GetModifierMoveSpeedBonus_Percentage
    }
end

function modifier_sad_wander:GetModifierMoveSpeedBonus_Percentage()
    return -50
end

function modifier_sad_wander:ModifierState()
    return {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    }
end