-- These modifiers act purely as a display for the player to tell them what their mood & break risk is. Panorama is hard ok :/

modifier_mood = modifier_mood or class({})

function modifier_mood:AllowIllusionDuplicate() return false end
function modifier_mood:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_mood:IsHidden() return false end
function modifier_mood:IsDebuff() return self.below_threshold == 1 or false end -- For some reason transmitters just change the type to number
function modifier_mood:IsPermanent() return true end
function modifier_mood:IsPurgable() return false end

function modifier_mood:GetTexture() return "mental_breaks/mood_" .. tostring(self.risk) end -- risk 0,1,2,3 for none, minor, major, extreme (blue, orange, green, pink)

function modifier_mood:OnCreated()
    self:SetHasCustomTransmitterData(true)

    self.risk = 0

    if IsClient() then return end

    self.risk_names = {
        "modifier_break_risk_minor",
        "modifier_break_risk_major",
        "modifier_break_risk_extreme",
    }

    self:StartIntervalThink(1)
end

function modifier_mood:OnIntervalThink()
    local parent = self:GetParent()

    self.mood = math.floor(parent:GetMood() + 0.5)
    self.mood_target = math.floor(parent:GetMoodTarget() + 0.5)

    self:SetStackCount(self.mood)

    local thresholds = parent:GetMentalBreakThresholds()

    if self.mood < thresholds[1] then
        self.below_threshold = true

        -- yo this kinda jank ngl
        for i = 3, 1, -1 do
            if self.mood < thresholds[i] then
                if parent:HasModifier(self.risk_names[i]) then
                    break
                else
                    if i ~= 1 then parent:RemoveModifierByName(self.risk_names[1]) end
                    if i ~= 2 then parent:RemoveModifierByName(self.risk_names[2]) end
                    if i ~= 3 then parent:RemoveModifierByName(self.risk_names[3]) end

                    parent:AddNewModifierSpecial(parent, nil, self.risk_names[i], nil)

                    self.risk = i

                    break
                end
            end
        end
    else
        self.risk = 0

        parent:RemoveModifierByName(self.risk_names[1])
        parent:RemoveModifierByName(self.risk_names[2])
        parent:RemoveModifierByName(self.risk_names[3])

        self.below_threshold = false
    end
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
        below_threshold = self.below_threshold,
        risk = self.risk,
    }
end

function modifier_mood:HandleCustomTransmitterData( data )
    self.mood = data.mood
    self.mood_target = data.mood_target
    self.below_threshold = data.below_threshold
    self.risk = data.risk
end



modifier_break_risk = modifier_break_risk or class({})

function modifier_break_risk:AllowIllusionDuplicate() return false end
function modifier_break_risk:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_break_risk:IsHidden() return false end
function modifier_break_risk:IsDebuff() return true end
function modifier_break_risk:IsPermanent() return true end
function modifier_break_risk:IsPurgable() return false end

function modifier_break_risk:OnCreated()
    self:SetHasCustomTransmitterData(true)
    if IsClient() then return end

    self.thresholds = self:GetParent():GetMentalBreakThresholds()

    self:StartIntervalThink(1)
end

function modifier_break_risk:OnIntervalThink()
    self.thresholds = self:GetParent():GetMentalBreakThresholds()
end

function modifier_break_risk:AddCustomTransmitterData( )
    return
    {
        threshold1 = self.thresholds and self.thresholds[1],
        threshold2 = self.thresholds and self.thresholds[2],
        threshold3 = self.thresholds and self.thresholds[3],
    }
end

function modifier_break_risk:HandleCustomTransmitterData( data )
    self.threshold1 = data.threshold1
    self.threshold2 = data.threshold2
    self.threshold3 = data.threshold3
end



modifier_break_risk_minor = class(modifier_break_risk)

function modifier_break_risk_minor:GetTexture() return "mental_breaks/risk_minor" end

function modifier_break_risk_minor:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
    }
end

function modifier_break_risk_minor:OnTooltip()
    return self.threshold1
end

function modifier_break_risk_minor:OnTooltip2()
    return self.threshold2
end



modifier_break_risk_major = class(modifier_break_risk)

function modifier_break_risk_major:GetTexture() return "mental_breaks/risk_major" end

function modifier_break_risk_major:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
    }
end

function modifier_break_risk_major:OnTooltip()
    return self.threshold2
end

function modifier_break_risk_major:OnTooltip2()
    return self.threshold3
end



modifier_break_risk_extreme = class(modifier_break_risk)

function modifier_break_risk_extreme:GetTexture() return "mental_breaks/risk_extreme" end

function modifier_break_risk_extreme:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_break_risk_extreme:OnTooltip()
    return self.threshold3
end