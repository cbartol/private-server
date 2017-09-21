-- ###################################
--           AUX  FUNCTIONS
-- ###################################
local function setPlayerModelOnSpawn(spawn)
	if DoesEntityExist(GetPlayerPed(-1)) then
		local model = GetHashKey('mp_m_freemode_01')
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end
		SetPlayerModel(PlayerId(), model)
		SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 1)
		SetModelAsNoLongerNeeded(model)
		local ped = GetPlayerPed(-1)
		for i=1,12 do
			System:Debug('[SetPedComponentVariation]'..tostring(playerClothes[i].componentId)..'_'..tostring(playerClothes[i].drawableId)..'_'..tostring(playerClothes[i].textureId))
			SetPedComponentVariation(ped, playerClothes[i].componentId, playerClothes[i].drawableId, playerClothes[i].textureId, 0)
		end
	end
end

AddEventHandler('playerSpawned', setPlayerModelOnSpawn)