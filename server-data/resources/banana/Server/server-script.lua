System:SetDebugLevel( System.DEBUG_LEVEL.DEBUG )
System:SetGlobalOutput( System.DEBUG_OUTPUT.SERVER_CONSOLE )

local function getPlayerId(mySource)
	-- TODO: make a function to retrieve always the license from the user
	return GetPlayerIdentifier(mySource)
end

local function getUserFromDB(name, setKickReason)
	local mySource = source
	System:Debug('PLAYER CONNECTED!!')

	-- get the first user id
	local userId = getPlayerId(mySource)
	System:Info('[playerConnecting] '..name..' ['..userId..']')
	
	-- get user from DB
	local user = MySQL.Sync.fetchAll('SELECT * FROM User WHERE uniqueId=@id', {['@id'] = userId})
	if #user > 0 then
		System:Info('[playerConnecting] Found user')
		if user[1].banExpiresAt and user[1].banExpiresAt > (os.time()*1000) then
			System:Error('THIS USER IS BANNED!!! KICK HIM!!!') -- I can't kick players :c
		end
	else
		MySQL.Async.execute('INSERT INTO User (uniqueId) VALUES(@id)', {['@id'] =userId })
	end
end

local function getCharactersFromDB( )
	local mySource = source
	local userId = getPlayerId(mySource)
	System:Debug('[getCharactersFromDB] Getting charactes for user ['..userId..'] from DB')
	MySQL.Async.fetchAll('SELECT * FROM PlayerCharacter WHERE userId=@id', {['@id'] = userId}, function(rowsSelected)
		System:Debug('[getCharactersFromDB] Triggering event "setAvailableChars" to client ['..tostring(mySource)..'] result: '..tostring(#rowsSelected))
		TriggerClientEvent('setAvailableChars',mySource,rowsSelected)
	end)
end


-- START SERVER
RegisterServerEvent('getCharactersFromDB')
AddEventHandler('playerConnecting', getUserFromDB)
AddEventHandler('getCharactersFromDB', getCharactersFromDB)