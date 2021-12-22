-- Bloodlust:
    -- +[3,5,7,8,9,10,11] Mood for n "bloody" items equipped
    -- +8 Mood for 120s after watching a hero die
    -- +13 Mood for 120s after killing an enemy hero
-- hpsum = sum of lost hp within vision radius
    -- (hpsum/50)x turn rate
    -- (hpsum/100)% chance for 1.2x crit

require("modifiers/traits/base_trait")
require("rimworld/clothes")

modifier_bloodlust = class(base_trait)

--------------------------------------------------------------------------------
--== Main Modifier ==--

function modifier_bloodlust:IsDebuff() return false end

function modifier_bloodlust:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
    }
    return funcs
end


function modifier_bloodlust:OnCreated(keys)
    if not IsServer() then return end

    self.parent = self:GetParent()
    self.kill_mood = 0
    self.kill_duration = 120
    self.item_mood = 0
    self.item_scaling = {3,5,7,8,9,10,11}
    self.crit_bonus = 120

    self:StartIntervalThink(1)
end

function modifier_bloodlust:OnIntervalThink()
    self.hpsum = self:GetHPSum()
    self.item_mood = self.item_scaling[self:GetItemSum()] or 0
end

-- Death in vision range Mood bonus
function modifier_bloodlust:OnDeath(keys)
    if
        not IsServer()
        or CalcDistanceBetweenEntityOBB(self.parent, keys.unit) > self.parent:GetCurrentVisionRange()
    then return end

    local bonus = 8
    if keys.attacker == self.parent then bonus = 13 end
    self.kill_mood = self.kill_mood + bonus

    Timers:CreateTimer(self.kill_duration, function()
        self.kill_mood = self.kill_mood - bonus
    end)
end

--------------------------------------------------------------------------------
-- Attributes

function modifier_bloodlust:GetMoodBonus()
    return self.kill_mood + self.item_mood
end

function modifier_bloodlust:GetModifierTurnRate_Percentage()
    if self.hpsum then
        return self.hpsum / 50
    end
end

function modifier_bloodlust:GetModifierPreAttack_CriticalStrike(keys)
    if IsServer() and self.hpsum then
        if math.random() < self.hpsum/10000 then
            return self.crit_bonus
        end
    end
end

--------------------------------------------------------------------------------
-- Helpers

-- Get sum of hp lost within parent vision
function modifier_bloodlust:GetHPSum()
    local sum = 0
    local heroes = FindUnitsInRadius(
                        self.parent:GetTeam(),
                        self.parent:GetOrigin(),
                        nil,
                        self.parent:GetCurrentVisionRange(),
                        DOTA_UNIT_TARGET_TEAM_BOTH,
                        DOTA_UNIT_TARGET_HERO,
                        DOTA_UNIT_TARGET_FLAG_NONE,
                        FIND_ANY_ORDER,
                        false
    )

    for _, hero in pairs(heroes) do
        sum = sum + hero:GetHealthDeficit()
    end
    return sum
end

-- Get total "bloody" items equipped
function modifier_bloodlust:GetItemSum()
    local sum = 0

    for _, slot in pairs({0,1,2,3,4,5,16}) do
        item = self.parent:GetItemInSlot(slot)

        if item then
            local types = Clothes:GetItemTypes(item:GetAbilityName())

            if types and types["bloody"] then
                sum = sum + 1
            end
        end
    end
    return sum
end
