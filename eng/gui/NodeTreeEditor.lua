NodeTreeEditor = GuiElement:extend("NodeTreeEditor");

function NodeTreeEditor:init(parent, name, x, y, tree)
	NodeTreeEditor.super.init(self, parent, name, x, y);
	self.tree = tree;
	self.texts = {};
	self.selected = -1;
	self.selected_node = {};

	self.inspector = nil;

	self.w = 100;
	self.h = 100;

	self.tx = 0;
	self.ty = 0;

	self.ii = 0;

	if tree then
		--self.texts = self:create_tree_text();
		self:collapse(tree);
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

function NodeTreeEditor:collapse(t)
	for i, v in ipairs(t.children) do
		v.collapsed = true;
		self:collapse(v);
	end
end

function NodeTreeEditor:select(v)
	print("found selected node", v.name);
	self.selected_node = v
	v.collapsed = false;
	if self.inspector then
		print("reloading inspector");
		self.inspector:reload_selected();
	end
end

function NodeTreeEditor:_resolve_selected(n)
	--self.ii = self.ii or 0;
	if n.collapsed then
		return false;
	end

	for i, v in ipairs(n.children) do
		print(self.ii, v.name);
		self.ii = self.ii + 1;
		if self.ii >= self.selected then
			--[[print("found selected node", v.name);
			self.selected_node = v
			v.collapsed = false;]]
			self:select(v);
			return true;
		else
			if self:_resolve_selected(v) then
				return true;
			end
		end
	end
end

function NodeTreeEditor:resolve_selected()
	self.ii = 0;
	if self.selected == 0 then
		--[[print("found selected node", self.tree.name);
		self.selected_node = self.tree
		self.tree.collapsed = false;]]
		self:select(self.tree);
	else
		self:_resolve_selected(self.tree);
	end
end

-- Draws the name of a node in the scene tree
-- TODO: Optimize it so it only draws an approximate of the
-- names that can be seen, instead of stenciling the whole list.
-- TODO: Modify love.mouse.isDown so it works on phone (?)
function NodeTreeEditor:draw_node(s, d, yy)
	local sk = self:get_skin();
	love.graphics.setColor(sk.font_color);
	love.graphics.print(s.name, ((d-1)*16)+8, yy);

	--love.graphics.setColor( sk:get_clickable_color( self.tx+(((d-1)*16)-8), self.ty+yy, 8, 16) );
	if math.pointraw(love.mouse.getX(), 
		love.mouse.getY(), 
		self:get_x()+(((d-1)*16)-8)-self.tx, 
		self:get_y()+yy-self.ty, 
		8, 
		16) then

		love.graphics.setColor(sk.highlight_color);
	else
		love.graphics.setColor(sk.shighlight_color);
	end
	love.graphics.rectangle("fill", (((d-1)*16)-8), yy, 8, 16);

	if not s.collapsed then
		for i, v in ipairs(s.children) do
			yy = yy + 16;
			yy = self:draw_node(v, d+1, yy)
		end
	end
	return yy;
end

function NodeTreeEditor:draw()
	local sk = self:get_skin();

	love.graphics.setColor(sk.default_color);
	love.graphics.rectangle(
		"fill", 
		self:get_x(), 
		self:get_y(), 
		self.w, 
		self.h
	);

	love.graphics.push();

		love.graphics.translate(
			self:get_x(),
			self:get_y()
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
		self:get_x(), 
		self:get_y(), 
		self.w, 
		self.h) then

		local cy = y-(self:get_y())+self.ty

		self.selected = math.floor(cy/16);

		self:resolve_selected();

	end
end

function NodeTreeEditor:wheelmoved(mx, my)
	if math.pointraw(love.mouse.getX(), 
		love.mouse.getY(), 
		self:get_x(), 
		self:get_y(), 
		self.w, 
		self.h) then

		self.ty = math.clamp(
			0,
			self.ty-(my*10),
			self.tree.childs*16
		);

	end
end