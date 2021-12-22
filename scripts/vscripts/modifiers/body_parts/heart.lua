require("modifiers/body_parts/base_body_part")

--[[
    Heart:
		Bionic:
			+10 Strength
			+100 Health
			+0.4% Max HP Regen
		Archotech:
			+18 Strength
			+175 Health
			+0.6% Max HP Regen
		Healing Enhancer:
			+75% Healing Amplification
]]

base_heart = class(base_body_part)

function base_heart:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, -- GetModifierBonusStats_Strength
        MODIFIER_PROPERTY_HEALTH_BONUS, -- GetModifierHealthBonus
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, -- GetModifierHealthRegenPercentage
    }
end


modifier_heart_bionic = class(base_heart)

function modifier_heart_bionic:GetModifierBonusStats_Strength() return 10 end
function modifier_heart_bionic:GetModifierHealthBonus() return 100 end
function modifier_heart_bionic:GetModifierHealthRegenPercentage() return 0.4 end
function modifier_heart_bionic:GetTexture() return "body_parts/bionic_heart" end


modifier_heart_archotech = class(base_heart)

function modifier_heart_archotech:GetModifierBonusStats_Strength() return 18 end
function modifier_heart_archotech:GetModifierHealthBonus() return 175 end
function modifier_heart_archotech:GetModifierHealthRegenPercentage() return 0.6 end
function modifier_heart_archotech:GetTexture() return "body_parts/archotech_heart" end


modifier_heart_healing_enhancer = class(base_body_part)

function modifier_heart_healing_enhancer:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_SOURCE, -- GetModifierHealAmplify_PercentageSource
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE, -- GetModifierHPRegenAmplify_Percentage
    }
end

function modifier_heart_healing_enhancer:GetModifierHealAmplify_PercentageSource() return 75 end
function modifier_heart_healing_enhancer:GetModifierHPRegenAmplify_Percentage() return 75 end
function modifier_heart_healing_enhancer:GetTexture() return "body_parts/healing_enhancer" end