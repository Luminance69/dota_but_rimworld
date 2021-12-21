-- This modifier acts purely as a display for the player to tell them what their mood is. Panorama is hard ok :/

modifier_mood = modifier_mood or class({})

function modifier_mood:AllowIllusionDuplicate() return false end
function modifier_mood:HeroEffectPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_mood:IsHidden() return false end
function modifier_mood:IsPermanent() return true end
function modifier_mood:IsPurgable() return false end

function modifier_mood:GetTexture() return "mental_breaks/mood" end

function modifier_mood:OnCreated()
    self:SetHasCustomTransmitterData(true)
    if IsClient() then return end

    self:StartIntervalThink(1)
end

function modifier_mood:OnIntervalThink()
    self.mood = math.floor(self:GetParent():GetMood() + 0.5)
    self.mood_target = math.floor(self:GetParent():GetMoodTarget() + 0.5)
    self:SetStackCount(self.mood)
end

function modifier_mood:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
    }
end

function modifier_mood:OnTooltip()
    return self.mood
end

function modifier_mood:OnTooltip2()
    return self.mood_target
end

function modifier_mood:AddCustomTransmitterData( )
    return
    {
        mood = self.mood,
        mood_target = self.mood_target,
    }
end

function modifier_mood:HandleCustomTransmitterData( data )
    self.mood = data.mood
    self.mood_target = data.mood_target
end
