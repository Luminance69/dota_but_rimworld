-- Nudist:
-- -75% Mental Break chance if no clothing equipped
-- +25% Mental Break chance per clothing item equipped

require("modifiers/traits/base_trait")
require("rimworld/clothes")

modifier_nudist = class(base_trait)

function modifier_nudist:OnCreated()
    self.slots = {0, 1, 2, 3, 4, 5, 16}

    self:StartIntervalThink(1)
end

function modifier_nudist:IsDebuff()
    return self.bonus and self.bonus > 0
end

function modifier_nudist:OnIntervalThink()
    self.bonus = 0

    for _, slot in pairs(self.slots) do
        local item = self:GetParent():GetItemInSlot(slot)

        if Clothes:GetItemTypes(item:GetAbilityName())["clothes"] then
            self.bonus = self.bonus + 4
        end
    end

    if self.bonus == 0 then
        self.bonus = -12
    end

    self:SetStackCount(self.bonus)
end

function modifier_nudist:GetMoodBonus()
    return self.bonus or -12
end
