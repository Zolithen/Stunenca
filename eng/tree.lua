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
	if type(name) == "string" then self.children[name] = new_tree(name, n, self) 
	else self.children[name] = name  end

	return self
end

-- Executes a function for every children of the tree
function tr:traverse(func, nx)
	if not func(self, (nx or 0)) then
		nx = (nx or 0) + 1 -- Level of recursion
		for _, v in pairs(self.children) do
      		v:traverse(func, (nx or 0))
		end
	end
end

-- Adds nodes for event listening
function tr:listen(ev, ...)
	local names = {...}
	if self.listeners[ev] == nil then self.listeners[ev] = {} end
	for i, v in pairs(names) do
		table.insert(self.listeners[ev], v)
	end
end

-- Adds all of a node's events as listeners
function tr:node_listen(name)
	local n = self:find(name)
	if n then
		for i, v in pairs(n.value) do
			if type(v) == "function" then
				self:listen(i, name)
			end
		end 
	end
end

-- Executes an event for every children that is listening
function tr:event(name, ...)
	if self.listeners[name] then
		for i, v in pairs(self.listeners[name]) do
			local f = self:find(v)
			if f ~= nil then
				if f.value[name] ~= nil then
					f.value[name](f.value, ...)
				end
			end
		end
	end

end

-- Reorders the listeners
function tr:event_order(name, event, order)
	if self.listeners[event] ~= nil then
		if order == -1 then
			local temps = table.copy(self.listeners[event])
			for i, v in pairs(temps) do print(i, v) end
			local list_set = Set(temps)
			local res = {}
			print(list_set[name])
			for i, v in pairs(temps) do
				print(i, v, list_set[name])
				if not (i == list_set[name]) then
					table.insert(res, v)
				end
			end
			table.insert(res, name)
			self.listeners[event] = table.copy(res)
		end
	end
end

-- Iterates all over a tree until finding a node with name n
function tr:find(n)
	if self.name == n then return self end
	if not table.is_empty(self.children) then
		for _, v in pairs(self.children) do
			local nod = v:find(n)
			if nod then return nod end
		end
		return nil
	end
end

-- Iterates all over a tree, returning the first node that fits with the
-- function provided.
function tr:find_func(func)
	if func(self) then return self end
	if not table.is_empty(self.children) then
		for _, v in pairs(self.children) do
			local nod = v:find_func(func)
			if nod then return nod end
		end
		return nil
	end
end

-- Gets a value from the value table
function tr:get_value(n)
	if type(self.value) == "table" then return self.value[n] end
end

-- Sets a value from the value table
function tr:set_value(n, v)
	if type(self.value) == "table" then self.value[n] = v end
end

-- Orders the given node for event getting
--[[function tr:order(name, ...)
	local orders = {...}
	local res_orders = {}
	local arr_i = 0
	table.insert(orders, 0, 1)
	for i = 1, #orders/2 do
		res_orders[i] = {}
		res_orders[i][1] = orders[i*2]
		res_orders[i][2] = orders[i*2+1]
	end
	self.orders[name] = res_orders
end

function tr:apply_order()

end]]

-- Creates a new tree
function new_tree(name, n, fa)
	local t = {
		children = {},
		value = n or {},
		name = name or "",
		father = fa or {},
		active = true,
		visible = true,
		listeners = {},
		tag = ""
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
--[[gn.__newindex = function(t, k, v)
	if t.value then t.value[k] = v end
end]]

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

local oldk = love.keyboard.isDown

should_act_keys = true

function love.keyboard.isDown(key)
	return (oldk(key) and should_act_keys)
end

function block_keys()
	should_act_keys = false
end

function clipx(x)
	return x*love.graphics.getWidth()
end

function clipy(y)
	return y*love.graphics.getHeight()
end