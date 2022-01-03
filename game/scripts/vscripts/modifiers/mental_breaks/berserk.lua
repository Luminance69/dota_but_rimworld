--[[
    Berserk:
        Your hero will kill the nearest allied hero
        30s duration (or when unit dies)
]]

require("modifiers/mental_breaks/base_mental_break")

modifier_berserk = class(base_mental_break)

function modifier_berserk:GetTexture() return "mental_breaks/extreme" end

function modifier_berserk:OnCreated()
    self:SetDuration(30, true)

    if IsClient() then return end
    
    self:StartIntervalThink(0.5)
end

function modifier_berserk:OnIntervalThink()
    local parent = self:GetParent()

    local targets = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

    for _, target in pairs(targets) do
        if target:IsRealHero() and not target:IsTempestDouble() and target ~= parent then
            self.target = target
        end
    end

    -- If no ally is alive then just wander around till there is one
    if not self.target then
        parent:MoveToPosition(parent:GetAbsOrigin() + RandomVector(600))
    else
        parent:SetAggroTarget(self.target)
    
        parent:MoveToPositionAggressive(self.target:GetAbsOrigin())
    
        parent:SetForceAttackTargetAlly(self.target)

        self:StartIntervalThink(-1)
    end
end

function modifier_berserk:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH, -- OnDeath
    }
end

function modifier_berserk:OnDeath(keys)
    if IsClient() then return end
    
    if not keys.unit == self.target then return end

    self:Destroy()
end

function modifier_berserk:OnRemoved()
    if IsClient() then return end
    
    self:GetParent():Stop()
    self:GetParent():SetForceAttackTarget(nil)
end

function modifier_berserk:CheckState()
    return {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    }
end