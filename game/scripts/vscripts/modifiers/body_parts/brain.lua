require("modifiers/body_parts/base_body_part")
require("rimworld/clothes")

--[[
	Brain:		
		Learning Assistant:
			+25% Experience Gain
		Joywire:
			+30 Mood
			-15% Vision
			-15% Attack Speed
			-15% Movement Speed
			-15% Cast Point Reduction
]]

modifier_brain_learning_assistant = class(base_body_part)

function modifier_brain_learning_assistant:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP, -- OnTooltip
    }
end

function modifier_brain_learning_assistant:OnTooltip() return 25 end
function modifier_brain_learning_assistant:GetExperienceMultiplierBonus() return 25 end
function modifier_brain_learning_assistant:GetTexture() return "body_parts/learning_assistant" end


modifier_brain_joywire = class(base_body_part)

function modifier_brain_joywire:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP, -- OnTooltip
        MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE, -- GetBonusVisionPercentage
        MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE, -- GetModifierAttackSpeedPercentage
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, -- GetModifierMoveSpeedBonus_Percentage
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE, -- GetModifierPercentageCasttime
    }
end

function modifier_brain_joywire:OnTooltip() return 30 end
function modifier_brain_joywire:GetMoodBonus() return 30 end
function modifier_brain_joywire:GetBonusVisionPercentage() return -15 end
function modifier_brain_joywire:GetModifierAttackSpeedPercentage() return -15 end
function modifier_brain_joywire:GetModifierMoveSpeedBonus_Percentage() return -15 end
function modifier_brain_joywire:GetModifierPercentageCasttime() return -15 end
function modifier_brain_joywire:GetTexture() return "body_parts/joywire" end