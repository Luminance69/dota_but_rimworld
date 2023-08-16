modifier_mad_neutral = modifier_mad_neutral or class({})

local outposts = {
    ["#DOTA_OutpostName_South"] = true,
    ["#DOTA_OutpostName_North"] = true,
}

function modifier_mad_neutral:OnCreated()
    self:SetNewTarget()

    self:StartIntervalThink(1)
end

function modifier_mad_neutral:OnIntervalThink()
    if not (self:GetParent() and self:GetParent().IsAlive and self:GetParent():IsAlive()) then
        self:Destroy()
        return
    end

    self.bored = self.bored + 1

    if not (self.target and self.target:IsAlive()) or (1 / RandomFloat(1, self.bored) < 0.1) then
        self:SetNewTarget()
    end

    if not (Incidents and Incidents.GetPowerLevel) then return end

    local power_level = Incidents:GetPowerLevel()

    self.bonus_dmg = 25 + power_level * 30
    self.dmg_resist = math.pow(0.7, power_level) * -100
    self.bonus_speed = 50

    if self:GetParent():GetTeamNumber() ~= DOTA_TEAM_NEUTRALS then
        self.dmg_resist = self.dmg_resist * 0.5
        self.bonus_dmg = self.bonus_dmg * 0.25
        self.bonus_speed = 10
    end
end

function modifier_mad_neutral:SetNewTarget()
    if IsClient() then return end

    self.bored = 0

    local targets = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, self:GetParent():GetAbsOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

    while outposts[targets[1]:GetUnitName()] do
        table.remove(targets, 1)
    end

    self.target = targets[RandomInt(1, max(1, math.floor(#targets / 5)))]

    self:GetParent():SetForceAttackTarget(self.target)
end

function modifier_mad_neutral:IsDebuff() return true end
function modifier_mad_neutral:IsHidden() return false end
function modifier_mad_neutral:IsPermanent() return true end
function modifier_mad_neutral:IsPurgable() return false end

function modifier_mad_neutral:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, -- GetModifierIncomingDamage_Percentage
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, -- GetModifierPreAttack_BonusDamage
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, -- GetModifierMoveSpeedBonus_Percentage
    }
end

function modifier_mad_neutral:GetModifierIncomingDamage_Percentage() return self.dmg_resist end
function modifier_mad_neutral:GetModifierPreAttack_BonusDamage() return self.bonus_dmg end
function modifier_mad_neutral:GetModifierMoveSpeedBonus_Percentage() return self.bonus_speed end
