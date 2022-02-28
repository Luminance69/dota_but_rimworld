--[[
    Insulting Spree:
        Your hero insults allies, causing their mood to decrease
        30s duration
]]

require("modifiers/mental_breaks/base_mental_break")

modifier_insulting_spree = class(base_mental_break)

function modifier_insulting_spree:GetTexture() return "mental_breaks/minor" end

function modifier_insulting_spree:OnCreated()
    self:SetDuration(30, true)

    if IsClient() then return end

    self:StartIntervalThink(2)
end

function modifier_insulting_spree:OnIntervalThink()
    local parent = self:GetParent()

    local allies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)

    if #allies <= 1 then return end

    -- remove parent
    table.remove(allies, #allies)

    local real_allies = {}

    for _, ally in pairs(allies) do
        if PlayerResources and PlayerResources:GetSelectedHeroEntity(ally:GetPlayerID()) == ally then
            table.insert(real_allies, ally)
        end
    end

    -- This is what we call a pro gamer move
    -- Basically just weights it so that closer allied heroes are more likely to be chosen.
    local ally = real_allies[math.floor(math.sqrt(RandomInt(1, #real_allies * #real_allies)))]

    local modifier = ally:FindModifierByName("modifier_insulted")

    if not modifier then
        ally:AddNewModifier(parent, nil, "modifier_insulted", nil)
    end

    modifier:IncrementStackCount()
end



modifier_insulted = class(base_mental_break)

function modifier_insulted:GetTexture() return "mental_breaks/insulted" end

function modifier_insulted:GetMoodBonus()
    return - (2 + self:GetStackCount() * 2)
end

function modifier_insulted:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP, -- GetModifierMoveSpeedBonus_Percentage
    }
end

function modifier_insulted:OnTooltip()
    return 2 + self:GetStackCount() * 2
end