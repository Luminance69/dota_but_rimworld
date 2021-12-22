require("modifiers/body_parts/base_body_part")
require("rimworld/clothes")

--[[
    Leg:
    	Bionic:
			+10% Movement Speed
			+3 Armor
		Archotech:
			+40% Movement Speed
			+5 Armor
		Stoneskin Gland:
			-40% Movement Speed
			+25 Armor
			Unable to hold any boots
]]

base_leg = class(base_body_part)

function base_leg:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, -- GetModifierMoveSpeedBonus_Percentage
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, -- GetModifierPhysicalArmorBonus
    }
end


modifier_leg_bionic = class(base_leg)

function modifier_leg_bionic:GetModifierMoveSpeedBonus_Percentage() return 10 end
function modifier_leg_bionic:GetModifierPhysicalArmorBonus() return 3 end
function modifier_leg_bionic:GetTexture() return "body_parts/bionic_leg" end


modifier_leg_archotech = class(base_leg)

function modifier_leg_archotech:GetModifierMoveSpeedBonus_Percentage() return 40 end
function modifier_leg_archotech:GetModifierPhysicalArmorBonus() return 5 end
function modifier_leg_archotech:GetTexture() return "body_parts/archotech_leg" end


modifier_leg_stoneskin_gland = class(base_leg)

function modifier_leg_stoneskin_gland:GetModifierMoveSpeedBonus_Percentage() return -40 end
function modifier_leg_stoneskin_gland:GetModifierPhysicalArmorBonus() return 25 end
function modifier_leg_stoneskin_gland:GetTexture() return "body_parts/stoneskin_gland" end

function modifier_leg_stoneskin_gland:OnCreated()
    if IsClient() then return end

    self.parent = self:GetParent()

    self.slots = {0, 1, 2, 3, 4, 5, 16}

    self:StartIntervalThink(1)
end

function modifier_leg_stoneskin_gland:OnIntervalThink()
    if not self.parent then return end
    for _, slot in pairs(self.slots) do
        local item = self.parent:GetItemInSlot(slot)

        if item and item:IsActivated() then
            local types = Clothes:GetItemTypes(item:GetAbilityName())

            if types and types["boots"] then
                item:SetActivated(false)

                item:OnUnequip()
                item:OnEquip()
            end
        end
    end
end

function modifier_leg_stoneskin_gland:OnDestroy()
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

