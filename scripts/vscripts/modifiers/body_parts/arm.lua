require("modifiers/body_parts/base_body_part")
require("rimworld/clothes")

--[[
    Arm:
		Bionic:
			+10% Attack Speed
			+10% Casting Point Reduction
			+3 Armor
		Archotech:
			+20% Attack Speed
			+50% Casting Point Reduction
			+5 Armor
		Power Claws:
			+400% attack damage
			Unable to use items with handles / gloves
]]

modifier_arm_bionic = class(base_body_part)

function modifier_arm_bionic:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE, -- GetModifierAttackSpeedPercentage
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE, -- GetModifierPercentageCasttime
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, -- GetModifierPhysicalArmorBonus
    }
end

function modifier_arm_bionic:GetTexture() return "body_parts/bionic_arm" end
function modifier_arm_bionic:GetModifierAttackSpeedPercentage() return 10 end
function modifier_arm_bionic:GetModifierPercentageCasttime() return 10 end
function modifier_arm_bionic:GetModifierPhysicalArmorBonus() return 3 end


modifier_arm_archotech = class(base_body_part)

function modifier_arm_archotech:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE, -- GetModifierAttackSpeedPercentage
        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE, -- GetModifierPercentageCasttime
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, -- GetModifierPhysicalArmorBonus
    }
end

function modifier_arm_archotech:GetTexture() return "body_parts/archotech_arm" end
function modifier_arm_archotech:GetModifierAttackSpeedPercentage() return 20 end
function modifier_arm_archotech:GetModifierPercentageCasttime() return 50 end
function modifier_arm_archotech:GetModifierPhysicalArmorBonus() return 5 end


modifier_arm_power_claws = class(base_body_part)

function modifier_arm_power_claws:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_BONUSDAMAGEOUTGOING_PERCENTAGE, -- GetModifierBonusDamageOutgoing_Percentage
    }
end

function modifier_arm_power_claws:GetModifierBonusDamageOutgoing_Percentage() return 400 end
function modifier_arm_power_claws:GetTexture() return "body_parts/power_claws" end

function modifier_arm_power_claws:OnCreated()
    if IsClient() then return end

    self.parent = self:GetParent()

    self.slots = {0, 1, 2, 3, 4, 5, 16}

    self:StartIntervalThink(1)
end

function modifier_arm_power_claws:OnIntervalThink()
    if not self.parent then return end
    for _, slot in pairs(self.slots) do
        local item = self.parent:GetItemInSlot(slot)

        if item and item:IsActivated() then
            local types = Clothes:GetItemTypes(item:GetAbilityName())

            if types and types["hands"] then
                item:SetActivated(false)

                item:OnUnequip()
                item:OnEquip()
            end
        end
    end
end

function modifier_arm_power_claws:OnDestroy()
    if not self.parent or self.parent:IsNull() then return end

    for _, slot in pairs(self.slots) do
        local item = self.parent:GetItemInSlot(slot)

        if item and not item:IsActivated() then
            item:SetActivated(true)

            item:OnUnequip()
            item:OnEquip()
        end
    end
end

