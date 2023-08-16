require("modifiers/birthdays/base_birthday")

modifier_heart_attack = class(base_birthday)

function modifier_heart_attack:IsDebuff() return true end
function modifier_heart_attack:RemoveOnDeath() return true end

function modifier_heart_attack:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, -- OnAbilityFullyCast
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, -- GetModifierMoveSpeedBonus_Percentage
        MODIFIER_PROPERTY_ATTACKSPEED_REDUCTION_PERCENTAGE, -- GetModifierAttackSpeedReductionPercentage
    }
end

function modifier_heart_attack:OnAbilityFullyCast(keys)
    if keys.ability:GetAbilityName() == "item_flask" and keys.target and keys.target == self:GetParent() then
        self.cured = -0.04
    end
end

function modifier_heart_attack:OnCreated()
    if IsClient() then return end

    self.severity = 0.4
    self.cured = 0

    self:StartIntervalThink(FrameTime())
end

function modifier_heart_attack:GetModifierMoveSpeedBonus_Percentage() return -25 - self:GetStackCount() * 0.5 end
function modifier_heart_attack:GetModifierAttackSpeedReductionPercentage() return -10 - self:GetStackCount() * 0.2 end

function modifier_heart_attack:OnIntervalThink()
    local parent = self:GetParent()

    ApplyDamage({
        victim = parent,
        attacker = parent,
        damage = parent:GetMaxHealth() * 0.02,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS,
    })

    self.severity = self.severity + (RandomInt(0, 1) * 0.1 - 0.04) + self.cured

    if self.severity >= 1 then
        parent:ForceKill(true)
        self:Destroy()
    elseif self.severity < 0 then
        self:Destroy()
    end

    self:SetStackCount(self.severity * 100)

    self:StartIntervalThink(0.75 - self.severity / 2)
end