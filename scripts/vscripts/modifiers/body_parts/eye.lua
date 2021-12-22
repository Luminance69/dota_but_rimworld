require("modifiers/body_parts/base_body_part")
require("rimworld/clothes")

--[[
    Eye:
		Bionic:
			+25% Vision
			+2 Armor
		Archotech:
			+75% Vision
			+4 Armor
		Eye of Apollo:
			+30% Vision
			+20% stats from head items
]]

base_eye = class(base_body_part)

function base_eye:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE, -- GetBonusVisionPercentage
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, -- GetModifierPhysicalArmorBonus
    }
end


modifier_eye_bionic = class(base_eye)

function modifier_eye_bionic:GetBonusVisionPercentage() return 25 end
function modifier_eye_bionic:GetModifierPhysicalArmorBonus() return 3 end
function modifier_eye_bionic:GetTexture() return "body_parts/bionic_eye" end


modifier_eye_archotech = class(base_eye)

function modifier_eye_archotech:GetBonusVisionPercentage() return 75 end
function modifier_eye_archotech:GetModifierPhysicalArmorBonus() return 5 end
function modifier_eye_archotech:GetTexture() return "body_parts/archotech_eye" end


modifier_eye_eye_of_apollo = class(base_body_part)

function modifier_eye_eye_of_apollo:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE, -- GetBonusVisionPercentage
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL, -- GetModifierOverrideAbilitySpecial
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE, -- GetModifierOverrideAbilitySpecialValue
    }
end

function modifier_eye_eye_of_apollo:GetBonusVisionPercentage() return 30 end
function modifier_eye_eye_of_apollo:GetTexture() return "body_parts/eye_of_apollo" end

local exclusions = {
    ["item_mask_of_madness"] = {
        ["berserk_duration"] = true,
    },
    ["item_helm_of_the_dominator"] = {
        ["bounty_gold"] = true,
    },
    ["item_helm_of_the_dominator_2"] = {
        ["bounty_gold"] = true,
    },
}

function modifier_eye_eye_of_apollo:GetModifierOverrideAbilitySpecial(keys)
    if not keys.ability or not keys.ability_special_value then return 0 end

    local item = keys.ability
    local special_value = keys.ability_special_value
    
    local types = Clothes:GetItemTypes(item:GetAbilityName())

    if types and types["head"] then
        local item_name = item:GetAbilityName()

        if exclusions[item_name] and exclusions[item_name][special_value] then
            return 0
        else
            return 1
        end
    else
        return 0
    end
end

function modifier_eye_eye_of_apollo:GetModifierOverrideAbilitySpecialValue(keys) return 1.2 end