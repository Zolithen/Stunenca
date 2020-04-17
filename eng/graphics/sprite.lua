function new_sprite(s, imgd)
	local n = new_node(s, "sprite");

	if type(imgd) == "string" then
		n.sprite = love.graphics.newImage(imgd);
	else
		n.sprite = imgd
	end
	n.component = n;
	n.visible = true;

	n.draw = function(self)
		if not self.visible then return end
		love.graphics.draw(self.sprite, self:get_x(), self:get_y());
	end

	return n
end

function new_animation(s, imgd, sx, sy, w, h, ax, ay)
	local n = new_node(s, "sprite");

	if type(imgd) == "string" then
		n.sheet = love.graphics.newImage(imgd);
	else
		n.sheet = imgd
	end

	n.frames = {
	}

	 for y = 1, ay do
	 	for x = 1, ax do
	 		local xx = (x-1)*w+sx
	 		local yy = (y-1)*h+sy
	 		table.insert(n.frames, love.graphics.newQuad(xx, yy, w, h, n.sheet:getDimensions()))
	 	end
	 end

	n.component = n;
	n.state = "playing";
	n.speed = 0.1;
	n.timer = 0;
	n.ind = 1;
	n.visible = true;

	n.update = function(self, dt)
		if self.state == "playing" and self.visible then
			local l = math.floor(self.timer / (self.speed*#self.frames));
			if l>=1 then self.timer = 0 end
			n.timer = n.timer + dt;
			self.ind = math.floor(self.timer/self.speed)+1;
		end
	end

	n.draw = function(self)
		if not self.visible then return end
		if self.ind > #self.frames then self.ind = 1 end
		love.graphics.draw(self.sheet, self.frames[self.ind], self:get_x(), self:get_y());
	end

	return n
end

--[[

]]