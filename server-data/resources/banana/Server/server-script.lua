System:SetDebugLevel( System.DEBUG_LEVEL.DEBUG )
System:SetGlobalOutput( System.DEBUG_OUTPUT.SERVER_CONSOLE )

local function getUserFromDB(name, setKickReason)
	System:Debug('PLAYER CONNECTED!!')

	-- get the first user id
	local userId = GetPlayerIdentifier(source)
	System:Info('[playerConnecting] '..name..' ['..userId..']')
	
	-- get user from DB
	local user = MySQL.Sync.fetchAll('SELECT * FROM User WHERE uniqueId=@id', {['@id'] = userId})
	if #user > 0 then
		System:Info('[playerConnecting] Found user')
		if user[1].banExpiresAt and user[1].banExpiresAt > (os.time()*1000) then
			System:Error('THIS USER IS BANNED!!! KICK HIM!!!') -- I can't kick players :c
		end
	else
		MySQL.Sync.execute('INSERT INTO User (uniqueId) VALUES(@id)', {['@id'] =userId })
	end
end




-- START SERVER
AddEventHandler('playerConnecting', getUserFromDB)