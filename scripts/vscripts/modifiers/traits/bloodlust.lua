-- Bloodlust:
    -- +[2/4/6/8/11/14/18] Mood for n "bloody" items equipped
    -- +[3/5/7/8/8/...] Mood for 120s after watching a hero die
    -- +[3/5/7/8/8/...] extra Mood if the parent made the kill
    -- Unique count for deaths and kills
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
    self:SetHasCustomTransmitterData(true)
    if not IsServer() then return end

    self.parent = self:GetParent()
    self.mood = 0
    self.deaths = 0
    self.death_mood = 0
    self.death_duration = 120
    self.death_scaling = {3,5,7,8}
    self.kills = 0
    self.kill_mood = 0
    self.kill_scaling = {3,5,7,8}
    self.item_mood = 0
    self.item_scaling = {2,4,6,8,11,14,18}
    self.crit_bonus = 120

    self:StartIntervalThink(1)
end

function modifier_bloodlust:OnIntervalThink()
    self.hpsum = self:GetHPSum()
    self.item_mood = self.item_scaling[self:GetItemSum()] or 0
    self.mood = self.death_mood + self.kill_mood + self.item_mood
    self:SetStackCount(self.mood)
end

-- Death in vision range Mood bonus
function modifier_bloodlust:OnDeath(keys)
    if
        not IsServer()
        or CalcDistanceBetweenEntityOBB(self.parent, keys.unit) > self.parent:GetCurrentVisionRange()
    then return end

    self.deaths = self.deaths + 1
    local death_bonus = self.death_scaling[self.deaths]
                     or self.death_scaling[#self.death_scaling]
    self.death_mood = self.death_mood + death_bonus

    if keys.attacker == self.parent then
        self.kills = self.kills + 1
        local kill_bonus = self.kill_scaling[self.kills]
                        or self.kill_scaling[#self.kill_scaling]
        self.kill_mood = self.kill_mood + kill_bonus
    end

    Timers:CreateTimer(self.death_duration, function()
        self.death_mood = self.death_mood - death_bonus
        self.kill_mood = self.kill_mood - (kill_bonus or 0)
    end)
end

--------------------------------------------------------------------------------
-- Attributes

function modifier_bloodlust:GetMoodBonus()
    return self.mood
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
-- Transmitter

function modifier_bloodlust:AddCustomTransmitterData()
    return {
        death_mood = self.death_mood,
        kill_mood = self.kill_mood,
        item_mood = self.item_mood,
    }
end

function modifier_bloodlust:HandleCustomTransmitterData(data)
    self.death_mood = data.death_mood
    self.kill_mood = data.kill_mood
    self.item_mood = data.item_mood
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
