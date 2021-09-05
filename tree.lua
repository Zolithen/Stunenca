local function reversedipairsiter(t, i)
    i = i - 1
    if i ~= 0 then
        return i, t[i]
    end
end
function r_ipairs(t)
    return reversedipairsiter, t, #t + 1
end
function create_30log()
local next, assert, pairs, type, tostring, setmetatable, baseMt, _instances, _classes, _class = next, assert, pairs, type, tostring, setmetatable, {}, setmetatable({},{__mode = 'k'}), setmetatable({},{__mode = 'k'})
local function assert_call_from_class(class, method) assert(_classes[class], ('Wrong method call. Expected class:%s.'):format(method)) end; local function assert_call_from_instance(instance, method) assert(_instances[instance], ('Wrong method call. Expected instance:%s.'):format(method)) end
local function bind(f, v) return function(...) return f(v, ...) end end
local default_filter = function() return true end
local function deep_copy(t, dest, aType) t = t or {}; local r = dest or {}; for k,v in pairs(t) do if aType ~= nil and type(v) == aType then r[k] = (type(v) == 'table') and ((_classes[v] or _instances[v]) and v or deep_copy(v)) or v elseif aType == nil then r[k] = (type(v) == 'table') and k~= '__index' and ((_classes[v] or _instances[v]) and v or deep_copy(v)) or v end; end return r end
local function instantiate(call_init,self,...) assert_call_from_class(self, 'new(...) or class(...)'); local instance = {class = self}; _instances[instance] = tostring(instance); deep_copy(self, instance, 'table')
	instance.__index, instance.__subclasses, instance.__instances, instance.mixins = nil, nil, nil, nil; setmetatable(instance,self); if call_init and self.init then if type(self.init) == 'table' then deep_copy(self.init, instance) else self.init(instance, ...) end end; return instance
end
local function extend(self, name, extra_params)
	assert_call_from_class(self, 'extend(...)'); local heir = {}; _classes[heir] = tostring(heir); self.__subclasses[heir] = true; deep_copy(extra_params, deep_copy(self, heir))
	heir.name, heir.__index, heir.super, heir.mixins = extra_params and extra_params.name or name, heir, self, {}; return setmetatable(heir,self)
