modifier_sweaty = modifier_sweaty or class({})

function modifier_sweaty:IsPermanent() return true end
function modifier_sweaty:IsPurgable() return false end
function modifier_sweaty:IsDebuff() return true end

function modifier_sweaty:IsHidden() return true end

function modifier_sweaty:OnCreated()
    if not IsServer() then return end
    
    self:StartIntervalThink(1)
end

function modifier_sweaty:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_REDUCTION_PERCENTAGE, -- GetModifierAttackSpeedReductionPercentage
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE, -- GetModifierPercentageCasttime
    }
end

function modifier_sweaty:OnIntervalThink()
    if not (Temperature and Temperature.temp) then return end

    if Temperature.temp > 30 then
        self.active = true
    else
        self.active = false
    end
end

function modifier_sweaty:GetMoodBonus()
    return self.active and -8 or 0
end

function modifier_sweaty:GetIllnessChanceBonus()
    return 100
end

function modifier_sweaty:GetModifierAttackSpeedReductionPercentage()
    return 10
end

function modifier_sweaty:GetModifierPercentageCasttime()
    return -10
end