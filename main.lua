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

function Player:update(dt)
	if lk.isDown("w") then self.y = self.y - 3 end
	if lk.isDown("s") then self.y = self.y + 3 end
	if lk.isDown("a") then self.x = self.x - 3 end
	if lk.isDown("d") then self.x = self.x + 3 end
end

function Player:draw()
	love.graphics.setColor(1, 1, 1, 1);
	love.graphics.rectangle("fill", self.x, self.y, 16, 16)
end




function TestNode:keypressed(k)
	if k == "r" then
		Player(scene, "player", 0, 0)
	end
end

for i = 1, 10 do
	Player(scene, "player", i*16, 0);
end
TestNode(scene, "controller", 0, 0);


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
