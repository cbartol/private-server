--PedCustomizationMenu version 1.0.0

PedMenu = { }

-- Options
PedMenu.debug = false

-- Local variables
local menus = { }
local keys = { 
	up = INPUT.CELLPHONE_UP, 
	down = INPUT.CELLPHONE_DOWN, 
	left = INPUT.CELLPHONE_LEFT, 
	right = INPUT.CELLPHONE_RIGHT, 
	select = INPUT.CELLPHONE_SELECT, 
	back = INPUT.CELLPHONE_CANCEL
}

local optionCount = 0

local currentKey = nil

local currentMenu = nil


local menuWidth = 0.23

local titleHeight = 0.11
local titleYOffset = 0.03
local titleScale = 1.0

local buttonHeight = 0.038
local buttonFont = 0
local buttonScale = 0.365
local buttonTextXOffset = 0.005
local buttonTextYOffset = 0.005

-- Global Debug
function SystemDebug(context, text)
	local moduleString = '[PedMenu'
	if context then
		moduleString = moduleString..'-'..context
	end
	moduleString=moduleString..']'
	Citizen.Trace(moduleString..' '..tostring(text))
end

-- Local functions=
local function debugPrint(text)
	if PedMenu.debug then
		Citizen.Trace('[PedMenu] '..tostring(text))
	end
end


local function setMenuProperty(id, property, value)
	if id and menus[id] then
		menus[id][property] = value
		debugPrint(id..' menu property changed: { '..tostring(property)..', '..tostring(value)..' }')
	end
end


local function isMenuVisible(id)
	if id and menus[id] then
		return menus[id].visible
	else
		return false
	end
end


local function setMenuVisible(id, visible, holdCurrent)
	if id and menus[id] then
		setMenuProperty(id, 'visible', visible)

		if not holdCurrent and menus[id] then
			setMenuProperty(id, 'currentOption', 1)
		end

		if visible then

			if id ~= currentMenu and isMenuVisible(currentMenu) then
				setMenuVisible(currentMenu, false)
			end

			currentMenu = id
		end
	end
end

local function cleanCurrentMenuState()
	menus[currentMenu].state = {} -- clear the menu's state;
end

local function cleanMenusStateUpwards()
	local menuId = currentMenu
	while menuId do
		
		menuId = menus[menuId].previousMenu
	end
end

local function cleanMenusStateDownwards(id, visitedIds)
	if visitedIds[id] then
		return -- menu already visited
	end
	visitedIds[id] = true
	menus[id].state = {} -- clear the menu's state;
	for _,v in ipairs(menus[id].children) do
		cleanMenusStateDownwards(v, visitedIds)
	end
end

-- -----------------------
--       DRAW SECTION
-- -----------------------
local function drawText(text, x, y, font, color, scale, center, shadow, alignRight)
	SetTextColour(color.r, color.g, color.b, color.a)
	SetTextFont(font)
	SetTextScale(scale, scale)

	if shadow then
		SetTextDropShadow(2, 2, 0, 0, 0)
	end

	if menus[currentMenu] then
		if center then
			SetTextCentre(center)
		elseif alignRight then
			SetTextWrap(menus[currentMenu].x, menus[currentMenu].x + menuWidth - buttonTextXOffset)
			SetTextRightJustify(true)
		end
	end

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x, y)
end


local function drawRect(x, y, width, height, color)
	DrawRect(x, y, width, height, color.r, color.g, color.b, color.a)
end


local function drawTitle()
	if menus[currentMenu] then
		local x = menus[currentMenu].x + menuWidth / 2
		local y = menus[currentMenu].y + titleHeight / 2

		drawRect(x, y, menuWidth, titleHeight, menus[currentMenu].titleBackgroundColor)
		drawText(menus[currentMenu].title, x, y - titleHeight / 2 + titleYOffset, menus[currentMenu].titleFont, menus[currentMenu].titleColor, titleScale, true)
	end
end


