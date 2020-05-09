require "cmath"
class = require "eng/utility/30log"

lg = love.graphics

Node = class("Node");

Node.children = {};

-- TODO: Batch node adding
function Node:init(parent, name, x, y)
	self.x, self.y = x, y;
	self.parent = parent;
	self.name = name;
	self.childs = -1;

	self:count_child();

	if parent then
		table.insert(parent.children, self);
		self.child_index = #parent.children;
	--else
		
	end
end

function Node:count_child()
	self.childs = self.childs + 1;
	if self.parent then
		self.parent:count_child();
	end
end

function Node:get_root_attr(name)
	if self.parent then
		return self.parent:get_root_attr(name) or nil;
	else
		return self[name] or nil;
	end
end

function Node:add(n)
	table.insert(self.children, n);
	n.child_index = #self.children;
	if self.on_add_children then
		self:on_add_children(n, #self.children);
	end
end

function Node:propagate_event(name, ...)
	for i, v in ipairs(self.children) do
		if v[name] then
			v[name](v, ...);
		end
	end
end

function Node:propagate_event_reverse(name, ...)
	for i, v in r_ipairs(self.children) do
		if v[name] then
			v[name](...);
		end
	end
end

function Node:find(cond, t)
	local t = t or {};
	for i, v in ipairs(self.children) do
		if cond(v) then
			table.insert(t, v);
			t = v:find(cond, t);
		end	
	end
	return t;
end

-- Find the first node named name
-- TODO : Optimization
function Node:find_name(a, t)
	local t = t or {};
	for i, v in ipairs(self.children) do
		if v.name == a then
			table.insert(t, v);
			break;
		else
			t = v:find(a, t);
		end	
	end
	return t[1];
end

function Node:get_x()
	if self.parent then
		return (self.x or 0) + (self.parent:get_x() or 0);
	else
		return self.x or 0;
	end
end

function Node:get_y()
	if self.parent then
		return (self.y or 0) + (self.parent:get_y() or 0);
	else
		return self.y or 0;
	end
end

function Node:remove()
	if self.parent then
		table.remove(self.parent.children, self.child_index);
		for i, v in ipairs(self.parent.children) do
			v.child_index = i;
		end
	end
	for i, v in ipairs(self.children) do
		v:remove();
	end

end

--[[local nt = {}

-- Finds a component in the node's children
function nt:find_component(nam)
	for i, v in pairs(self.children) do
		if v.name == nam and v.component ~= nil then
			return v.component;
		end
	end
end

-- Adds a children to the node
function nt:add(n)
	table.insert(self.children, n);
	-- On add children callback
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

-- Find the first node named name
function nt:find_name(a, t)
	local t = t or {};
	for i, v in ipairs(self.children) do
		if v.name == a then
			table.insert(t, v);
			t = v:find(a, t);
		end	
	end
	return t[1];
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

function nt:get_x(t)
	if self.parent then
		return self.parent:get_x()+self.x
	else
		return self.x
	end
end

function nt:get_y(t)
	if self.parent then
		return self.parent:get_y()+self.y
	else
		return self.y
	end
end

function nt:get_pos()
	return {x=self:get_x(), y=self:get_y()}
end

function nt:delete()
	if self.on_delete then
		self:on_delete();
	end
	if self.parent then
		table.remove(self.parent.children, self.child_index);
    	for i, v in ipairs(self.parent.children) do
     		v.child_index = i;
   		end
		self = nil;
	else
		self = nil;
	end
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
		n.child_index = #parent.children+1;
		parent:add(n);
	end

	return n
end

function delegate_index_node()
	return table.copy(nt);
end]]