end
baseMt = { __call = function (self,...) return self:new(...) end, __tostring = function(self,...)
	if _instances[self] then return ("instance of '%s' (%s)"):format(rawget(self.class,'name') or '?', _instances[self]) end; return _classes[self] and ("class '%s' (%s)"):format(rawget(self,'name') or '?', _classes[self]) or self end
}; _classes[baseMt] = tostring(baseMt); setmetatable(baseMt, {__tostring = baseMt.__tostring})
local class = {isClass = function(t) return not not _classes[t] end, isInstance = function(t) return not not _instances[t] end}
_class = function(name, attr) local c = deep_copy(attr); _classes[c] = tostring(c)
	c.name, c.__tostring, c.__call, c.new, c.create, c.extend, c.__index, c.mixins, c.__instances, c.__subclasses = name or c.name, baseMt.__tostring, baseMt.__call, bind(instantiate, true), bind(instantiate, false), extend, c, setmetatable({},{__mode = 'k'}), setmetatable({},{__mode = 'k'}), setmetatable({},{__mode = 'k'})
	c.subclasses = function(self, filter, ...) assert_call_from_class(self, 'subclasses(class)'); filter = filter or default_filter; local subclasses = {}; for class in pairs(_classes) do if class ~= baseMt and class:subclassOf(self) and filter(class,...) then subclasses[#subclasses + 1] = class end end; return subclasses end
	c.instances = function(self, filter, ...) assert_call_from_class(self, 'instances(class)'); filter = filter or default_filter; local instances = {}; for instance in pairs(_instances) do if instance:instanceOf(self) and filter(instance, ...) then instances[#instances + 1] = instance end end; return instances end
	c.subclassOf = function(self, superclass) assert_call_from_class(self, 'subclassOf(superclass)'); assert(class.isClass(superclass), 'Wrong argument given to method "subclassOf()". Expected a class.'); local super = self.super; while super do if super == superclass then return true end; super = super.super end; return false end
	c.classOf = function(self, subclass) assert_call_from_class(self, 'classOf(subclass)'); assert(class.isClass(subclass), 'Wrong argument given to method "classOf()". Expected a class.'); return subclass:subclassOf(self) end
	c.instanceOf = function(self, fromclass) assert_call_from_instance(self, 'instanceOf(class)'); assert(class.isClass(fromclass), 'Wrong argument given to method "instanceOf()". Expected a class.'); return ((self.class == fromclass) or (self.class:subclassOf(fromclass))) end
	c.cast = function(self, toclass) assert_call_from_instance(self, 'instanceOf(class)'); assert(class.isClass(toclass), 'Wrong argument given to method "cast()". Expected a class.'); setmetatable(self, toclass); self.class = toclass; return self end
	c.with = function(self,...) assert_call_from_class(self, 'with(mixin)'); for _, mixin in ipairs({...}) do assert(self.mixins[mixin] ~= true, ('Attempted to include a mixin which was already included in %s'):format(tostring(self))); self.mixins[mixin] = true; deep_copy(mixin, self, 'function') end return self end
	c.includes = function(self, mixin) assert_call_from_class(self,'includes(mixin)'); return not not (self.mixins[mixin] or (self.super and self.super:includes(mixin))) end	
	c.without = function(self, ...) assert_call_from_class(self, 'without(mixin)'); for _, mixin in ipairs({...}) do
		assert(self.mixins[mixin] == true, ('Attempted to remove a mixin which is not included in %s'):format(tostring(self))); local classes = self:subclasses(); classes[#classes + 1] = self
		for _, class in ipairs(classes) do for method_name, method in pairs(mixin) do if type(method) == 'function' then class[method_name] = nil end end end; self.mixins[mixin] = nil end; return self end; return setmetatable(c, baseMt) end
class._DESCRIPTION = '30 lines library for object orientation in Lua'; class._VERSION = '30log v1.2.0'; class._URL = 'http://github.com/Yonaba/30log'; class._LICENSE = 'MIT LICENSE <http://www.opensource.org/licenses/mit-license.php>'
return setmetatable(class,{__call = function(_,...) return _class(...) end })
end
class = create_30log()

lg = love.graphics

-- 30log classes
Node = class("Node");
NodeCache = class("NodeCache");
NodePool = class("NodePool");
NodePoolMap = class("NodePoolMap");

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

-- Initialize a node:
-- parent : Node -> The parent this node belongs to.
-- name : String -> Name of the node
-- x : Number -> x position of the node
-- y : Number -> y position of the node
function Node:init(parent, name, x, y)
	self.x, self.y = x, y;
	self.parent = parent;
	self.name = name;
	self.childs = -1;
	self.uuid = uuid(); -- Creates an unique identifier for this node
	math.randomseed(os.time()) -- Makes identifiers even more random
	

	self:count_child(); -- Sincerely no idea 


	if parent then -- If the node has a parent...
		table.insert(parent.children, self); -- means this node is children to the parent
		self.child_index = #parent.children; 
		self.cache = self:get_root().cache; -- means this node has a root

		if parent.on_add_children then -- Call parent's add children to notify a child has been added
			parent:on_add_children(self, #parent.children);
		end

		if self.cache.pool then -- make the pool update when calling an event
			self.cache.pool.outdated = true;
		end
	else -- If the node doesnt have a parent...
		self.cache = NodeCache(self);  -- means its a root node and needs a cache
	end
end

function Node:count_child()
	self.childs = self.childs + 1;
	if self.parent then
		self.parent:count_child();
	end
end

-- Gets a variable from the root node of this graph
-- name : String -> The name of the variable to retrieve
function Node:get_root_attr(name)
	if self.parent then
		return self.parent:get_root_attr(name) or nil;
	else
		return self[name] or nil;
	end
end

-- Adds a node to the children list
-- n : Node -> Node to add
function Node:add(n)
	table.insert(self.children, n);
	n.child_index = #self.children;
	if self.on_add_children then
		self:on_add_children(n, #self.children);
	end
end

-- Propagates an event to the entire tree or pool
-- name : String -> Name of the event
-- ... -> Arguments to pass onto the event
function Node:propagate_event(name, ...)

	if self.cache.pool then

		if self.cache.pool.outdated then
			self:construct_pool();
		end

		for i, v in ipairs(self.cache.pool.ipooled) do
			if v[name] then v[name](v, ...); end
		end

	else

		if self[name] then self[name](self, ...) end
		for i, v in ipairs(self.children) do
			v:propagate_event(name, ...);
		end

	end

end

-- Propagates an event to the entire tree going backwards
-- name : String -> Name of the event
-- ... -> Arguments to pass onto the event
function Node:propagate_event_reverse(name, ...)
	if self.cache.pool then

		if self.cache.pool.outdated then
			self:construct_pool();
		end

		for i, v in ipairs(self.cache.pool.rpooled) do
			if v[name] then v[name](v, ...); end
		end

	else

		if self[name] then self[name](self, ...) end
		for i, v in r_ipairs(self.children) do
			v:propagate_event_reverse(name, ...);
		end

	end
end

-- Finds a node in the tree that satisfies the conditiong
-- cond : Function -> Function that returns true if the node satisfies the condition
-- ^ t : Table -> Internal argument used to store the list of found nodes
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

-- Gets the absolute x of the node
function Node:get_x()
	if self.parent then
		return (self.x or 0) + (self.parent:get_x() or 0);
	else
		return self.x or 0;
	end
end

-- Gets the absolute y of the node
function Node:get_y()
	if self.parent then
		return (self.y or 0) + (self.parent:get_y() or 0);
	else
		return self.y or 0;
	end
end

-- Safely deletes the node
function Node:remove()
	if self.parent then -- If the node has a parent...
		table.remove(self.parent.children, self.child_index); -- we remove it from the parent's children table
		for i, v in ipairs(self.parent.children) do -- we update the children index of all the remaining childrens from the parent
			v.child_index = i;
		end
	end
	for i, v in ipairs(self.children) do -- We delete every children of this node
		v:remove();
	end
	self = nil; -- We finally delete the node

end

-- Removes all children nodes
function Node:remove_all()
	for i, v in r_ipairs(self.children) do
		v:remove();
	end
end

-- Constructs a node pool.
function Node:construct_pool()
	if self.parent == nil then
		self.cache.pool = NodePool();
		self:__construct_pool(self.cache.pool);
		self:__construct_reverse_pool(self.cache.pool);
	else
		error("Cannot construct pool in children node.");
	end
end

-- Internal function used to construct a pool
-- pool : NodePool -> The pool to add to
function Node:__construct_pool(pool)
	table.insert(pool.ipooled, self);
	for i, v in ipairs(self.children) do
		v:__construct_pool(pool);
	end
end

-- Internal function used to construct the reverse of a pool
-- pool : NodePool -> The pool to add to
function Node:__construct_reverse_pool(pool)
	table.insert(pool.rpooled, self);
	for i, v in r_ipairs(self.children) do
		v:__construct_reverse_pool(pool);
	end
end

-- Gets the root of the scene graph
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



function NodePool:init()
	self.rpooled = {};
	self.ipooled = {};
	self.outdated = false;
	self.auto_update = true;
end

function NodePool:add(t)
	table.insert(self.ipooled, t);
end

return Node