local function drawSubTitle()
	if menus[currentMenu] then
		local x = menus[currentMenu].x + menuWidth / 2
		local y = menus[currentMenu].y + titleHeight + buttonHeight / 2

		local subTitleColor = { r = menus[currentMenu].titleBackgroundColor.r, g = menus[currentMenu].titleBackgroundColor.g, b = menus[currentMenu].titleBackgroundColor.b, a = 255 }

		drawRect(x, y, menuWidth, buttonHeight, menus[currentMenu].subTitleBackgroundColor)
		drawText(menus[currentMenu].subTitle, menus[currentMenu].x + buttonTextXOffset, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTitleColor, buttonScale, false)

		if optionCount > menus[currentMenu].maxOptionCount then
			drawText(tostring(menus[currentMenu].currentOption)..' / '..tostring(optionCount), menus[currentMenu].x + menuWidth, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTitleColor, buttonScale, false, false, true)
		end
	end
end


local function drawButton(text, subText)
	local x = menus[currentMenu].x + menuWidth / 2
	local multiplier = nil

	if menus[currentMenu].currentOption <= menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].maxOptionCount then
		multiplier = optionCount
	elseif optionCount > menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount and optionCount <= menus[currentMenu].currentOption then
		multiplier = optionCount - (menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount)
	end

	if multiplier then
		local y = menus[currentMenu].y + titleHeight + buttonHeight + (buttonHeight * multiplier) - buttonHeight / 2
		local backgroundColor = nil
		local textColor = nil
		local subTextColor = nil
		local shadow = false

		if menus[currentMenu].currentOption == optionCount then
			backgroundColor = menus[currentMenu].menuFocusBackgroundColor
			textColor = menus[currentMenu].menuFocusTextColor
			subTextColor = menus[currentMenu].menuFocusTextColor
		else
			backgroundColor = menus[currentMenu].menuBackgroundColor
			textColor = menus[currentMenu].menuTextColor
			subTextColor = menus[currentMenu].menuSubTextColor
			shadow = true
		end

		drawRect(x, y, menuWidth, buttonHeight, backgroundColor)
		drawText(text, menus[currentMenu].x + buttonTextXOffset, y - (buttonHeight / 2) + buttonTextYOffset, buttonFont, textColor, buttonScale, false, shadow)

		if subText then
			drawText(subText, menus[currentMenu].x + buttonTextXOffset, y - buttonHeight / 2 + buttonTextYOffset, buttonFont, subTextColor, buttonScale, false, shadow, true)
		end
	end
end

-- ------------------------------
-- ------------------------------
-- ----------   API   -----------
-- ------------------------------
-- ------------------------------

