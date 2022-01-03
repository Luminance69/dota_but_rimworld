-- Nudist:
-- +12 Mood if no clothing equipped
-- -4 Mood per clothing item equipped

require("modifiers/traits/base_trait")
require("rimworld/clothes")

modifier_nudist = class(base_trait)

function modifier_nudist:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_nudist:OnCreated()
    self:SetHasCustomTransmitterData(true)
    if IsClient() then return end

    self.parent = self:GetParent()

    self.slots = {0, 1, 2, 3, 4, 5, 16}

    self:StartIntervalThink(1)
end

function modifier_nudist:IsDebuff()
    return self.bonus and self.bonus < 0
end

function modifier_nudist:OnIntervalThink()
    if not self.parent then return end

    self.bonus = 0

    for _, slot in pairs(self.slots) do
        local item = self.parent:GetItemInSlot(slot)

        if item and Clothes:HasType(item, "clothes") then
            self.bonus = self.bonus - 4
        end
    end

    if self.bonus == 0 then
        self.bonus = 12
    end

    self:SetStackCount(math.abs(self.bonus))
end

function modifier_nudist:GetMoodBonus()
    return self.bonus or 12
end

function modifier_nudist:OnTooltip()
    return self.bonus or 12
end

function modifier_nudist:AddCustomTransmitterData( )
    return
    {
        bonus = self.bonus,
    }
end

function modifier_nudist:HandleCustomTransmitterData( data )
    self.bonus = data.bonus
end
