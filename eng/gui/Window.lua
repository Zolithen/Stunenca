Window = Node:extend("Window")

-- TODO : better window resizing
function Window:init(sc, name, x, y, title)
	Node.init(self, sc, name, x, y);
	--[[self.batch = NodeSpriteBatch(sc, name, 4096, 4096, true);

	self.batch:add_texture(love.graphics.newImage("assets/rectangle.png"), 1, 1);

	self.batch_ind = {
		main = self.batch:add_rect(1),
		title_bar = self.batch:add_rect(1),
		close_button = self.batch:add_rect(1),
		expand_area = self.batch:add_rect(1),
		title = self.batch:add_rect(1)
	};

	self.t = self.batch:add_texture_print(
		love.graphics.newFont("assets/Roboto-Thin.ttf", 14),
		title,
		0,
		3
	);]]
	self.title = title;

	self.w = 100;
	self.h = 100;

	-- vars for moving the windows
	self.moving = false;
	self.mox = 0; --mouse offset x
	self.moy = 0; --mouse offset y

	-- vars for resizing the window
	self.expanding = false;

	-- window controller
	self.winc = nil;

	-- window options
	self.expandable = true;
	self.movable = true;
	self.focusable = true;
	self.evisible = true;
	self.stencilable = true;
	self.title_bar = true;
end

function Window:predraw()
	if self.focus then
		love.graphics.setColor(0, 1, 0, 1);
	else
		love.graphics.setColor(1, 0, 0, 1);
	end
	love.graphics.rectangle("fill", self:outline_box());
end

function Window:draw()
	if self.stencilable then
    	self:stencil();
    	love.graphics.setStencilTest("greater", 0);
	end

    if self.evisible then
		love.graphics.setColor(0.2, 0.2, 0.2, 1);
		love.graphics.rectangle("fill", self:main_box());
		if self.title_bar then
			if self.focus then
				love.graphics.setColor(0.4, 0.4, 1, 1);
			else
				love.graphics.setColor(0.5, 0.5, 1, 1);
			end
			love.graphics.rectangle("fill", self:title_box());
			love.graphics.setColor(1, 1, 1, 1);
			love.graphics.print(self.title, self.x, self.y);
		end
		love.graphics.setColor(0.5, 0.5, 0.5, 1);
		if self.expandable then
			love.graphics.rectangle("fill", self:expand_box());
		end
	end

	love.graphics.setColor(1, 1, 1, 1);

	--[[self.batch:set_color(0.2, 0.2, 0.2, 1);
	self.batch:set_rect(
		self.batch_ind.main,
		1,
		self:main_box()
	);

	if self.parent.focus then
		self.batch:set_color(0.4, 0.4, 1, 1);
	else
		self.batch:set_color(0.5, 0.5, 1, 1);
	end
	self.batch:set_rect(
		self.batch_ind.title_bar,
		1,
		self:title_box()
	);

	self.batch:set_color(0.5, 0.5, 0.5, 1);
	self.batch:set_rect(
		self.batch_ind.expand_area,
		1,
		self:expand_box()
	);
	self.batch:set_color(1, 1, 1, 1);
	self.batch:set_rect(
		self.batch_ind.title,
		2,
		self.x, self.y
	);]]
	--[[self.batch:set_rect(
		self.batch_ind.close_button,
		1,
		self.x+80,
		self.y+2,
		12,
		12
	);]]
end

function Window:update(dt)
	if self.moving then
		self.x = love.mouse.getX() - self.mox;
		self.y = love.mouse.getY() - self.moy;
	end
	if self.expanding then
		self.w = math.max(love.mouse.getX() + self.mox - self.x, 20);
		self.h = math.max(love.mouse.getY() + self.moy - self.y - 16 , 20);
	end

	self.mlx = love.mouse.getX();
	self.mly = love.mouse.getY();
end

function Window:mousepressed(x, y, b)
	if is_hovered(self:title_box()) and self.movable then
		self.moving = true;
		self.winc.end_event = true;
		local xx, yy = self:title_box();
		self.mox = x - xx;
		self.moy = y - yy;
	elseif is_hovered(self:expand_box()) and self.expandable then
		self.expanding = true;
		self.winc.end_event = true;
		local xx, yy = self:expand_box();
		self.mox = 20 - (x - xx);
		self.moy = 20 - (y - yy);
	end
	if is_hovered(self:full_box()) and self.focusable then
		self.winc:focus_window(self.name);
		self.winc.end_event = true;
	end
end

function Window:mousereleased(x, y, b)
	self.moving = false;
	self.expanding = false;
end

function Window:stencil()
	love.graphics.stencil(function()
    	love.graphics.rectangle("fill", self:full_box());
    end, "replace", 1)
end

function Window:get_y()
	return Window.super.get_y(self) + 16;
end

-- boxes defining areas of the window 
function Window:main_box()
	if self.title_bar then
		return self.x, self.y+16, self.w, self.h
	else
		return self:full_box();
	end
end

function Window:title_box()
	return self.x, self.y, self.w, 16
end

function Window:expand_box()
	return self.x+self.w-20, self.y+self.h-20+16, 20, 20
end

function Window:full_box()
	return self.x, self.y, self.w, self.h+16
end

function Window:outline_box()
	return self.x-2, self.y-2, self.w+4, self.h+20
end