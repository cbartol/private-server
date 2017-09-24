local playerData = {
	currentCharacter = {},
	availableCharacters = {}
}

-- ##################
--    Aux methods
-- ##################

local function splitString (inputstr, pattern)
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..pattern.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end


RegisterNetEvent('setAvailableChars')
AddEventHandler('setAvailableChars', function(charactersList) 
	System:Debug('[setAvailableChars] '..tostring(#charactersList))
	if charactersList then
		playerData.availableCharacters = charactersList
		if #charactersList > 0 then
			playerData.currentCharacter = charactersList[1]
		end
	end
end)

AddEventHandler('playerSpawned', function (spawn)
	System:Debug('playerSpawned')
	local playerCharacterDB = playerData.currentCharacter
	if DoesEntityExist(GetPlayerPed(-1)) and playerCharacterDB ~= nil then
		local model = GetHashKey(playerCharacterDB.charModel)
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end
		SetPlayerModel(PlayerId(), model)
		SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 1)
		SetModelAsNoLongerNeeded(model)
		local ped = GetPlayerPed(-1)
		local clothes = {}
		table.insert(clothes, splitString(playerCharacterDB.variationFace, ","))
		table.insert(clothes, splitString(playerCharacterDB.variationHead, ","))
		table.insert(clothes, splitString(playerCharacterDB.variationHair, ","))
		table.insert(clothes, splitString(playerCharacterDB.variationTorso, ","))
		table.insert(clothes, splitString(playerCharacterDB.variationLegs, ","))
		table.insert(clothes, splitString(playerCharacterDB.variationHands, ","))
		table.insert(clothes, splitString(playerCharacterDB.variationFeet, ","))
		table.insert(clothes, splitString(playerCharacterDB.variationEyes, ","))
		table.insert(clothes, splitString(playerCharacterDB.variationAccessories, ","))
		table.insert(clothes, splitString(playerCharacterDB.variationTasks, ","))
		table.insert(clothes, splitString(playerCharacterDB.variationTextures, ","))
		table.insert(clothes, splitString(playerCharacterDB.variationTorso2, ","))

		for _,v in ipairs(clothes) do
			System:Debug('[SetPedComponentVariation]'..tostring(v[1])..'_'..tostring(v[2])..'_'..tostring(v[3]))
			SetPedComponentVariation(ped, tonumber(v[1]), tonumber(v[2]), tonumber(v[3]), 0)
		end
	end
end)