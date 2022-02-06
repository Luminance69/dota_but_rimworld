modifier_thirsty = modifier_thirsty or class({})

function modifier_thirsty:IsPermanent() return true end
function modifier_thirsty:IsPurgable() return false end
function modifier_thirsty:IsDebuff() return true end

function modifier_thirsty:IsHidden() return false end

function modifier_thirsty:OnCreated()
    if not IsServer() then return end

    self.parent = self:GetParent()

    self.timer = 120
    
    self:StartIntervalThink(1)
end

function modifier_thirsty:OnIntervalThink()
    if self.parent:GetAbsOrigin().z == 0 
    or self.parent:HasModifier("modifier_fountain_aura_buff")
    or self.parent:HasModifier("modifier_bottle_regeneration") then
        self.timer = 120
    else
        self.timer = self.timer - 1
    end

    self:SetStackCount(self.timer)
end

function modifier_thirsty:GetMoodBonus()
    return self.timer < 0 and -8 or 0
end