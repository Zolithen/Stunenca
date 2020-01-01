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
	else self.children[name.name] = name  end

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

function tr:node_listen_raw(n)
	if n then
		for i, v in pairs(n.value) do
			if type(v) == "function" then -- iterate all over the functions
				self:listen(i, n.name)
			end
		end
		if n.children then
			for i, v in pairs(n.children) do
				print(i, v)
				n:node_listen(i)
			end
		end
	end
end

-- Adds all of a node's events as listeners
function tr:node_listen(name)
	local n = self:find(name)
	--[[if n then
		for i, v in pairs(n.value) do
			if type(v) == "function" then -- iterate all over the functions
				self:listen(i, name)
			end
		end
	end]]
	self:node_listen_raw(n)
end

-- Executes an event for an specific node
function tr:event_raw(name, node, ...)
	if node.value[name] ~= nil then node.value[name](node.value, ...) end
	--[[if not table.is_empty(node.children) then
		for i, v in pairs(node.children) do -- calls the event for every children
			self:event_raw(name, v, ...)
		end
	end]]
	if node.listeners[name] then
		node:event(name, ...)
	end
	--if node.listeners[name] then node:event(name, ...) end
end

-- Executes an event for every children that is listening
function tr:event(name, ...)
	if self.listeners[name] then
		for i, v in pairs(self.listeners[name]) do -- calls the event for every listener
			local f = self:find(v)
			--print("executing event for: ", v, f)
			if f ~= nil then
				self:event_raw(name, f, ...)
			end
		end
	end

end

-- Reorders the listeners
function tr:event_order(name, event, order)
	if self.listeners[event] ~= nil then
		if order == -1 then -- negative order
			local temps = table.copy(self.listeners[event])
			local list_set = Set(temps) -- creates a set from the listeners
			local res = {}
			for i, v in pairs(temps) do
				if not (i == list_set[name]) then -- if the name is on listeners
					table.insert(res, v)
				end
			end
			table.insert(res, name) -- inserts the given name into the listeners
			self.listeners[event] = table.copy(res)
		elseif order == 1 then
			print("fdsafasf")
			local temps = table.copy(self.listeners[event])
			local list_set = Set(temps) -- creates a set from the listeners
			local res = {}
			table.insert(res, name) -- inserts the given name into the listeners
			for i, v in pairs(temps) do
				if not (i == list_set[name]) then -- if the name is on listeners
					table.insert(res, v)
				end
			end

			for i, v in pairs(res) do
				print(i, v)
			end

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

-- Iterates all over a tree, returning every node that fits with the
-- function provided
function tr:find_func_all(func, ntt)
	local nt = ntt or {}
	if func(self) then table.insert(nt, self) end
	for i, v in pairs(self.children) do
		v:find_func_all(func, nt)
	end
	return nt
end

-- Gets a value from the value table
function tr:get_value(n)
	if type(self.value) == "table" then return self.value[n] end
end

-- Sets a value from the value table
function tr:set_value(n, v)
	if type(self.value) == "table" then self.value[n] = v end
end

-- Creates a new tree
function new_tree(name, n, fa)
	local val = n or {}
	val.draw = function() end
	val.update = function(dt) end
	val.keypressed = function(key, scancode, isrepeat) end
	val.keyreleased = function(key, scancode) end
	val.mousepressed = function(x, y, button, presses) end
	val.mousereleased = function(x, y, button, presses) end
	val.textinput = function(text) end
	val.draw = function() end
	val.wheelmoved = function() end

	local t = {
		children = {},
		value = val,
		name = name or "",
		father = fa or {},
		active = true,
		visible = true,
		listeners = {draw={}},
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