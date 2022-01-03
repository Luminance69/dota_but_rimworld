--[[
	Weight: 5
	Cataract:
		-25% vision
]]

require("modifiers/birthdays/base_birthday")

modifier_cataract = class(base_birthday)

function modifier_cataract:IsDebuff() return true end

function modifier_cataract:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE, -- GetBonusVisionPercentage
    }
end

function modifier_cataract:GetBonusVisionPercentage()
    return (-1 + 0.75 ^ self:GetStackCount()) * 100
end