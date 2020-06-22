Window = Panel:extend("Window")

-- TODO : better window resizing
function Window:init(sc, name, x, y, title)
	Node.init(self, sc, name, x, y);
	self.batch = NodeSpriteBatch(sc, name, 4096, 4096, true);

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
	);
	self.title = title;

	self.w = 100;
	self.h = 100;

	-- vars for moving the windows
	self.moving = false;
	self.mlx = 0; -- mouse last x 
	self.mly = 0; -- mouse last y

	-- vars for resizing the window
	self.expanding = false;

	-- window controller
	self.winc = nil;
end

function Window:draw()
	self.batch:set_color(0.2, 0.2, 0.2, 1);
	self.batch:set_rect(
		self.batch_ind.main,
		1,
		self:main_box()
	);

	self.batch:set_color(0.4, 0.4, 1, 1);
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
	);

	--[[love.graphics.push()
	love.graphics.scale(4, 4);
	love.graphics.draw(self.t, self.x, self.y -48);
	love.graphics.draw(self.batch.canvas, self.x, self.y);
	love.graphics.pop();]]
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
		self.x = self.x + (love.mouse.getX() - self.mlx);
		self.y = self.y + (love.mouse.getY() - self.mly);
	end
	if self.expanding then
		self.h = math.max(self.h + (love.mouse.getY() - self.mly), 0);
		self.w = math.max(self.w + (love.mouse.getX() - self.mlx), 0);
	end

	self.mlx = love.mouse.getX();
	self.mly = love.mouse.getY();
end

function Window:mousepressed(x, y, b)
	print(x, y, b);
	if math.pboverlapraw(
			x, y,
			self:title_box()
		) then
		self.moving = true;
		self.winc.end_event = true;
	elseif math.pboverlapraw(
			x, y,
			self:expand_box()
		) then
		print("expanidng");
		self.expanding = true;
		self.winc.end_event = true;
	end
end

function Window:mousereleased(x, y, b)
	self.moving = false;
	self.expanding = false;
end

-- boxes defining areas of the window 
function Window:main_box()
	return self.x, self.y+16, self.w, self.h
end

function Window:title_box()
	return self.x, self.y, self.w, 16
end

function Window:expand_box()
	return self.x+self.w-20, self.y+self.h-20+16, 20, 20
end