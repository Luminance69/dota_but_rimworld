psychic_drone = psychic_drone or class({})

function psychic_drone:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP, -- OnTooltip
    }
end

function psychic_drone:IsHidden() return false end
function psychic_drone:IsDebuff() return false end
function psychic_drone:IsPurgable() return false end
function psychic_drone:IsPermanent() return true end

modifier_psychic_drone_low = class(psychic_drone)
modifier_psychic_drone_medium = class(psychic_drone)
modifier_psychic_drone_high = class(psychic_drone)
modifier_psychic_drone_extreme = class(psychic_drone)

function modifier_psychic_drone_low:OnTooltip() return 6 end
function modifier_psychic_drone_low:GetMoodBonus() return -6 end

function modifier_psychic_drone_medium:OnTooltip() return 12 end
function modifier_psychic_drone_medium:GetMoodBonus() return -12 end

function modifier_psychic_drone_high:OnTooltip() return 20 end
function modifier_psychic_drone_high:GetMoodBonus() return -20 end

function modifier_psychic_drone_extreme:OnTooltip() return 35 end
function modifier_psychic_drone_extreme:GetMoodBonus() return -35 end