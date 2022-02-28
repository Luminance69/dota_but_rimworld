return function()
    local gold = math.floor(150 + GameRules:GetGameTime() / RandomInt(3, 5))

    local team = RandomInt(2, 3)

    local names = LoadKeyValues("scripts/kv/names.txt")
    
    local patron = names[tostring(RandomInt(1, 59))]

    print(patron)

    local targets = {}

    for _, hero in pairs(Incidents.heroes) do
        if hero:GetTeamNumber() == team then
            hero:ModifyGoldFiltered(gold, true, DOTA_ModifyGold_GameTick)
        
            local player = hero:GetPlayerOwner()
            if player then SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, hero, gold, player) end

            table.insert(targets, hero:GetEntityIndex())
        end
    end

    SendLetterToTeam(team, {
        type = "Gift",
        targets = targets,
        special = {
            main = {
                gold = tostring(gold),
                patron = patron,
            }
        }
    })
end