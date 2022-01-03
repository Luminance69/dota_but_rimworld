--[[
    Hide Under Tower:
        Your hero hides in the nearest tower
        20s duration
]]

require("modifiers/mental_breaks/base_mental_break")

modifier_hide_under_tower = class(base_mental_break)

function modifier_hide_under_tower:GetTexture() return "mental_breaks/minor" end

function modifier_hide_under_tower:OnCreated()
    self:SetDuration(20, true)

    self:StartIntervalThink(2)
end

function modifier_hide_under_tower:OnIntervalThink()
    if IsClient() then return end

    local parent = self:GetParent()

    local tower = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)[1]
    
    parent:MoveToPosition(tower:GetAbsOrigin() + RandomVector(300))
end

function modifier_hide_under_tower:OnRemoved()
    if IsClient() then return end
    
    self:GetParent():Stop()
end

function modifier_hide_under_tower:CheckState()
    return {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    }
end