--[[
	Pesimist:
		-8 Mood
]]

require("modifiers/traits/base_trait")

modifier_pesimist = class(base_trait)

function modifier_pesimist:IsDebuff() return true end

function modifier_pesimist:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP, -- OnTooltip
    }
end

function modifier_pesimist:GetMoodBonus()
    return -8
end

function modifier_pesimist:OnTooltip()
    return 8
end

function modifier_pesimist:OnCreated()
    self:SetStackCount(8)
end