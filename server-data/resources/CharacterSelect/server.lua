System:SetDebugLevel(System.DEBUG_LEVEL.DEBUG)
System:SetGlobalOutput(System.DEBUG_OUTPUT.SERVER_CONSOLE)

AddEventHandler('playerConnecting', function(playerName, setKickReason)

    local mySource = source
	
	local playerID = GetPlayerIdentifier(mySource)



	
	
    
	MySQL.Async.fetchAll('SELECT COUNT(*) FROM User WHERE uniqueID="'..tostring(playerID)..'"', {}, function(rowsSelected)
	
		print("select")

		if next(rowsSelected)==nil then
		
			print("new user")
		
			MySQL.Async.execute('INSERT INTO User(uniqueID) VALUES("'..tostring(playerID)..'")', {}, function(rowsChanged)

				TriggerClientEvent('selectCharacterMenu',mySource,{})
				
			end)
		
		else
			
		print("load user")

			MySQL.Async.fetchAll('SELECT characterId,name,physicalAspect,clothes,props FROM PlayerCharacter WHERE userId="'..tostring(playerID)..'"', {}, function(rowsSelected)
			
				TriggerClientEvent('selectCharacterMenu',mySource,rowsSelected)

			end)

		end
		
	end)
	
	
	
	
end)