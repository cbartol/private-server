local playerData = {
	currentCharacter = {},
	availableCharacters = {}
}

--    wtf is this???
local overLays = {}
for i=1,12 do
	overLays[i]={overlayType=0}
end
overLays[2].overlayType=1
overLays[3].overlayType=1
overLays[6].overlayType=2
overLays[9].overlayType=2
overLays[11].overlayType=1
-----------------------------


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

local function parseHeadProperties(pedHeadBlendData)
	local tick = 0.0
	if tonumber(pedHeadBlendData[3])~=0 then
		tick = (tonumber(pedHeadBlendData[3]))/100
	end
	local tickSkin = 0.0
	if tonumber(pedHeadBlendData[4])~=0 then
		tickSkin = (tonumber(pedHeadBlendData[4]))/100
	end
	local face1 = 0
	local face2 = 0
	if tonumber(pedHeadBlendData[1])==23 then
		face1=45
	else
		face1=tonumber(pedHeadBlendData[1])+19
	end
--[[ ?????????
	if (father.index>21) then
		face2=20+father.index
	else
		face2=father.index-1
	end
--]]
	face2=tonumber(pedHeadBlendData[4])
	return face1,face2,tick,tickSkin
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
		local modelIsMale = playerCharacterDB.charModel == 'mp_m_freemode_01'
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end
		System:Debug('is male? '..tostring(modelIsMale))
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

		local pedHeadBlendData = splitString(playerCharacterDB.pedHeadBlendData, ",")

		local pedHairColor = splitString(playerCharacterDB.pedHairColor, ",")
		
		local pedHeadOverlay = splitString(playerCharacterDB.pedHeadOverlay, ";")
		local pedHeadOverlayColor = splitString(playerCharacterDB.pedHeadOverlayColor, ";")

		-- SET CHARACTER FEATURES
		for _,v in ipairs(clothes) do
			System:Debug('[SetPedComponentVariation]'..tostring(v[1])..'_'..tostring(v[2])..'_'..tostring(v[3]))
			SetPedComponentVariation(ped, tonumber(v[1]), tonumber(v[2]), tonumber(v[3]), 0)
		end
		local face1,face2,tick,tickSkin = parseHeadProperties(pedHeadBlendData)
		System:Debug('[SetPedHeadBlendData] ['..tostring(face1)..'] ['..tostring(face2)..'] ['..tostring(tick)..'] ['..tostring(tickSkin)..']')
		SetPedHeadBlendData(GetPlayerPed(-1),face1,face2,0,face1,face2,0,tick,tickSkin,0.0,false)
		System:Debug('[SetPedEyeColor] ['..playerCharacterDB.pedEyeColor..']')
		SetPedEyeColor(GetPlayerPed(-1), tonumber(playerCharacterDB.pedEyeColor)-1)
		for i,v in ipairs(splitString(playerCharacterDB.pedFaceFeature, ",")) do
			local scale = tonumber(v) - 50						
			scale = scale/50
			System:Debug('[SetPedFaceFeature] ['..tostring(i)..'] ['..tostring(scale)..']')
			SetPedFaceFeature(GetPlayerPed(-1),i,scale)
		end
		System:Debug('[SetPedHairColor] ['..pedHairColor[1]..'] ['..pedHairColor[2]..']')
		SetPedHairColor(GetPlayerPed(-1),tonumber(pedHairColor[1]),tonumber(pedHairColor[2]))

		for i=1,12 do
			local headOverlay = splitString(pedHeadOverlay[i], ",")
			local headOverlayColor = splitString(pedHeadOverlayColor[i], ",")
			if  (not (((i==2)or(i==11)) and (not modelIsMale))) then
				local scale = tonumber(headOverlay[2])
				scale = scale/100

				System:Debug('[SetPedHeadOverlay] ['..headOverlay[1]..'] ['..tostring(scale)..']')
				SetPedHeadOverlay(GetPlayerPed(-1),i-1,tonumber(headOverlay[1])-2,scale)
				if (overLays[i].overlayType~=0) then
					System:Debug('[SetPedHeadOverlayColor] ['..tostring(overLays[i].overlayType)..'] ['..headOverlayColor[1]..'] ['..headOverlayColor[2]..']')
					SetPedHeadOverlayColor(GetPlayerPed(-1),i-1,overLays[i].overlayType,tonumber(headOverlayColor[1])-1,tonumber(headOverlayColor[2])-1)
				end
			end
		end
	end
end)