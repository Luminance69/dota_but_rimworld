return function(keys)
    print("Running incident <Death>")

    local killed = EntIndexToHScript(keys.entindex_killed)

    if not killed or killed:IsNull() or not killed:IsHero() then return end

    local player_id = killed:GetPlayerOwnerID()

    if player_id == -1 then return end

    if killed ~= PlayerResource:GetSelectedHeroEntity(player_id) then return end

    local team = killed:GetTeamNumber()

    local type = team == EntIndexToHScript(keys.entindex_attacker):GetTeamNumber() and "DeathDeny" or "Death"

    SendLetterToTeam(team, {
        type = type,
        targets = killed,
    })
end