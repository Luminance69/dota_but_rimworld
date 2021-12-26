base_birthday = base_birthday or class({})

function base_birthday:AllowIllusionDuplicate() return false end
function base_birthday:GetPriority() return MODIFIER_PRIORITY_ULTRA end

function base_birthday:IsHidden() return false end
function base_birthday:IsPermanent() return true end
function base_birthday:IsPurgable() return false end

function base_birthday:GetTexture() return "birthday" end