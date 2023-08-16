LinkLuaModifier("modifier_dummy_unit", "modifiers/incidents/dummy_unit", LUA_MODIFIER_MOTION_NONE)

return function()
    if not Incidents:CheckKarma(Incidents.karmas["dry_thunderstorm"]) then return end

    local duration = 20 + max(1, Incidents:GetPowerLevel()) * RandomInt(0, 20)

    local position = Vector(RandomInt(-7000, 7000), RandomInt(-7000, 7000), 0)

    local delay_range = {0.4, 3.2}

    local end_time = GameRules:GetGameTime() + duration

    local dummy_unit = CreateUnitByName("npc_dota_neutral_kobold", Vector(position.x, position.y, -16384), false, nil, nil, DOTA_TEAM_NEUTRALS)

    dummy_unit:AddNewModifier(dummy_unit, nil, "modifier_dummy_unit", nil)

    SendLetterToAll({
        type = "DryThunderstorm",
        targets = dummy_unit:GetEntityIndex(),
    })

    local buildings = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, Vector(0, 0, 0), nil, -1, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
    local fountains = {}

    for _, building in pairs(buildings) do
        if building:GetUnitName() == "dota_fountain" then
            fountains[building:GetTeamNumber() == 2 and 3 or 2] = building
        end
    end

    local DoLightningOnPosition = function(target_point)
        -- Sound
        EmitSoundOnLocationWithCaster(target_point, "Hero_Zuus.LightningBolt", dummy_unit)

        -- Vision
        for team = 2, 3 do
            AddFOWViewer(team, target_point, 400, 2, false)
        end

        -- Particles on ground
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, nil)

        ParticleManager:SetParticleControl(particle, 0, target_point)
        ParticleManager:SetParticleControl(particle, 1, Vector(target_point.x, target_point.y, 2000))
        ParticleManager:SetParticleControl(particle, 2, target_point)

        ParticleManager:ReleaseParticleIndex(particle)

        local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, target_point, nil, RandomInt(300, 700), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

        for _, unit in pairs(units) do
            if not unit:IsMagicImmune() then
                local distance = (target_point - unit:GetAbsOrigin()):Length2D()
                -- Damage nearby units
                ApplyDamage({
                    attacker = fountains[unit:GetTeamNumber()],
                    ability = nil,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    damage = 600 - distance,
                    victim = unit
                })
            end
        end
    end

    Timers:CreateTimer(0, function()
        if end_time > GameRules:GetGameTime() then
            DoLightningOnPosition(position + RandomVector(1500))

            return RandomFloat(delay_range[1], delay_range[2])
        else
            UTIL_Remove(dummy_unit)
        end
    end)
end
