NodeTreeEditor = GuiElement:extend("NodeTreeEditor");

function NodeTreeEditor:init(parent, name, x, y, tree)
	NodeTreeEditor.super.init(self, parent, name, x, y);
	self.tree = tree;
	self.texts = {};
	self.selected = -1;
	self.selected_node = {};

	self.w = 100;
	self.h = 100;

	self.tx = 0;
	self.ty = 0;

	if tree then
		--self.texts = self:create_tree_text();
	end
end

-- Rectangular stencil used to draw the text
local rect_stencil = function()
	local ww, hh = lg.getWidth(), lg.getHeight();
	love.graphics.rectangle("fill",
		0, 
		0, 
		100, 
		100
	)
end

function NodeTreeEdtior:update_selected_node(n)

end

-- Draws the name of a node in the scene tree
-- TODO: Optimize it so it only draws an approximate of the
-- names that can be seen, instead of stenciling the whole list.
function NodeTreeEditor:draw_node(s, d, yy)
	love.graphics.print(s.name, ((d-1)*16), yy);
	for i, v in ipairs(s.children) do
		yy = yy + 16;
		yy = self:draw_node(v, d+1, yy)
	end
	return yy;
end

function NodeTreeEditor:draw()
	local sk = self:get_skin();

	love.graphics.setColor(sk.default_color);
	love.graphics.rectangle(
		"fill", 
		self:get_x()*lg.getWidth(), 
		self:get_y()*lg.getHeight(), 
		self.w, 
		self.h
	);

	love.graphics.push();

		love.graphics.translate(
			self:get_x()*lg.getWidth(),
			self:get_y()*lg.getHeight()
		);

			love.graphics.stencil(rect_stencil, "replace", 1);
			love.graphics.setStencilTest("greater", 0);

			love.graphics.translate(
				0,-self.ty
			);

				love.graphics.setColor(sk.highlight_color);
				love.graphics.rectangle(
					"fill",
					0,
					self.selected*16,
					self.w,
					16
				);

				love.graphics.setColor(sk.font_color);
				self:draw_node(self.tree, 1, 0);
			love.graphics.setStencilTest();

	love.graphics.pop();


	love.graphics.setColor(
		1,1,1,1
	);
end

function NodeTreeEditor:mousepressed(x, y, b)
	if math.pointraw(x, 
		y, 
		self:get_x()*love.graphics.getWidth(), 
		self:get_y()*love.graphics.getHeight(), 
		self.w, 
		self.h) then

		local cy = y-(self:get_y()*love.graphics.getHeight())+self.ty

		self.selected = math.floor(cy/16);

	end
end

function NodeTreeEditor:wheelmoved(mx, my)
	if math.pointraw(love.mouse.getX(), 
		love.mouse.getY(), 
		self:get_x()*love.graphics.getWidth(), 
		self:get_y()*love.graphics.getHeight(), 
		self.w, 
		self.h) then

		self.ty = math.clamp(
			0,
			self.ty-(my*10),
			self.tree.childs*16
		);

	end
end