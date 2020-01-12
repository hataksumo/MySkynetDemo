--[[
Auth:Chiuan
like Unity Brocast Event System in lua.
]]

local EventLib = require "eventlib"

local Event = {}
local events = {}

function Event.AddListener(v_iEvent,v_fnHandler,v_oHost)
	if not v_iEvent  then
		error("event can't be nil")
	end
	if not v_fnHandler or type(v_fnHandler) ~= "function" then
		error("handler parameter in addlistener function has to be function, " .. type(v_fnHandler) .. " not right")
	end

	if not events[v_iEvent] then
		--create the Event with name
		events[v_iEvent] = EventLib:new(event)
	end

	--conn this handler
	return events[v_iEvent]:connect(v_fnHandler,v_oHost)
end




function Event.Brocast(event,...)
	local tEvent = events[event]
	if not tEvent then
		error("brocast " .. event .. " has no event.")
	else
		tEvent:fire(...)
	end
end

function Event.BrocastMsg(event,...)
	if  events[event] then
		events[event]:fire(...)
	end
end

function Event.RemoveListener(event,handler)
	if not events[event] then
		error("remove " .. event .. " has no event.")
	else
		events[event]:disconnect(handler)
	end
end

return Event