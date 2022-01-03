-- Relaxed:
-- -25% XP Gain
-- -8 Mental Break Threshold

require("modifiers/traits/base_trait")

modifier_relaxed = class(base_trait)

function modifier_relaxed:IsDebuff() return false end

function modifier_too_smart:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
    }
end

function modifier_relaxed:GetExperienceMultiplierBonus()
    return -25
end

function modifier_too_smart:OnTooltip()
    return -25
end

function modifier_relaxed:GetMentalBreakThresholdBonus()
    return -8
end

function modifier_too_smart:OnTooltip2()
    return -8
end
