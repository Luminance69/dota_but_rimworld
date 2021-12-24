--[[
    Sadistic Rage:
        Your hero will kill the nearest enemy units (basically troll ulti)
        30s duration
]]

require("modifiers/mental_breaks/base_mental_break")

modifier_sadistic_rage = class(base_mental_break)

function modifier_sadistic_rage:GetTexture() return "mental_breaks/major" end

function modifier_sadistic_rage:OnCreated()
    self:SetDuration(30, true)

    self:FindNewTarget()
end

function modifier_sadistic_rage:FindNewTarget()
    if IsClient() then return end

    local parent = self:GetParent()

    self.target = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)[1]
    
    parent:SetForceAttackTarget(self.target)
    parent:MoveToTargetToAttack(self.target)
end

function modifier_sadistic_rage:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH, -- OnDeath
    }
end

function modifier_sadistic_rage:OnDeath(keys)
    if IsClient() then return end
    
    if not keys.unit == self.target then return end

    self:FindNewTarget()
end

function modifier_sadistic_rage:OnRemoved()
    if IsClient() then return end
    
    self:GetParent():Stop()
end

function modifier_sadistic_rage:CheckState()
    return {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    }
end