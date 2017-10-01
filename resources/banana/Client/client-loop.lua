--[[
playerClothes = {
	{
		componentId = PED_VARIATION.FACE, -- 0
		drawableId = 0,
		textureId = 0
	},
	{
		componentId = PED_VARIATION.HEAD, -- 1
		drawableId = 0,
		textureId = 0
	},
	{
		componentId = PED_VARIATION.HAIR, -- 2
		drawableId = 0,
		textureId = 0
	},
	{
		componentId = PED_VARIATION.TORSO, -- 3
		drawableId = 15,
		textureId = 0
	},
	{
		componentId = PED_VARIATION.LEGS, -- 4
		drawableId = 21,
		textureId = 0
	},
	{
		componentId = PED_VARIATION.HANDS, -- 5
		drawableId = 0,
		textureId = 0
	},
	{
		componentId = PED_VARIATION.FEET, -- 6
		drawableId = 34,
		textureId = 0
	},
	{
		componentId = PED_VARIATION.EYES, -- 7
		drawableId = 0,
		textureId = 0
	},
	{
		componentId = PED_VARIATION.ACCESSORIES, -- 8
		drawableId = 15,
		textureId = 0
	},
	{
		componentId = PED_VARIATION.TASKS, -- 9
		drawableId = 0,
		textureId = 0
	},
	{
		componentId = PED_VARIATION.TEXTURES, -- 10
		drawableId = 0,
		textureId = 0
	},
	{
		componentId = PED_VARIATION.TORSO2, -- 11
		drawableId = 15,
		textureId = 0
	}
}
--]]


Citizen.CreateThread(
	function()

		-- ###################################
		--           INIT  SECTION
		-- ###################################
		System:SetDebugLevel(System.DEBUG_LEVEL.DEBUG)
		System:SetGlobalOutput(System.DEBUG_OUTPUT.CLIENT_CONSOLE)

		TriggerServerEvent('getCharactersFromDB')

		PedMenu.InitClothesMenu()



		-- ###################################
		--             DEBUG
		-- ###################################

		-- ###################################
		--              MAIN  LOOP
		-- ###################################
		while true do
			if PedMenu.IsAnyMenuOpened() then
				PedMenu.DisplayOpenedMenu()
			elseif IsControlJustReleased(0, INPUT.INTERACTION_MENU) then --M by default
				PedMenu.OpenMenu('clothes')
			elseif IsControlJustReleased(0, INPUT.ATTACK) then 
				local ped = GetPlayerPed(-1)
				SetEntityHealth(ped, 1)
				--SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
			end

			Citizen.Wait(0)
		end
	end
)