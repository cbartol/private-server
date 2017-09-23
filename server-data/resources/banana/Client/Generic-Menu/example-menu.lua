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
	
	PedMenu.MenuButton('Face', 'clothes-FACE', function () end)
	PedMenu.MenuButton('Head', 'clothes-HEAD', function () end)
	PedMenu.MenuButton('Hair', 'clothes-HAIR', function () end)
	PedMenu.MenuButton('Torso', 'clothes-TORSO', function () end)
	PedMenu.MenuButton('Legs', 'clothes-LEGS', function () end)
	PedMenu.MenuButton('Hands', 'clothes-HANDS', function () end)
	PedMenu.MenuButton('Feet', 'clothes-FEET', function () end)
	PedMenu.MenuButton('Eyes', 'clothes-EYES', function () end)
	PedMenu.MenuButton('Accessories', 'clothes-ACCESSORIES', function () end)
	PedMenu.MenuButton('Tasks', 'clothes-TASKS', function () end)
	PedMenu.MenuButton('Textures', 'clothes-TEXTURES', function () end)
	PedMenu.MenuButton('Torso2', 'clothes-TORSO2', function () end)
	PedMenu.MenuButton('Exit', 'clothes-closeMenu', function () end)

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

		PedMenu.ComboBox(tostring(i), textures, function(selectedItem)
			--[[
			currentItemIndex[tostring(variation)][tostring(i)] = currentIndex
			selectedItemIndex[tostring(variation)][tostring(i)] = selectedIndex
	
			-- Do your stuff here if current index was changed (don't forget to check it)
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

			--]]
		end)
	end
end
--[[

TORSO -> 1
FEET  -> 1
EYES  -> 1
ACCESSORIES 1


--]]

local function SubMenuFace()
	--GenericVariationMenu(PED_VARIATION.FACE)
	PedMenu.CheckBox('checkbox =D', function (bool) System:Debug('asdasdasdasdasd '.. tostring(bool))end, true)
	local items = {'a','b', 'c'}
	PedMenu.ComboBox('combo :c', items, function (index, item) System:Debug('zzzzz ['.. tostring(index)..'] ['..item..']')end, 2)
	PedMenu.SelectList('list :c', items, function (index, item) System:Debug('xxxxxx '.. tostring(index)..' '..item)end, 3)
end

local function SubMenuHead()
	GenericVariationMenu(PED_VARIATION.HEAD)
end

local function SubMenuHair()
	GenericVariationMenu(PED_VARIATION.HAIR)
end

local function SubMenuTorso()
	GenericVariationMenu(PED_VARIATION.TORSO)
end

local function SubMenuLegs()
	GenericVariationMenu(PED_VARIATION.LEGS)
end

local function SubMenuHands()
	GenericVariationMenu(PED_VARIATION.HANDS)
end

local function SubMenuFeet()
	GenericVariationMenu(PED_VARIATION.FEET)
end

local function SubMenuEyes()
	GenericVariationMenu(PED_VARIATION.EYES)
end

local function SubMenuAccessories()
	GenericVariationMenu(PED_VARIATION.ACCESSORIES)
end

local function SubMenuTasks()
	GenericVariationMenu(PED_VARIATION.TASKS)
end

local function SubMenuTextures()
	GenericVariationMenu(PED_VARIATION.TEXTURES)
end

local function SubMenuTorso2()
	GenericVariationMenu(PED_VARIATION.TORSO2)
end




-- ##########################
--        CLOSE SUBMENU
-- ##########################
local function CloseMenu()
	PedMenu.Button('Yes', nil, PedMenu.CloseMenu)
	PedMenu.MenuButton('No', 'clothes')
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
