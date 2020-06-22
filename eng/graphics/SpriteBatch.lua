NodeSpriteBatch = Node:extend("NodeSpriteBatch");

function NodeSpriteBatch:init(sc, n, atw, ath, al_premult)
	Node.init(self, sc, n, 0, 0);
	self.quads = {};
	self.canvas = love.graphics.newCanvas(atw or 1024, ath or 1024);
	self.batch = love.graphics.newSpriteBatch(self.canvas);
	self.alpha_premult = al_premult or false;
end

-- draws the batch
function NodeSpriteBatch:draw()
	if self.alpha_premult then -- fixes issues with pre rendered text on batches
		love.graphics.setBlendMode("alpha", "premultiplied")
	end
	love.graphics.draw(self.batch, 0, 0);
	love.graphics.setBlendMode("alpha")
	--self:clear();
end

-- sends the batch to the graphics card
function NodeSpriteBatch:send()
	self.batch:flush();
end

-- adds a texture and its quad to the batch
function NodeSpriteBatch:add_texture(i, x, y)
	love.graphics.setColor(1, 1, 1, 1);
	love.graphics.setCanvas(self.canvas);
	love.graphics.draw(i, x, y);
	table.insert(self.quads, 
		love.graphics.newQuad(x, y, 
			i:getWidth(), 
			i:getHeight(), 
			self.canvas:getWidth(), 
			self.canvas:getHeight()
		)
	);
	love.graphics.setCanvas();
end

function NodeSpriteBatch:add_texture_wh(i, x, y, w, h)
	love.graphics.setColor(1, 1, 1, 1);
	love.graphics.setCanvas(self.canvas);
	love.graphics.draw(i, x, y);
	table.insert(self.quads, 
		love.graphics.newQuad(x, y, 
			w, 
			h, 
			self.canvas:getWidth(), 
			self.canvas:getHeight()
		)
	);
	love.graphics.setCanvas();
end

function NodeSpriteBatch:add_texture_print(f, s, x, y)
	love.graphics.setColor(1, 1, 1, 1);
	local t = love.graphics.newText(f, s);
	love.graphics.setCanvas(self.canvas);
	--love.graphics.print(s, x, y);
	print("texture q", x, y, t:getWidth(), t:getHeight());
	love.graphics.draw(t, x, y);
	table.insert(self.quads, 
		love.graphics.newQuad(x, y, 
			t:getWidth(), 
			t:getHeight(), 
			self.canvas:getWidth(), 
			self.canvas:getHeight()
		)
	);
	love.graphics.setCanvas();
	return t;
end

function NodeSpriteBatch:add_rect(imgind, x, y, sx, sy, r, ox, oy, kx, ky)
	return self.batch:add(self.quads[imgind], x, y, r, sx, sy, ox, oy, kx, ky);
end

function NodeSpriteBatch:set_rect(sprind, quad, x, y, sx, sy, r, ox, oy, kx, ky)
	self.batch:set(sprind, self.quads[quad], x, y, r, sx, sy, ox, oy, kx, ky);
end

function NodeSpriteBatch:clear()
	self.batch:clear();
end

function NodeSpriteBatch:set_color(r, g, b, a)
	self.batch:setColor(r, g, b, a);
end