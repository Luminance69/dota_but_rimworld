--[[
    Tantrum:
        Forces your hero to attack itself
        10s duration or 25% HP
]]

require("modifiers/mental_breaks/base_mental_break")

modifier_tantrum = class(base_mental_break)

function modifier_tantrum:GetTexture() return "mental_breaks/major" end

function modifier_tantrum:OnCreated()
    self:SetDuration(30, true)

    if IsClient() then return end

    self.parent = self:GetParent()

    self.parent:SetAggroTarget(self.parent)

    self.parent:MoveToPositionAggressive(self.parent:GetAbsOrigin())

    self.parent:SetForceAttackTargetAlly(self.parent)
end

function modifier_tantrum:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED, -- OnAttackLanded
    }
end

function modifier_tantrum:OnAttackLanded(keys)
    if IsClient() then return end
    
    if keys.target ~= self.parent or keys.attacker ~= self.parent then return end

    -- Health doesn't update until next game tick
    Timers:CreateTimer(FrameTime(), function()
        if self.parent:GetHealth() / self.parent:GetMaxHealth() < 0.25 then
            self:Destroy()
        end
    end)
end

function modifier_tantrum:OnRemoved()
    if IsClient() then return end
    
    self.parent:MoveToTargetToAttack(nil)
    self.parent:SetForceAttackTarget(nil)
    self.parent:Stop()
end

function modifier_tantrum:CheckState()
    return {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    }
end