love.graphics.setDefaultFilter("nearest", "nearest");

require "tree"

lk = love.keyboard

local scene = Node(nil, "scene", 0, 0)

Player = Node:extend("Player")

function Player:update(dt)
	if lk.isDown("w") then self.y = self.y - 3 end
	if lk.isDown("s") then self.y = self.y + 3 end
	if lk.isDown("a") then self.x = self.x - 3 end
	if lk.isDown("d") then self.x = self.x + 3 end
end

function Player:draw()
	love.graphics.rectangle("fill", self.x, self.y, 16, 16)
end

Player(scene, "player", 0, 0)

function love.update(dt)
	scene:propagate_event("update", dt)
end

function love.draw()
	scene:propagate_event("draw")
end
