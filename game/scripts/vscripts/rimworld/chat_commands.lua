ChatCommands = ChatCommands or class({})

function ChatCommands:Init()
    print("[Rimworld] ChatCommands Loaded!")
	ListenToGameEvent(
        "player_chat",
        function(event)
		    ChatCommands:OnPlayerChat(event)
	    end,
        nil
    )
end

function ChatCommands:OnPlayerChat(event)
	if not event.userid then return end

	event.player = PlayerInstanceFromIndex( event.userid )
	if not event.player then return end

	event.hero = event.player:GetAssignedHero()
	if not event.hero then return end

	event.player_id = event.hero:GetPlayerID()

    if not (tostring(PlayerResource:GetSteamID(event.player_id)) == "76561198188258659" or IsInToolsMode() or IsCheatMode()) then return end

	local command_source = string.lower(event.text)

	if string.sub(command_source, 0, 1) ~= "-" then return end
	-- removing `-`
	command_source = string.sub(command_source, 2, -1)

	local args = {}

    for token in string.gmatch(command_source, "[^%s]+") do
        table.insert(args, token)
    end

	local command_name = table.remove(args, 1)

    if ChatCommands[command_name] then
        ChatCommands[command_name](args, event.hero)
    end
end

-- Usage:
-- -timescale <number: scale>
-- Sets the server timescale to given value
ChatCommands.timescale = function(args, ...)
    local var = tonumber(args[1])

    if var < 0.1 then var = 0.1 end

    Convars:SetFloat("host_timescale", var)

    print("Set server timescale to", var)
end

-- Usage:
-- -bodypart <string: part>
-- Adds the given body part to your hero
ChatCommands.bodypart = function(args, hero, ...)
    if IsClient() then return end

    local slot = args[1]
    local part = args[2]
    
    if BodyParts:AddBodyPart(hero, slot, part) then
        print("Added " .. part .. " to " .. hero:GetUnitName())
    else
        print("Failed to add part, hero does not have enough slots")
    end
end

-- Usage:
-- -trait <string: trait>
-- Adds the given trait to your hero
-- Please note this has no sanitisation, and will probably break if given an invalid trait.
ChatCommands.trait = function(args, hero, ...)
    if IsClient() then return end

    local trait = args[1]

    hero:AddNewModifier(hero, nil, "modifier_" .. trait, nil)

    print("Added " .. trait .. " to " .. hero:GetUnitName())
end

-- Usage:
-- -mood <number: mood>
-- Sets your mood to the given value
ChatCommands.mood = function(args, hero, ...)
    if IsClient() then return end

    local mood = args[1]

    hero.mood = tonumber(mood)
    
    print("Set " .. hero:GetUnitName() .. "\'s mood to: " .. mood)
end