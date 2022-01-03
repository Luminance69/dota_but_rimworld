--[[
    Slaughterer:
        Your hero will kill the nearest friendly creeps (basically ww ulti)
        30s duration
]]

require("modifiers/mental_breaks/base_mental_break")

modifier_slaughterer = class(base_mental_break)

function modifier_slaughterer:GetTexture() return "mental_breaks/major" end

function modifier_slaughterer:OnCreated()
    self:SetDuration(30, true)

    self:FindNewTarget()
end

function modifier_slaughterer:FindNewTarget()
    if IsClient() then return end

    local parent = self:GetParent()

    self.target = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)[1]
    
    parent:MoveToTargetToAttack(self.target)
    parent:SetForceAttackTargetAlly(self.target)
end

function modifier_slaughterer:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH, -- OnDeath
    }
end

function modifier_slaughterer:OnDeath(keys)
    if IsClient() then return end
    
    if not keys.unit == self.target then return end

    self:FindNewTarget()
end

function modifier_slaughterer:OnRemoved()
    if IsClient() then return end
    
    self:GetParent():Stop()
    self:GetParent():SetForceAttackTarget(nil)
end

function modifier_slaughterer:CheckState()
    return {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    }
end