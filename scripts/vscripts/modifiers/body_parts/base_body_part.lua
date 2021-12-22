base_body_part = base_body_part or class({})

function base_body_part:AllowIllusionDuplicate() return false end
function base_body_part:HeroEffectPriority() return MODIFIER_PRIORITY_HIGH end

function base_body_part:IsHidden() return false end
function base_body_part:IsPermanent() return true end
function base_body_part:IsPurgable() return false end
function base_body_part:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end -- Allows the same modifier to exist several times on one unit
function base_body_part:IsDebuff() return false end
