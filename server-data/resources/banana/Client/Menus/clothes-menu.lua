--[[{
	FACE = 46
	HEAD = 109
	HAIR = 74
	TORSO = 164
	LEGS = 91
	HANDS = 70
	FEET = 64
	EYES = 125
	ACCESSORIES = 108
	TASKS = 29
	TEXTURES = 45
	TORSO2 = 227
} 


--]]


--[[
local items = { "Item 1", "Item 2", "Item 3", "Item 4", "Item 5" }
local currentItemIndex = 1
local selectedItemIndex = 1
local checkbox = true
--]]

local currentItemIndex = {}
local selectedItemIndex = {}


-- #########################
--        MAIN MENU
-- #########################
local function MainClothesMenu()
	--[[if PedMenu.CheckBox('Checkbox', checkbox, function(checked)
					checkbox = checked
				end) then
					-- Do your stuff here
					SystemDebug('menu1' , 'aaaaaaaaaaaaaaaaaaa')-- entra aqui quando clico enter
			elseif PedMenu.ComboBox('Combobox', items, currentItemIndex, selectedItemIndex, function(currentIndex, selectedIndex)
					currentItemIndex = currentIndex
					selectedItemIndex = selectedIndex
		
					-- Do your stuff here if current index was changed (don't forget to check it)
				end) then
					SystemDebug('menu2' , 'bbbbbbbbbbbbbbbbbbbb') -- entra aqui quando clico enter
					-- Do your stuff here if current item was activated
					--]]
	
	if PedMenu.MenuButton('Face', 'clothes-FACE') then
	elseif PedMenu.MenuButton('Head', 'clothes-HEAD') then
	elseif PedMenu.MenuButton('Hair', 'clothes-HAIR') then
	elseif PedMenu.MenuButton('Torso', 'clothes-TORSO') then
	elseif PedMenu.MenuButton('Legs', 'clothes-LEGS') then
	elseif PedMenu.MenuButton('Hands', 'clothes-HANDS') then
	elseif PedMenu.MenuButton('Feet', 'clothes-FEET') then
	elseif PedMenu.MenuButton('Eyes', 'clothes-EYES') then
	elseif PedMenu.MenuButton('Accessories', 'clothes-ACCESSORIES') then
	elseif PedMenu.MenuButton('Tasks', 'clothes-TASKS') then
	elseif PedMenu.MenuButton('Textures', 'clothes-TEXTURES') then
	elseif PedMenu.MenuButton('Torso2', 'clothes-TORSO2') then
	elseif PedMenu.MenuButton('Exit', 'clothes-closeMenu') then
	end

	PedMenu.Display()
end

local function GenericVariationMenu(variation)
	local ped = GetPlayerPed(-1)
	local menuSize = GetNumberOfPedDrawableVariations(ped, variation)
	if currentItemIndex[tostring(variation)] == nil then
		currentItemIndex[tostring(variation)] = {}
		selectedItemIndex[tostring(variation)] = {}
	end
	for i=1,menuSize do
		if currentItemIndex[tostring(variation)][tostring(i)] == nil then
			currentItemIndex[tostring(variation)][tostring(i)] = 1
			selectedItemIndex[tostring(variation)][tostring(i)] = 1
		end
		local textureVariationSize = GetNumberOfPedTextureVariations(ped, variation, i-1)
		local textures = {}
		for j=1,textureVariationSize do
			--SystemDebug('xxx', j)

			if IsPedComponentVariationValid(ped, variation, i-1, j-1) then 
				textures[j] = tostring(j)
			end
		end

		if PedMenu.ComboBox(tostring(i), textures, currentItemIndex[tostring(variation)][tostring(i)], selectedItemIndex[tostring(variation)][tostring(i)], function(currentIndex, selectedIndex)
				currentItemIndex[tostring(variation)][tostring(i)] = currentIndex
				selectedItemIndex[tostring(variation)][tostring(i)] = selectedIndex
	
				-- Do your stuff here if current index was changed (don't forget to check it)
			end) then
			-- does something when selected
			--SystemDebug('variation', variation)
			--SystemDebug('drawableId', i-1)
			--SystemDebug('textureId', selectedItemIndex[tostring(variation)][tostring(i)]-1)
			SetPedComponentVariation(ped, variation, i-1, selectedItemIndex[tostring(variation)][tostring(i)]-1, 0) -- ultimo parametro vai de 0 to 3
			SystemDebug('playerClothes#1', playerClothes[variation+1])
			SystemDebug('playerClothes#1', playerClothes[variation+1].drawableId)
			SystemDebug('playerClothes#1', playerClothes[variation+1].textureId)
			playerClothes[variation+1].drawableId = i-1
			playerClothes[variation+1].textureId = selectedItemIndex[tostring(variation)][tostring(i)]-1
			SystemDebug('playerClothes#1', playerClothes[variation+1])
			SystemDebug('playerClothes#1', playerClothes[variation+1].drawableId)
			SystemDebug('playerClothes#1', playerClothes[variation+1].textureId)
		end
	end
end
--[[

TORSO -> 1
FEET  -> 1
EYES  -> 1
ACCESSORIES 1


--]]

local function SubMenuFace()
	GenericVariationMenu(PED_VARIATION.FACE)

	PedMenu.Display()
end

local function SubMenuHead()
	GenericVariationMenu(PED_VARIATION.HEAD)

	PedMenu.Display()
end

local function SubMenuHair()
	GenericVariationMenu(PED_VARIATION.HAIR)

	PedMenu.Display()
end

local function SubMenuTorso()
	GenericVariationMenu(PED_VARIATION.TORSO)

	PedMenu.Display()
end

local function SubMenuLegs()
	GenericVariationMenu(PED_VARIATION.LEGS)

	PedMenu.Display()
end

local function SubMenuHands()
	GenericVariationMenu(PED_VARIATION.HANDS)

	PedMenu.Display()
end

local function SubMenuFeet()
	GenericVariationMenu(PED_VARIATION.FEET)

	PedMenu.Display()
end

local function SubMenuEyes()
	GenericVariationMenu(PED_VARIATION.EYES)

	PedMenu.Display()
end

local function SubMenuAccessories()
	GenericVariationMenu(PED_VARIATION.ACCESSORIES)

	PedMenu.Display()
end

local function SubMenuTasks()
	GenericVariationMenu(PED_VARIATION.TASKS)

	PedMenu.Display()
end

local function SubMenuTextures()
	GenericVariationMenu(PED_VARIATION.TEXTURES)

	PedMenu.Display()
end

local function SubMenuTorso2()
	GenericVariationMenu(PED_VARIATION.TORSO2)

	PedMenu.Display()
end




-- ##########################
--        CLOSE SUBMENU
-- ##########################
local function CloseMenu()
	if PedMenu.Button('Yes') then
		PedMenu.CloseMenu()
	elseif PedMenu.MenuButton('No', 'clothes') then
	end

	PedMenu.Display()
end

function PedMenu.InitClothesMenu()
	local title = 'Super Shop'
	local mainMenu = 'clothes'

	PedMenu.CreateMenu(mainMenu, title, 'Clothing', MainClothesMenu)
	PedMenu.CreateSubMenu('clothes-FACE', mainMenu, 'Face', SubMenuFace)
	PedMenu.CreateSubMenu('clothes-HEAD', mainMenu, 'Mask', SubMenuHead)
	PedMenu.CreateSubMenu('clothes-HAIR', mainMenu, 'Hair', SubMenuHair)
	PedMenu.CreateSubMenu('clothes-TORSO', mainMenu, 'Torso', SubMenuTorso)
	PedMenu.CreateSubMenu('clothes-LEGS', mainMenu, 'Legs', SubMenuLegs)
	PedMenu.CreateSubMenu('clothes-HANDS', mainMenu, 'Bags', SubMenuHands)
	PedMenu.CreateSubMenu('clothes-FEET', mainMenu, 'Shoes', SubMenuFeet)
	PedMenu.CreateSubMenu('clothes-EYES', mainMenu, 'Eyes', SubMenuEyes)
	PedMenu.CreateSubMenu('clothes-ACCESSORIES', mainMenu, 'Shirts', SubMenuAccessories)
	PedMenu.CreateSubMenu('clothes-TASKS', mainMenu, 'Vests', SubMenuTasks)
	PedMenu.CreateSubMenu('clothes-TEXTURES', mainMenu, 'Textures', SubMenuTextures)
	PedMenu.CreateSubMenu('clothes-TORSO2', mainMenu, 'Jackets', SubMenuTorso2)
	PedMenu.CreateSubMenu('clothes-closeMenu', mainMenu, 'Are you sure?', CloseMenu)
end
