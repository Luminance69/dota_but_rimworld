--[[
    Give Up:
        Your hero gives up and walks towards the enemies base
        30s duration
]]

require("modifiers/mental_breaks/base_mental_break")

modifier_give_up = class(base_mental_break)

function modifier_give_up:GetTexture() return "mental_breaks/extreme" end

function modifier_give_up:OnCreated()
    if IsClient() then return end
    
    self:SetDuration(30, true)

    local parent = self:GetParent()

    local units = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
    
    for _, unit in pairs(units) do
        if unit:GetUnitName() == "dota_fountain" then
            self.target = unit
            self:StartIntervalThink(1)
        end
    end
end

function modifier_give_up:OnIntervalThink()
    self:GetParent():MoveToPosition(self.target:GetAbsOrigin())
end

function modifier_give_up:OnRemoved()
    if IsClient() then return end
    
    self:GetParent():Stop()
end

function modifier_give_up:CheckState()
    return {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    }
end