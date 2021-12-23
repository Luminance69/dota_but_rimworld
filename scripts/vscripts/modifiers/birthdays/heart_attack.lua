--[[
	Heart Attack:
		Take 10% max HP DPS for 20 seconds, after which you die
		Purged with healing salve
]]

require("modifiers/birthdays/base_birthday")

modifier_heart_attack = class(base_birthday)

function modifier_heart_attack:IsDebuff() return true end

function modifier_heart_attack:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, -- OnAbilityFullyCast
    }
end

function modifier_heart_attack:OnAbilityFullyCast(keys)
    if keys.ability:GetAbilityName() == "item_flask" and keys.target and keys.target == self:GetParent() then
        self:Destroy()
    end
end

function modifier_heart_attack:OnCreated()
    if IsClient() then return end

    self:StartIntervalThink(1)
end

function modifier_heart_attack:OnIntervalThink()
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetParent(),
        damage = self:GetParent():GetMaxHealth() * 0.15,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_HPLOSS,
    })
end