modifier_mad_neutral = modifier_mad_neutral or class({})

local outposts = {
    ["#DOTA_OutpostName_South"] = true,
    ["#DOTA_OutpostName_North"] = true,
}

function modifier_mad_neutral:OnCreated()
    if IsClient() then return end

    self:SetNewTarget()

    self:StartIntervalThink(1)
end

function modifier_mad_neutral:OnIntervalThink()
    if not self:GetParent():IsAlive() then
        self:Destroy()
        return
    elseif not self.target:IsAlive() then
        self:SetNewTarget()
    end
end

function modifier_mad_neutral:SetNewTarget()
    local targets = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, self:GetParent():GetAbsOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

    while outposts[targets[1]:GetUnitName()] do
        table.remove(targets, 1)
    end

    self.target = targets[1]

    self:GetParent():SetForceAttackTarget(self.target)
end

function modifier_mad_neutral:IsDebuff() return true end
function modifier_mad_neutral:IsHidden() return false end
function modifier_mad_neutral:IsPermanent() return true end
function modifier_mad_neutral:IsPurgable() return false end

function modifier_mad_neutral:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, -- OnAbilityFullyCast
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, -- GetModifierIncomingDamage_Percentage
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, -- GetModifierPreAttack_BonusDamage
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, -- GetModifierMoveSpeedBonus_Percentage
    }
end

function modifier_mad_neutral:OnAbilityFullyCast(keys)
    if keys.ability:GetAbilityName() == "item_helm_of_the_overlord" or keys.ability:GetAbilityName() == "item_helm_of_the_dominator" and keys.target and keys.target == self:GetParent() then
        self:Destroy()
    end
end

function modifier_mad_neutral:GetModifierIncomingDamage_Percentage() return -50 end
function modifier_mad_neutral:GetModifierPreAttack_BonusDamage() return 25 + GameRules:GetGameTime() / 30 end
function modifier_mad_neutral:GetModifierMoveSpeedBonus_Percentage() return 50 end