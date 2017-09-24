
System:SetDebugLevel(System.DEBUG_LEVEL.DEBUG)
System:SetGlobalOutput(System.DEBUG_OUTPUT.CLIENT_CONSOLE)

local options = nil

local firstSpawn = true

RegisterNetEvent('selectCharacterMenu')
AddEventHandler('selectCharacterMenu', function(characterOptions)

	options=characterOptions
	
end)


AddEventHandler('playerSpawned', function(spawn)



	Citizen.CreateThread(function()
		local cam = nil



		local newPed = nil

		
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

		SetCamActive(cam,  true)
		
		SetCamCoord(cam, 153.02, -1001.93, -98.299)

		
		RenderScriptCams(true,  false,  0,  true,  true)

		--create ped
		
		RequestModel(GetHashKey('mp_m_freemode_01'))
	    while not HasModelLoaded(GetHashKey('mp_m_freemode_01')) do
	      Wait(0)
	    end
					
		RequestModel(GetHashKey('mp_f_freemode_01'))
	    while not HasModelLoaded(GetHashKey('mp_f_freemode_01')) do
	      Wait(0)
	    end	
		

		

		newPed = CreatePed(2, 'mp_m_freemode_01', 152.217,-1000.68,-98.99999,232.59, false, false)

		
		
		
		
		PointCamAtEntity(cam, newPed, 0, 0, 0, true)
		

		SetEntityVisible(newPed, false, 0)

		SetEntityInvincible(newPed, true)

		SetEntityInvincible(GetPlayerPed(-1), true)


		while true do




			

			TaskPause(newPed, 1)

			TaskPause(GetPlayerPed(-1), 1)
			
			Citizen.Wait(0)
		end	
	end)
end)






