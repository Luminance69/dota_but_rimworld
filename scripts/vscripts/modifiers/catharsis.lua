modifier_catharsis = modifier_catharsis or class({})

function modifier_catharsis:AllowIllusionDuplicate() return false end
function modifier_catharsis:HeroEffectPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_catharsis:IsHidden() return false end
function modifier_catharsis:IsPermanent() return true end
function modifier_catharsis:IsPurgable() return false end

function modifier_catharsis:GetTexture() return "mental_breaks/mood" end

function modifier_catharsis:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_catharsis:OnTooltip()
    return 40
end

function modifier_catharsis:GetMoodBonus()
    return -40
end