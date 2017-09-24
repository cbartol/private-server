--[[
		README

API:
System:Debug( message )
System:Info( message )
System:Warn( message )
System:Error( message )

System:SetDebugLevel( debugLevel )
System:SetGlobalOutput( outputType )
System:SetOutput( debugLevel, outputType )

ENUMS:
	debugLevel:
		System.DEBUG_LEVEL.DEBUG
		System.DEBUG_LEVEL.INFO
		System.DEBUG_LEVEL.WARNING
		System.DEBUG_LEVEL.ERROR

	outputType:
		System.DEBUG_OUTPUT.CLIENT_CONSOLE   -- client side only
		System.DEBUG_OUTPUT.SERVER_CONSOLE   -- TODO: to be tested

--]]
System = {}

System.DEBUG_LEVEL = {
	DEBUG = 0,
	INFO = 1,
	WARNING = 2,
	ERROR = 3
}

System.DEBUG_OUTPUT = {
	CLIENT_CONSOLE = {printFunction=Citizen.Trace},
	SERVER_CONSOLE = {printFunction=print}
}

function System:SetDebugLevel( debugLevel )
	if debugLevel >= System.DEBUG_LEVEL.DEBUG and debugLevel <= System.DEBUG_LEVEL.ERROR then
		self.debugLevel = debugLevel
	end
end

function System:SetGlobalOutput( output )
	for key,value in pairs(System.DEBUG_LEVEL) do
		System:SetOutput(value, output)
	end
end

function System:SetOutput( debugLevel, output )
	self.output[debugLevel] = output
end

local function sendMessageToConsole(sys, level, message)
	sys.output[sys.debugLevel].printFunction(tostring(level..' '..tostring(message)))
end

function System:Debug(message)
	if self.debugLevel <= System.DEBUG_LEVEL.DEBUG then 
		sendMessageToConsole(self, '[DEBUG]', message)
	end
end

function System:Info(message)
	if self.debugLevel <= System.DEBUG_LEVEL.INFO then 
		sendMessageToConsole(self, '[INFO]', message)
	end
end

function System:Warn(message)
	if self.debugLevel <= System.DEBUG_LEVEL.WARNING then 
		sendMessageToConsole(self, '*[WARN]', message)
	end
end

function System:Error(message)
	if self.debugLevel <= System.DEBUG_LEVEL.ERROR then 
		sendMessageToConsole(self, '**[ERROR]', message)
	end
end





local function init()
	System.debugLevel = nil
	System.output = {}
	System:SetDebugLevel(System.DEBUG_LEVEL.WARNING)
	System:SetGlobalOutput(System.DEBUG_OUTPUT.SERVER_CONSOLE)
end

init()