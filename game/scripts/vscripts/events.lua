ListenToGameEvent("player_chat", function(keys)
    -- Panorama debug tools
    CustomGameEventManager:Send_ServerToAllClients("player_chat", keys)
end, nil)

-- Update the targets of a problem alarm
-- keys: {type, targets, major, increment} **{increment: false} will decrement**
--       [string, EntityIndex | EntityIndex[], bool, bool]
function UpdateProblemAlarm(player, keys)
    CustomGameEventManager:Send_ServerToTeam(player, "update_problem_alarm", keys)
end

function UpdateProblemAlarmTeam(team, keys)
    CustomGameEventManager:Send_ServerToTeam(team, "update_problem_alarm", keys)
end

function UpdateProblemAlarmAll(keys)
    CustomGameEventManager:Send_ServerToAllClients("update_problem_alarm", keys)
end

-- Send a new incident letter to the given player
-- keys: {name, description, severity, sounds, targets}
--       [string, string, Severity, string | string[], EntityIndex | EntityIndex[]]
function SendIncidentLetter(player, keys)
    CustomGameEventManager:Send_ServerToPlayer(player, "send_incident_letter", keys)
end

function SendIncidentLetterTeam(team, keys)
    CustomGameEventManager:Send_ServerToTeam(team, "send_incident_letter", keys)
end

function SendIncidentLetterAll(keys)
    CustomGameEventManager:Send_ServerToAllClients("send_incident_letter", keys)
end

Severity = {
    White = "#ffffff",
    Blue = "#79afdb",
    Yellow = "#ccc47f",
    Red = "#ca7471",
}