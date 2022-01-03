--[[
	Optimist:
		+8 Mood
]]

require("modifiers/traits/base_trait")

modifier_optimist = class(base_trait)

function modifier_optimist:IsDebuff() return false end

function modifier_optimist:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP, -- OnTooltip
    }
end

function modifier_optimist:GetMoodBonus()
    return 8
end

function modifier_optimist:OnTooltip()
    return 8
end

function modifier_optimist:OnCreated()
    self:SetStackCount(8)
end