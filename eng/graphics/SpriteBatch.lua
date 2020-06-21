NodeSpriteBatch = Node:extend("NodeSpriteBatch");

function NodeSpriteBatch:init(sc, n, atw, ath)
	Node.init(self, sc, n, 0, 0);
	self.quads = {};
	self.canvas = love.graphics.newCanvas(atw or 1024, ath or 1024);
	self.batch = love.graphics.newSpriteBatch(self.canvas);
end

-- draws the batch
function NodeSpriteBatch:draw()
	love.graphics.draw(self.batch, 0, 0);
	--self:clear();
end

-- sends the batch to the graphics card
function NodeSpriteBatch:send()
	self.batch:flush();
end

-- adds a texture and its quad to the batch
function NodeSpriteBatch:add_texture(i, x, y)
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

function NodeSpriteBatch:add_rect(imgind, x, y, r, sx, sy, ox, oy, kx, ky)
	return self.batch:add(self.quads[imgind], x, y, r, sx, sy, ox, oy, kx, ky);
end

function NodeSpriteBatch:set_rect(sprind, quad, x, y, r, sx, sy, ox, oy, kx, ky)
	self.batch:set(sprind, self.quads[quad], x, y, r, sx, sy, ox, oy, kx, ky);
end

function NodeSpriteBatch:clear()
	self.batch:clear();
end