return function(keys)
    local killed = EntIndexToHScript(keys.entindex_killed)

    if not killed or killed:IsNull() then return end

    if killed:IsHero() then
        Incidents:CheckKarma(Incidents.karmas["death_hero"])

        for _, hero in pairs(Incidents.heroes) do
            if hero == killed then
                local team = killed:GetTeamNumber()
            
                local type = team == EntIndexToHScript(keys.entindex_attacker):GetTeamNumber() and "DeathDeny" or "Death"
            
                SendLetterToTeam(team, {
                    type = type,
                    targets = keys.entindex_killed,
                })
            end
        end
    elseif killed:IsBuilding() then
        Incidents:CheckKarma(Incidents.karmas["death_building"])

        Incidents.buildings_destroyed = Incidents.buildings_destroyed + killed:GetBuildingValue()
    elseif killed:GetUnitName() == "npc_dota_roshan" then
        Incidents:CheckKarma(Incidents.karmas["death_roshan"])

        Incidents.rosh_kills = Incidents.rosh_kills + 1
    end
end