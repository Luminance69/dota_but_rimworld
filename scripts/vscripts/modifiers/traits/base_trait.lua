base_trait = base_trait or class({})

function base_trait:AllowIllusionDuplicate() return false end
function base_trait:HeroEffectPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function base_trait:IsHidden() return false end
function base_trait:IsPermanent() return true end
function base_trait:IsPurgable() return false end