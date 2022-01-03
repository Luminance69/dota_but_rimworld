-- Too Smart:
-- +50% XP Gain
-- +12 Mental Break Threshold

require("modifiers/traits/base_trait")

modifier_too_smart = class(base_trait)

function modifier_too_smart:IsDebuff() return false end

function modifier_too_smart:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
    }
end

function modifier_too_smart:GetExperienceMultiplierBonus()
    return 50
end

function modifier_too_smart:OnTooltip()
    return 50
end

function modifier_too_smart:GetMentalBreakThresholdBonus()
    return 12
end

function modifier_too_smart:OnTooltip2()
    return 12
end