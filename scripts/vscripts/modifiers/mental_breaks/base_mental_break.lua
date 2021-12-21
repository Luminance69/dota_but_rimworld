base_mental_break = base_mental_break or class({})

function base_mental_break:AllowIllusionDuplicate() return false end
function base_mental_break:HeroEffectPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function base_mental_break:IsHidden() return false end
function base_mental_break:IsDebuff() return true end
function base_mental_break:IsPermanent() return false end
function base_mental_break:IsPurgable() return false end

-- function base_mental_break:GetTexture() return "mental_breaks/" end