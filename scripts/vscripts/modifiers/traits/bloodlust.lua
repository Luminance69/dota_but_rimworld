-- Bloodlust:
    -- +[2/4/6/8/11/14/18] Mood for n "bloody" items equipped
    -- +[3/5/7/8/8/...] Mood for 120s after watching a hero die
    -- +[3/5/7/8/8/...] extra Mood if the parent made the kill
    -- Unique count for deaths and kills
-- hpsum = sum of lost hp within vision radius
    -- (hpsum/50)x turn rate
    -- hpsum/(hpsum+7500) chance for 1.2x crit

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
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
    }
    return funcs
end


function modifier_bloodlust:OnCreated(keys)
    self:SetHasCustomTransmitterData(true)
    if not IsServer() then return end

    self.parent = self:GetParent()
    self.mood = 0
    self.deaths = 0
    self.death_mood = 0
    self.death_duration = 30
    self.death_scaling = {1,1,2,2,3}
    self.kills = 0
    self.kill_mood = 0
    self.kill_scaling = {1,2,3,4,5}
    self.item_mood = 0
    self.item_scaling = {2,4,6,8,11,14,18}
    self.crit_bonus = 110

    self:StartIntervalThink(1)
end

function modifier_bloodlust:OnIntervalThink()
    self.hpsum = self:GetHPSum()
    self.crit_chance = self.hpsum / (self.hpsum+7500)
    self.turn_rate = self.hpsum / 50
    self.item_mood = self.item_scaling[self:GetItemSum()] or 0
    self.mood = self.death_mood + self.kill_mood + self.item_mood
    self:SetStackCount(self.mood)
end

-- Death in vision range Mood bonus
function modifier_bloodlust:OnDeath(keys)
    if
        not IsServer()
        or keys.unit == self.parent
        or not keys.unit:IsRealHero() or keys.unit:IsTempestDouble()
        or keys.unit:WillReincarnate()
        or not self.parent:CanEntityBeSeenByMyTeam(keys.unit)
        or CalcDistanceBetweenEntityOBB(self.parent, keys.unit) > self.parent:GetCurrentVisionRange()
    then return end

    self.deaths = self.deaths + 1
    local death_bonus = self.death_scaling[self.deaths]
                     or self.death_scaling[#self.death_scaling]
    self.death_mood = self.death_mood + death_bonus

    local kill_bonus = 0
    if keys.attacker == self.parent then
        self.kills = self.kills + 1
        kill_bonus = self.kill_scaling[self.kills]
                        or self.kill_scaling[#self.kill_scaling]
        self.kill_mood = self.kill_mood + kill_bonus
    end

    Timers:CreateTimer(self.death_duration, function()
        self.death_mood = self.death_mood - death_bonus
        self.kill_mood = self.kill_mood - kill_bonus
    end)
end

--------------------------------------------------------------------------------
-- Attributes

function modifier_bloodlust:GetMoodBonus()
    return self.mood
end

function modifier_bloodlust:GetModifierTurnRate_Percentage()
    if self.hpsum then
        return self.turn_rate
    end
end

function modifier_bloodlust:GetModifierPreAttack_CriticalStrike(keys)
    if IsServer() and self.hpsum then
        if RandomFloat(0, 1) < self.crit_chance then
            return self.crit_bonus
        end
    end
end

--------------------------------------------------------------------------------
-- Transmitter

function modifier_bloodlust:OnTooltip()
    return self.turn_rate
end

function modifier_bloodlust:OnTooltip2()
    return self.crit_chance
end

function modifier_bloodlust:AddCustomTransmitterData()
    return {
        turn_rate = self.turn_rate,
        crit_chance = self.crit_chance,
    }
end

function modifier_bloodlust:HandleCustomTransmitterData(data)
    self.turn_rate = data.turn_rate
    self.crit_chance = data.crit_chance
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
        sum = sum + (Clothes:HasType(item, "bloody") and 1 or 0)
    end

    return sum
end
