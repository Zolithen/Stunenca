StencilNode = Node:extends("StencilNode");

function StencilNode:init(sc, n)
	StencilNode.super.init(self, sc, n, 0, 0);
	self.boxes = {};
end

function StencilNode:reset()
	self.boxes = {};
end

function StencilNode:add(x, y, w ,h)
	table.insert(self.boxes, {x, y, w, h});
	return #self.boxes
end

function StencilNode:apply()
	for i, v in ipairs(self.boxes) do
		love.graphics.stencil(function()
    		love.graphics.rectangle("fill", unpack(v));
    	end, "replace", 1)
	end
	love.graphics.setStencilTest("greater", 0);
end