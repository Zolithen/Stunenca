love.graphics.setDefaultFilter("nearest", "nearest");

require "tree"

lk = love.keyboard

local scene = Node(nil, "scene", 0, 0)

function math.pboverlapraw(x1, y1, x2, y2, w, h) 
  return (
    (x1 > x2) and
    (x1 < x2 + w) and
    (y1 > y2) and
    (y1 < y2 + h)
  )
end



Player = Node:extend("Player")
TestNode = Node:extend("TestNode");
PoolViewer = Node:extend("PoolViewer");




function Player:update(dt)
	if lk.isDown("w") then self.y = self.y - 3 end
	if lk.isDown("s") then self.y = self.y + 3 end
	if lk.isDown("a") then self.x = self.x - 3 end
	if lk.isDown("d") then self.x = self.x + 3 end
end

function Player:draw()
	love.graphics.rectangle("fill", self.x, self.y, 16, 16)
end




function TestNode:keypressed(k)
	if k == "r" then
		Player(scene, "uwu", 0, 0)
	elseif k == "t" then
		self.cache.root:construct_pool();
	end
end


function PoolViewer:draw()
	for i, v in ipairs(self.cache.pool.pooled) do
		love.graphics.print(v.name, 0, (i-1)*16);
	end
end


function PoolViewer:mousepressed(mx, my, b)
	print(b, mx, my);
	for i, v in ipairs(self.cache.pool.pooled) do
		if math.pboverlapraw(mx, my, 0, (i-1)*16, 100, 16) then
			table.remove(self.cache.pool.pooled, i);
		end
	end
end


for i = 1, 10 do
	Player(scene, "uwu", i*16, 0);
end
TestNode(scene, "controller", 0, 0);
PoolViewer(scene, "pool_viewer", 0, 0);

scene:construct_pool();

function love.update(dt)
	scene:propagate_event("update", dt)
end

function love.draw()
	scene:propagate_event("draw")
end

function love.keypressed(k)
	scene:propagate_event("keypressed", k);
end

function love.mousepressed(mx, my, b)
	scene:propagate_event("mousepressed", mx, my, b);
end
