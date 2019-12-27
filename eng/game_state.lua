serpent = require "eng/serpent"

-- The game state stack
local gst = {}

function gst:push(gast)
	table.insert(self.st, gast)
end

function gst:pop(num)
	for i = 1, (num or 1) do
		table.remove(self.st, #self.st)
	end
end

function gst:as_tree()
	local nodes = new_tree("game_state_stack")
	for i, v in ipairs(self.st) do
		nodes:set(v.name, v.value)
	end
	return nodes
end

function game_state_stack(name, n)
	local t = {
		st = {}
	}

	setmetatable(t, {__index=gst})

	return t
end

--[[local gs = {}

function game_state(name)
	local t = new_tree(name, { scenes={}, active={} })

	setmetatable(t, {__index=gs})

	return t
end]]