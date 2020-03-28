
require "cmath"

lg = love.graphics

local nt = {}

-- Adds a children to the node
function nt:add(n)
	table.insert(self.children, n);
	if self.on_add_children then
		self:on_add_children(n, #self.children);
	end
end

-- Find all the nodes that return true when passed to the cond function
function nt:find(cond, t)
	local t = t or {};
	for i, v in ipairs(self.children) do
		if cond(v) then
			table.insert(t, v);
			t = v:find(cond, t);
		end	
	end
	return t;
end

-- Propagates an event to the entire node tree
function nt:propagate_event(name, ...)
	if self[name] then if self[name](self, ...) then return true end end
	for i, v in ipairs(self.children) do
		if not v.cancel_event then
			if v:propagate_event(name, ...) then break; end
		end
	end
end

-- Propagates an event to the entire node tree in reverse
function nt:propagate_event_reverse(name, ...)
	if self[name] then if self[name](self, ...) then return true end end
	for i, v in r_ipairs(self.children) do
		if not v.cancel_event then
			if v:propagate_event(name, ...) then break; end
		end
	end
end

function nt:propagate_event_raw(name, ...)
	if self[name] then if self[name](self, ...) then return true end end
	for i, v in ipairs(self.children) do
		if v:propagate_event(name, ...) then break; end
	end
end

function nt:propagate_event_reverse_raw(name, ...)
	if self[name] then if self[name](self, ...) then return true end end
	for i, v in r_ipairs(self.children) do
		if v:propagate_event(name, ...) then break; end
	end
end

-- Creates an array of references of all the nodes in the tree
function nt:ref_array(a)
	for i, v in ipairs(self.children) do
		
	end
end

-- Executes a funtion for every node in the tree
function nt:traverse(func)
	func(self);
	for i, v in ipairs(self.children) do
		v:traverse(func);
	end
end

-- Gets the final x and y of the node
function nt:get_x()
	if self.parent then
		return (self.x or 0) + (self.parent:get_x() or 0);
	else
		return self.x or 0;
	end
end

function nt:get_y()
	if self.parent then
		return (self.y or 0) + (self.parent:get_y() or 0);
	else
		return self.y or 0;
	end
end

function nt:get_pos()
	return {x=self:get_x(), y=self:get_y()}
end

function new_node(parent, name)
	local n = {
		name = name or "",
		x = 0,
		y = 0,
		children = {},
		parent = parent or nil
	}

	setmetatable(n, {__index=nt});

	if parent then
		parent:add(n);
	end

	return n
end

function delegate_index_node()
	return table.copy(nt);
end