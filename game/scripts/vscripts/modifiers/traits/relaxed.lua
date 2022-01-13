-- Relaxed:
-- -25% XP Gain
-- -8 Mental Break Threshold

require("modifiers/traits/base_trait")

modifier_relaxed = class(base_trait)

function modifier_relaxed:IsDebuff() return false end

function modifier_relaxed:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
    }
end

function modifier_relaxed:GetExperienceMultiplierBonus()
    return -25
end

function modifier_relaxed:OnTooltip()
    return -25
end

function modifier_relaxed:GetMentalBreakThresholdBonus()
    return -8
end

function modifier_relaxed:OnTooltip2()
    return -8
end
