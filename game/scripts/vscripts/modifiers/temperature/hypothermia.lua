--[[
Hypothermia:
    Gain 1 stack every second while the temperature is more than 5 below min.
    Lose 1 stack every second per 2 degrees above min (rounded up).

    25 stacks:
        -10% movespeed
        -20 attack speed
        -25% HP regen

    50 stacks:
        -30% movespeed
        -50 attack speed
        -50% HP regen
        25 magic DPS

    100 stacks:
        -100% movespeed
        -200 attack speed
        -100% HP regen
        stack count - 50 magic DPS

        Frostbite:
            Permanent.
            -25% movespeed
            -20% base attack damage
            +50% illness chance
]]

modifier_hypothermia = modifier_hypothermia or class({})

function modifier_hypothermia:RemoveOnDeath() return true end
function modifier_hypothermia:IsPurgable() return false end
function modifier_hypothermia:IsDebuff() return true end

function modifier_hypothermia:IsHidden() return false end

function modifier_hypothermia:OnCreated()
    self.parent = self:GetParent()
    self.stage = 1
    self.movespeed = {0, -10, -30, -100}
    self.attack_speed = {0, -20, -50, -200}
    self.regen = {0, -25, -50, -100}

    if not IsServer() then return end

    self:StartIntervalThink(1)
end

function modifier_hypothermia:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, -- GetModifierMoveSpeedBonus_Percentage
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, -- GetModifierAttackSpeedBonus_Constant

        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE, -- GetModifierHPRegenAmplify_Percentage
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET, -- GetModifierHealAmplify_PercentageTarget
        MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE, -- GetModifierLifestealRegenAmplify_Percentage
    }
end

function modifier_hypothermia:GetModifierMoveSpeedBonus_Percentage() return self.movespeed[self.stage] end
function modifier_hypothermia:GetModifierAttackSpeedBonus_Constant() return self.attack_speed[self.stage] end

function modifier_hypothermia:GetModifierHPRegenAmplify_Percentage() return self.regen[self.stage] end
function modifier_hypothermia:GetModifierHealAmplify_PercentageTarget() return self.regen[self.stage] end
function modifier_hypothermia:GetModifierLifestealRegenAmplify_Percentage() return self.regen[self.stage] end

function modifier_hypothermia:OnStackCountChanged()
    local stacks = self:GetStackCount()

    if stacks >= 100 then
        self.stage = 4

        if IsServer() then
            if not self.parent:FindModifierByName("modifier_frostbite") then self.parent:AddNewModifier(self.parent, nil, "modifier_frostbite", nil) end

            ApplyDamage({
                victim = self.parent,
                attacker = self.parent,
                damage = stacks - 50,
                damage_type = DAMAGE_TYPE_MAGICAL,
                damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
            })
        end
    elseif stacks >= 50 then
        self.stage = 3

        if IsServer() then
            ApplyDamage({
                victim = self.parent,
                attacker = self.parent,
                damage = 25,
                damage_type = DAMAGE_TYPE_MAGICAL,
                damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
            })
        end
    elseif stacks >= 25 then
        self.stage = 2
    else
        self.stage = 1
    end
end