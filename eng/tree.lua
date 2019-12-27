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

-- Creates a new tree
function new_tree(name, n, fa)
	print("new " .. tostring(name) .. "," .. tostring(n))
	local t = {
		children = {},
		value = n or 0,
		name = name or "",
		father = fa or {}
	}

	setmetatable(t, {__index=tr})

	return t
end