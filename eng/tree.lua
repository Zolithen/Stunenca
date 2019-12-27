-- A tree
serpent = require "eng/serpent"

local tr = {}

-- Returns a node from the tree
function tr:get(name)
	if self.children[name] ~= nil then
		return self.children[name], true
	else
		return new_tree(), false
	end
end

-- Sets a new or old node as children
function tr:set(name, n)
	print("set " .. tostring(name) .. "," .. tostring(n))
	if type(name) == "string" then self.children[name] = new_tree(name, n, self) 
	else self.children[name] = name  end

	return self
end

-- Executes a function for every children of the tree
function tr:traverse(func, nx)
	func(self, (nx or 0))
	nx = (nx or 0) + 1 -- Level of recursion
	for _, v in pairs(self.children) do
		v:traverse(func, (nx or 0))
	end
end

-- Iterates all over a tree until finding a node with name n
function tr:find(n)
	print("finding: " .. n .. "," .. self.name)
	if self.name == n then return self end
	if not table.is_empty(self.children) then
		for _, v in pairs(self.children) do
			local nod = v:find(n)
			if nod then return nod end
		end
		return {}
	end
end

-- Gets a value from the value table
function tr:get_value(n)
	if type(self.value) == "table" then return self.value[n] end
end

-- Creates a new tree
function new_tree(name, n, fa)
	print("new " .. tostring(name) .. "," .. tostring(n))
	local t = {
		children = {},
		value = n or {},
		name = name or "",
		father = fa or {}
	}

	setmetatable(t, {__index=tr})

	return t
end

-- Game nodes
local gn = {} -- Game node metatable
local gn_index = table.copy(tr) -- Game node index metamethod
local gnv = {} -- Game node value metatable
local gnv_index = {} -- Game node index metamethod

function gn_index:add_event(name, func)
	self.value[name] = func
end

gnv.__index = gnv_index
gn.__index = gn_index
gn.__newindex = function(t, k, v)
	if t.value then t.value[k] = v end
end

function new_game_node(name, fa)
	local t = new_tree(name, {
		x = 0,
		y = 0
	}, fa)
	setmetatable(t, gn)
	setmetatable(t.value, gnv)
	t.value.node = t
	return t
end

function is_game_node(node)
	if type(node) == "table" then
		if node.value then
			return getmetatable(node.value) == gnv
		end
	end
	return false
end