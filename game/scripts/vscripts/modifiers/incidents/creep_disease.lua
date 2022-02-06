--[[
	Creep Disease:
		50% of allied creeps are infected with disease.
		-10/30/60% movement speed
		-10/30/60 attack speed
		-10/20/30% damage
		Upgrades after 8-16 seconds
		At the end of the third stage, creeps have a 50% chance to be cured and a 50% chance to die
]]

creep_disease = creep_disease or class({})

function creep_disease:AllowIllusionDuplicate() return false end
function creep_disease:GetPriority() return MODIFIER_PRIORITY_HIGH end

function creep_disease:IsHidden() return false end
function creep_disease:IsPermanent() return false end
function creep_disease:IsPurgable() return true end
function creep_disease:IsDebuff() return true end

function creep_disease:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, -- GetModifierMoveSpeedBonus_Percentage()
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, -- GetModifierAttackSpeedBonus_Constant()
        MODIFIER_PROPERTY_BONUSDAMAGEOUTGOING_PERCENTAGE, -- GetModifierBonusDamageOutgoing_Percentage()
    }
end

function creep_disease:GetModifierMoveSpeedBonus_Percentage() return self.move_speed end
function creep_disease:GetModifierAttackSpeedBonus_Constant() return self.attack_speed end
function creep_disease:GetModifierBonusDamageOutgoing_Percentage() return self.bonus_damage end



modifier_creep_disease_minor = class(creep_disease)

function modifier_creep_disease_minor:OnCreated()
    self.parent = self:GetParent()

    self:SetDuration(RandomInt(10, 20), true)

    self.move_speed = -10
    self.attack_speed = -10
    self.bonus_damage = -10
end

function modifier_creep_disease_minor:OnRemoved()
    if IsClient() then return end

    self.parent:AddNewModifier(self.parent, nil, "modifier_creep_disease_major", nil)
end



modifier_creep_disease_major = class(creep_disease)

function modifier_creep_disease_major:OnCreated()
    self.parent = self:GetParent()
    
    self:SetDuration(RandomInt(10, 20), true)

    self.move_speed = -30
    self.attack_speed = -30
    self.bonus_damage = -20
end

function modifier_creep_disease_major:OnRemoved()
    if IsClient() then return end
    
    self.parent:AddNewModifier(self.parent, nil, "modifier_creep_disease_extreme", nil)
end



modifier_creep_disease_extreme = class(creep_disease)

function modifier_creep_disease_extreme:OnCreated()
    self.parent = self:GetParent()
    
    self:SetDuration(RandomInt(10, 20), true)

    self.move_speed = -60
    self.attack_speed = -60
    self.bonus_damage = -30
end

function modifier_creep_disease_extreme:OnRemoved()
    if IsClient() then return end
    
    if RandomFloat(0, 1) < 0.5 then
        self.parent:ForceKill(true)
    end
end