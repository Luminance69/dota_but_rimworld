modifier_psychic_soothe = modifier_psychic_soothe or class({})

function modifier_psychic_soothe:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP, -- OnTooltip
    }
end

function modifier_psychic_soothe:IsHidden() return false end
function modifier_psychic_soothe:IsDebuff() return false end
function modifier_psychic_soothe:IsPurgable() return false end
function modifier_psychic_soothe:IsPermanent() return true end

function modifier_psychic_soothe:OnTooltip() return 12 end
function modifier_psychic_soothe:GetMoodBonus() return 12 end