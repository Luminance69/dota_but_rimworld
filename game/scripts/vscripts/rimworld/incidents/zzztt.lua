--[[
Zzztt...:
    One of your towers had a short circuit probably because fUCKing DAVE LEFT IT OUT IN THE RAIN
    Tower takes 50% damage
    Deals damage to both teams in 800 aoe
]]

return function()
    local team = RandomInt(2, 3)

    local buildings = FindUnitsInRadius(team, Vector(0, 0, 0), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

    local factor = RandomFloat(2, max(5, 2 + Incidents:GetPowerLevel()))

    local power = math.floor(10 ^ factor)

    if #buildings < 1 then return end

    for _, building in pairs(buildings) do
        if building:IsTower() and not building:IsInvulnerable() then
            if not Incidents:CheckKarma(Incidents.karmas["zzztt"]) then return end

            local damage = building:GetMaxHealth() * (0.2 + 0.12 * factor)

            local radius = 240 + factor * 140

            local units = FindUnitsInRadius(team, building:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_COURIER, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

            for _, unit in pairs(units) do
                ApplyDamage({
                    victim = unit,
                    attacker = building,
                    damage = damage * (radius - (unit:GetAbsOrigin() - building:GetAbsOrigin()):Length2D()) / radius,
                    damage_type = DAMAGE_TYPE_PURE,
                })
            end

            building:EmitSoundParams("Hero_StormSpirit.StaticRemnantExplode", 0, 4, 0)

            local particle = ParticleManager:CreateParticle("particles/econ/items/abaddon/abaddon_alliance/abaddon_aphotic_shield_alliance_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, building)
            ParticleManager:SetParticleControl(particle, 0, building:GetAbsOrigin())
	        ParticleManager:ReleaseParticleIndex(particle)

            SendLetterToTeam(team, {
                type = "AllyZzztt",
                targets = building:GetEntityIndex(),
                special = {
                    main = {
                        power = tostring(power),
                    }
                }
            })

            SendLetterToTeam(team == 2 and 3 or 2, {
                type = "EnemyZzztt",
                targets = building:GetEntityIndex(),
                special = {
                    main = {
                        power = tostring(power),
                    }
                }
            })

            break
        end
    end
end