---
-- Use this method to create a root menu. To open it invoke PadMenu.OpenMenu(id) 
--
-- @param id 				- id of the menu
-- @param title 			- text to be displayed at the top as a title (always visible in the menu's hierarchy)
-- @param subTitle 			- text to be displayed as subtitle
-- @param drawMenuFunction 	- this function must invoke every button to be displayed for the menu.
--
function PedMenu.CreateMenu(id, title, subTitle, drawMenuFunction)
	-- Default settings
	menus[id] = { }
	menus[id].title = title
	menus[id].subTitle = string.upper(subTitle)

	menus[id].visible = false

	menus[id].previousMenu = nil

	menus[id].aboutToBeClosed = false

	-- Top left corner
	menus[id].x = 0.0175
	menus[id].y = 0.025

	menus[id].currentOption = 1
	menus[id].maxOptionCount = 10

	menus[id].titleFont = 1
	menus[id].titleColor = { r = 0, g = 0, b = 0, a = 255 }
	menus[id].titleBackgroundColor = { r = 245, g = 127, b = 23, a = 255 }

	menus[id].menuTextColor = { r = 255, g = 255, b = 255, a = 255 }
	menus[id].menuSubTextColor = { r = 189, g = 189, b = 189, a = 255 }
	menus[id].menuFocusTextColor = { r = 0, g = 0, b = 0, a = 255 }
	menus[id].menuFocusBackgroundColor = { r = 245, g = 245, b = 245, a = 255 }
	menus[id].menuBackgroundColor = { r = 0, g = 0, b = 0, a = 160 }

	menus[id].subTitleBackgroundColor = { r = menus[id].menuBackgroundColor.r, g = menus[id].menuBackgroundColor.g, b = menus[id].menuBackgroundColor.b, a = 255 }

	menus[id].buttonPressedSound = { name = "SELECT", set = "HUD_FRONTEND_DEFAULT_SOUNDSET" } --https://pastebin.com/0neZdsZ5

	menus[id].DrawMenu = drawMenuFunction

	menus[id].state = {} -- this will have an array, each position is equal an option of the menu, and each position will old a state if needed (used for checkbox and combobox)

	menus[id].children = {} -- this will hold the ids of the submenus.	

	debugPrint(tostring(id)..' menu created')
end

---
-- Similar to PedMenu.Create but you reference a parent menu. The parent menu will be used to go back in the menu's hierarchy
--
-- @param id				- id of the submenu.
-- @param parent			- id of the parent's menu.
-- @param subTitle			- text to be displayed as subtitle
-- @param drawMenuFunction	- this function must invoke every button to be displayed for the menu.
--
function PedMenu.CreateSubMenu(id, parent, subTitle, drawMenuFunction)
	if menus[parent] then
		if subTitle == nil or subTitle == '' then
			subTitle = menus[parent].subTitle
		end

		PedMenu.CreateMenu(id, menus[parent].title, subTitle, drawMenuFunction)


		setMenuProperty(id, 'previousMenu', parent)

		setMenuProperty(id, 'x', menus[parent].x)
		setMenuProperty(id, 'y', menus[parent].y)
		setMenuProperty(id, 'maxOptionCount', menus[parent].maxOptionCount)
		setMenuProperty(id, 'titleFont', menus[parent].titleFont)
		setMenuProperty(id, 'titleColor', menus[parent].titleColor)
		setMenuProperty(id, 'titleBackgroundColor', menus[parent].titleBackgroundColor)
		setMenuProperty(id, 'menuTextColor', menus[parent].menuTextColor)
		setMenuProperty(id, 'menuSubTextColor', menus[parent].menuSubTextColor)
		setMenuProperty(id, 'menuFocusTextColor', menus[parent].menuFocusTextColor)
		setMenuProperty(id, 'menuFocusBackgroundColor', menus[parent].menuFocusBackgroundColor)
		setMenuProperty(id, 'menuBackgroundColor', menus[parent].menuBackgroundColor)
		setMenuProperty(id, 'subTitleBackgroundColor', menus[parent].subTitleBackgroundColor)
		table.insert(menus[parent].children, id)

	else
		debugPrint('Failed to create '..tostring(id)..' submenu: '..tostring(parent)..' parent menu doesn\'t exist')
	end
end

---
-- @returns the id of the current menu
--
function PedMenu.CurrentMenu()
	return currentMenu
end

---
-- Opens a specific menu. This should be called at the begining to start the menu.
-- It is recommended to only call this function if no other menu is opened and it is
-- recomended to pass a root menu as argument. 
--
-- @param id - id of the menu to be opened
--
function PedMenu.OpenMenu(id)
	if id and menus[id] then
		cleanMenusStateDownwards(id, {}) -- making sure we clean all states for all the menu's hierarchy
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
		setMenuVisible(id, true)
		debugPrint(tostring(id)..' menu opened')
	else 
		debugPrint('Failed to open '..tostring(id)..' menu: it doesn\'t exist')
	end
end

---
-- Call this function to display the current menu.
-- This is a function to be in the client loop
--
function PedMenu.DisplayOpenedMenu()
	debugPrint('opened menu['..tostring(currentMenu)..']')
	menus[currentMenu].DrawMenu()
	PedMenu.Display()
end

---
-- This is a function to be in the client loop
--
-- @returns true if any menu is being displayed to the user
--
function PedMenu.IsAnyMenuOpened()
	return currentMenu ~= nil
end

function PedMenu.IsMenuOpened(id)
	return isMenuVisible(id)
end


function PedMenu.IsMenuAboutToBeClosed()
	if menus[currentMenu] then
		return menus[currentMenu].aboutToBeClosed
	else
		return false
	end
end

---
-- Closes the displaying interface.
-- You can catch the action of closing the menu by executing PedMenu.IsMenuAboutToBeClosed() in your loop
--
function PedMenu.CloseMenu()
	if menus[currentMenu] then
		if menus[currentMenu].aboutToBeClosed then
			menus[currentMenu].aboutToBeClosed = false
			setMenuVisible(currentMenu, false)
			debugPrint(tostring(currentMenu)..' menu closed')
			PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			optionCount = 0
			currentMenu = nil
			currentKey = nil
			cleanMenusStateUpwards()
		else
			menus[currentMenu].aboutToBeClosed = true
			debugPrint(tostring(currentMenu)..' menu about to be closed')
		end
	end
end

---
-- Draws a generic button.
--
-- @param text 		- text of the button.
-- @param subText 	- (optional) text shown on the right of the button.
-- @param callback	- (optional) function executed if the button is clicked.
--
-- @returns true if the button was clicked
--
function PedMenu.Button(text, subText, callback)
	local buttonText = text
	if subText then
		buttonText = '{ '..tostring(buttonText)..', '..tostring(subText)..' }'
	end

	if menus[currentMenu] then
		optionCount = optionCount + 1

		local isCurrent = menus[currentMenu].currentOption == optionCount

		drawButton(text, subText)

		if isCurrent then
			if currentKey == keys.select then
				PlaySoundFrontend(-1, menus[currentMenu].buttonPressedSound.name, menus[currentMenu].buttonPressedSound.set, true)
				debugPrint(buttonText..' button pressed')
				if callback then
					callback()
				end
				return true
			elseif currentKey == keys.left or currentKey == keys.right then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			end
		end

		return false
	else
		debugPrint('Failed to create '..buttonText..' button: '..tostring(currentMenu)..' menu doesn\'t exist')

		return false
	end
end

---
-- Draws a generic button to open a submenu
--
-- @param text 		- text of the button.
-- @param id 		- id of the submenu.
-- @param callback	- (optional) function executed if the button is clicked.
--
-- @returns true if the button was clicked
--
function PedMenu.MenuButton(text, id, callback)
	if menus[id] then
		return PedMenu.Button(text, nil, function()
			setMenuVisible(currentMenu, false)
			setMenuVisible(id, true, true)
			if callback then
				callback()
			end
			return true
		end)
	else
		debugPrint('Failed to create '..tostring(text)..' menu button: '..tostring(id)..' submenu doesn\'t exist')
	end

	return false
end

---
-- Draws a checkbox button. You can pass an initial value if you have a stored state.
--
-- @param text				- text of the button.
-- @param callback(result)	- (optional) function executed if the button is clicked. This
--							  function recieves as argument a boolean with the new state
-- @param initialBoolValue	- (optional) initial value for the checkbox. "false" by default
--
-- @returns true if the button was clicked
--
function PedMenu.CheckBox(text, callback, initialBoolValue)
	local currentDrawingOption = (optionCount + 1)

	-- init state value
	if not menus[currentMenu].state[currentDrawingOption] then 
		System:Debug('bbbbbbbbbbbbbb ' .. tostring(currentDrawingOption)) 
		menus[currentMenu].state[currentDrawingOption] = {}
		menus[currentMenu].state[currentDrawingOption].bool = initialBoolValue
	end

	local bool = menus[currentMenu].state[currentDrawingOption].bool

	local checked = 'Off'
	if bool then
		checked = 'On'
	end

	return PedMenu.Button(text, checked, function()
		bool = not bool
		debugPrint(tostring(text)..' checkbox changed to '..tostring(bool))
		callback(bool)
		menus[currentMenu].state[currentDrawingOption].bool = bool
		return true
	end)
end

---
-- Draws a combobox button. You can pass an initial selected value if you have a stored state.
-- You must click to save the option
--
-- Note: use either PedMenu.SelectList or PedMenu.ComboBox. Don't use both because you can confuse the user!
--
-- @param text					- text of the button.
-- @param items					- list of items to be displayed. (the values will be printed to the interface)
-- @param callback(index, item)	- (optional) function executed if the button is clicked. This function recieves
--								  as first argument the index of the selected item in the array and as second value
--								  the item itself.
-- @param initialSelectedValue	- (optional) initial selected index value for the array. 1 by default
--
-- @returns true if the button was clicked
--
function PedMenu.ComboBox(text, items, callback, initialSelectedValue)
	local currentDrawingOption = (optionCount + 1)
	local isCurrent = menus[currentMenu].currentOption == (optionCount + 1)

	if not menus[currentMenu].state[currentDrawingOption] then 
		initialSelectedValue = (initialSelectedValue) and initialSelectedValue or 1 -- ninja skill to set the initial value to 1 if the argument passed is null
		System:Debug('aaaaaaaaaaaaaaa ' .. tostring(currentDrawingOption)) 
		menus[currentMenu].state[currentDrawingOption] = {}
		menus[currentMenu].state[currentDrawingOption].currentIndex = initialSelectedValue
		menus[currentMenu].state[currentDrawingOption].selectedIndex = initialSelectedValue
	end

	local currentIndex = menus[currentMenu].state[currentDrawingOption].currentIndex
	local selectedIndex = menus[currentMenu].state[currentDrawingOption].selectedIndex
	local itemsCount = #items
	local selectedItem = items[currentIndex]

	if itemsCount > 1 and isCurrent then
		selectedItem = '← '..tostring(selectedItem)..' →'
	end

	local optionWasSelected = PedMenu.Button(text, selectedItem, function()
		selectedIndex = currentIndex
		callback(selectedIndex, items[currentIndex])
		return true
	end)

	if isCurrent then
		if currentKey == keys.left then
			if currentIndex > 1 then currentIndex = currentIndex - 1 else currentIndex = itemsCount end
		elseif currentKey == keys.right then
			if currentIndex < itemsCount then currentIndex = currentIndex + 1 else currentIndex = 1 end
		end
	else
		currentIndex = selectedIndex
	end
	menus[currentMenu].state[currentDrawingOption].currentIndex = currentIndex
	menus[currentMenu].state[currentDrawingOption].selectedIndex = selectedIndex
	return optionWasSelected
end

---
-- Draws a selectable list. You can pass an initial selected value if you have a stored state.
-- The callback is executed as soon as you change the value
--
-- Note: use either PedMenu.SelectList or PedMenu.ComboBox. Don't use both because you can confuse the user!
--
-- @param text					- text of the button.
-- @param items					- list of items to be displayed. (the values will be printed to the interface)
-- @param callback(index, item)	- (optional) function executed if the button is clicked. This function recieves
--								  as first argument the index of the selected item in the array and as second value
--								  the item itself.
-- @param initialSelectedValue	- (optional) initial selected index value for the array. 1 by default
--
-- @returns true if the button was clicked
--
function PedMenu.SelectList(text, items, callback, initialSelectedValue)
	local currentDrawingOption = (optionCount + 1)
	local isCurrent = menus[currentMenu].currentOption == (optionCount + 1)

	if not menus[currentMenu].state[currentDrawingOption] then 
		initialSelectedValue = (initialSelectedValue) and initialSelectedValue or 1 -- ninja skill to set the initial value to 1 if the argument passed is null
		System:Debug('aaaaaaaaaaaaaaa ' .. tostring(currentDrawingOption)) 
		menus[currentMenu].state[currentDrawingOption] = {}
		menus[currentMenu].state[currentDrawingOption].currentIndex = initialSelectedValue
		menus[currentMenu].state[currentDrawingOption].selectedIndex = initialSelectedValue
	end

	local currentIndex = menus[currentMenu].state[currentDrawingOption].currentIndex
	local selectedIndex = menus[currentMenu].state[currentDrawingOption].selectedIndex
	local itemsCount = #items
	local selectedItem = items[currentIndex]

	if itemsCount > 1 and isCurrent then
		selectedItem = '← '..tostring(selectedItem)..' →'
	end

	PedMenu.Button(text, selectedItem)
	local returnValue = false
	if isCurrent then
		if currentKey == keys.left then
			if currentIndex > 1 then currentIndex = currentIndex - 1 else currentIndex = itemsCount end
			callback(currentIndex, items[currentIndex])
			returnValue = true
		elseif currentKey == keys.right then
			if currentIndex < itemsCount then currentIndex = currentIndex + 1 else currentIndex = 1 end
			callback(currentIndex, items[currentIndex])
			returnValue = true
		end
		selectedIndex = currentIndex
	else
		currentIndex = selectedIndex
	end
	menus[currentMenu].state[currentDrawingOption].currentIndex = currentIndex
	menus[currentMenu].state[currentDrawingOption].selectedIndex = selectedIndex
	return returnValue
end

---
-- The developer is not required to call this function anymore.
-- Draws everything to the screen.
--
function PedMenu.Display()
	if isMenuVisible(currentMenu) then
		if menus[currentMenu].aboutToBeClosed then
			PedMenu.CloseMenu()
		else
			ClearAllHelpMessages()

			drawTitle()
			drawSubTitle()

			currentKey = nil

			if IsControlJustPressed(0, keys.down) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

				if menus[currentMenu].currentOption < optionCount then
					menus[currentMenu].currentOption = menus[currentMenu].currentOption + 1
				else
					menus[currentMenu].currentOption = 1
				end
			elseif IsControlJustPressed(0, keys.up) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

				if menus[currentMenu].currentOption > 1 then
					menus[currentMenu].currentOption = menus[currentMenu].currentOption - 1
				else
					menus[currentMenu].currentOption = optionCount
				end
			elseif IsControlJustPressed(0, keys.left) then
				currentKey = keys.left
			elseif IsControlJustPressed(0, keys.right) then
				currentKey = keys.right
			elseif IsControlJustPressed(0, keys.select) then
				currentKey = keys.select
			elseif IsControlJustPressed(0, keys.back) then
				--cleanCurrentMenuState() -- preserve the state until the menu is closed
				if menus[menus[currentMenu].previousMenu] then
					PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
					setMenuVisible(menus[currentMenu].previousMenu, true)
				else
					PedMenu.CloseMenu()
				end
			end

			optionCount = 0
		end
	end
end


-- -----------------------------
-- -----------------------------
-- --------  AUX API  ----------
-- -----------------------------
-- -----------------------------
function PedMenu.SetMenuWidth(id, width)
	setMenuProperty(id, 'width', width)
end


function PedMenu.SetMenuX(id, x)
	setMenuProperty(id, 'x', x)
end


function PedMenu.SetMenuY(id, y)
	setMenuProperty(id, 'y', y)
end


function PedMenu.SetMenuMaxOptionCountOnScreen(id, count)
	setMenuProperty(id, 'maxOptionCount', count)
end


function PedMenu.SetTitleColor(id, r, g, b, a)
	setMenuProperty(id, 'titleColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].titleColor.a })
end
 
 
function PedMenu.SetTitleBackgroundColor(id, r, g, b, a)
	setMenuProperty(id, 'titleBackgroundColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].titleBackgroundColor.a })
end


function PedMenu.SetSubTitle(id, text)
	setMenuProperty(id, 'subTitle', string.upper(text))
end


function PedMenu.SetMenuBackgroundColor(id, r, g, b, a)
	setMenuProperty(id, 'menuBackgroundColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuBackgroundColor.a })
end


function PedMenu.SetMenuTextColor(id, r, g, b, a)
	setMenuProperty(id, 'menuTextColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuTextColor.a })
end

function PedMenu.SetMenuSubTextColor(id, r, g, b, a)
	setMenuProperty(id, 'menuSubTextColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuSubTextColor.a })
end

function PedMenu.SetMenuFocusColor(id, r, g, b, a)
	setMenuProperty(id, 'menuFocusColor', { ['r'] = r, ['g'] = g, ['b'] = b, ['a'] = a or menus[id].menuFocusColor.a })
end


function PedMenu.SetMenuButtonPressedSound(id, name, set)
	setMenuProperty(id, 'buttonPressedSound', { ['name'] = name, ['set'] = set })
end