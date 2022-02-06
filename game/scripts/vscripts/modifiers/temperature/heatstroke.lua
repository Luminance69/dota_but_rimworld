--[[
Heatstroke:
    Gain 1 stack every second while the temperature is more than 5 above max.
    Lose 1 stack every second per 2 degrees below max (rounded up).

    25 stacks:
        -10% movespeed
        -20 attack speed

    50 stacks:
        -30% movespeed
        -50 attack speed
        50 pure DPS

    100 stacks:
        -50% movespeed
        -100 attack speed
        0.05% max hp pure dmg per second per stack
]]

modifier_heatstroke = modifier_heatstroke or class({})

function modifier_heatstroke:RemoveOnDeath() return true end
function modifier_heatstroke:IsPurgable() return false end
function modifier_heatstroke:IsDebuff() return true end

function modifier_heatstroke:IsHidden() return false end

function modifier_heatstroke:OnCreated()
    self.parent = self:GetParent()
    self.stage = 1
    self.movespeed = {0, -10, -30, -50}
    self.attack_speed = {0, -20, -50, -100}

    if not IsServer() then return end

    self:StartIntervalThink(1)
end

function modifier_heatstroke:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, -- GetModifierMoveSpeedBonus_Percentage
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, -- GetModifierAttackSpeedBonus_Constant
    }
end

function modifier_heatstroke:GetModifierMoveSpeedBonus_Percentage() return self.movespeed[self.stage] end
function modifier_heatstroke:GetModifierAttackSpeedBonus_Constant() return self.attack_speed[self.stage] end

function modifier_heatstroke:OnStackCountChanged()
    local stacks = self:GetStackCount()

    if stacks >= 100 then
        self.stage = 4

        if IsServer() then
            ApplyDamage({
                victim = self.parent,
                attacker = self.parent,
                damage = self.parent:GetMaxHealth() * 0.01 * 0.05 * stacks,
                damage_type = DAMAGE_TYPE_PURE,
                damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
            })
        end
    elseif stacks >= 50 then
        self.stage = 3

        if IsServer() then
            ApplyDamage({
                victim = self.parent,
                attacker = self.parent,
                damage = 50,
                damage_type = DAMAGE_TYPE_PURE,
                damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
            })
        end
    elseif stacks >= 25 then
        self.stage = 2
    else
        self.stage = 1
    end
end