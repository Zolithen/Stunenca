-- TODO : Implement cmath's useful functions on to the engine.
require "cmath"
class = require "eng/utility/30log"

lg = love.graphics

Node = class("Node");
NodeCache = class("NodeCache");

Node.children = {};

-- TODO : change this function cus this code is unlicensed although its a gist
--https://gist.github.com/jrus/3197011
local random = math.random
local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

-- TODO: Batch node adding
function Node:init(parent, name, x, y)
	self.x, self.y = x, y;
	self.parent = parent;
	self.name = name;
	self.childs = -1;
	self.uuid = uuid();
	self.ev_line = "";
	math.reseed();
	

	self:count_child();

	if parent then
		table.insert(parent.children, self);
		self.child_index = #parent.children;
		self.cache = self:get_root().cache;
	else
		self.cache = NodeCache(self);
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
	if self[name] then self[name](self, ...); end
	for i, v in ipairs(self.children) do
		v:propagate_event(name, ...);
	end
end

function Node:propagate_event_reverse(name, ...)
	if self[name] then self[name](self, ...); end
	for i, v in r_ipairs(self.children) do
		v:propagate_event_reverse(name, ...);
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
	self = nil;

end

function Node:remove_all()
	for i, v in r_ipairs(self.children) do
		--table.remove(self.children, i);
		v:remove();
		--v:remove_all();
	end
end

function Node:get_root()
	if self.cache then return self.cache.root end
	if self.parent then
		return self.parent:get_root();
	else
		self.cache.root = self;
		return self;
	end
end

function NodeCache:init(root)
	self.root = root;
end

function NodeCache:reset()
	self.root = nil;
end