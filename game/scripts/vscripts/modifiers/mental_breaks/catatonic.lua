--[[
    Catatonic:
        Your hero is stunned
        60s duration
]]

require("modifiers/mental_breaks/base_mental_break")

modifier_catatonic = class(base_mental_break)

function modifier_catatonic:GetTexture() return "mental_breaks/extreme" end

function modifier_catatonic:OnCreated()
    self:SetDuration(60, true)
end

function modifier_catatonic:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true,
    }
end