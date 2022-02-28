return function(keys)
    local killed = EntIndexToHScript(keys.entindex_killed)

    if not killed or killed:IsNull() or not killed:IsHero() then return end

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
end