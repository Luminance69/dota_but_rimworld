ListenToGameEvent("player_chat", function(keys)
    -- Panorama debug tools
    CustomGameEventManager:Send_ServerToAllClients("player_chat", keys)
end, nil)

-- Update the targets of a problem alarm
-- keys: {type, targets, major, increment} **{increment: false} will decrement**
--       [string, EntityIndex|EntityIndex[], bool, bool]
function UpdateAlarmForPlayer(player, keys)
    CustomGameEventManager:Send_ServerToTeam(player, "update_problem_alarm", keys)
end

function UpdateAlarmForTeam(team, keys)
    CustomGameEventManager:Send_ServerToTeam(team, "update_problem_alarm", keys)
end

function UpdateAlarmForAll(keys)
    CustomGameEventManager:Send_ServerToAllClients("update_problem_alarm", keys)
end

-- Send a new incident letter to the given player
-- keys: {type, targets, special?}
--       [string, EntityIndex|EntityIndex[], {main?:{key: string}, repeat?:{key: string}}]
function SendLetterToPlayer(player, keys)
    CustomGameEventManager:Send_ServerToPlayer(player, "send_incident_letter", keys)
end

function SendLetterToTeam(team, keys)
    CustomGameEventManager:Send_ServerToTeam(team, "send_incident_letter", keys)
end

function SendLetterToAll(keys)
    CustomGameEventManager:Send_ServerToAllClients("send_incident_letter", keys)
end
