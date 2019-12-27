
require "eng/tree"
require "eng/game_state"

print("creating base")
local scene = new_tree("no", 10000)

local menu = new_tree("yes")

local player = new_tree("player", {x = 0, y = 0})

menu:set("title", {draw=function(self) love.graphics.print("sfa", 100, 100) end})

player:set("movement", {update=function(self, node)
	if love.keyboard.isDown("w") then
		node.father.value.y = node.father.value.y - 3
	end
	if love.keyboard.isDown("s") then
		node.father.value.y = node.father.value.y + 3
	end
	if love.keyboard.isDown("a") then
		node.father.value.x = node.father.value.x - 3
	end
	if love.keyboard.isDown("d") then
		node.father.value.x = node.father.value.x + 3
	end
end})

player:set("renderer", {draw=function(self, node)
	love.graphics.rectangle("fill",  node.father.value.x,  node.father.value.y, 16, 16)	
end})

menu:set(player)

scene:set(menu)

--[[scene:set(
	"player",
	{	
		x = 0,
		y = 0,
		update = function(self, node, dt)
			if love.keyboard.isDown("w") then
				self.y = self.y - 3
			end
			if love.keyboard.isDown("s") then
				self.y = self.y + 3
			end
			if love.keyboard.isDown("a") then
				self.x = self.x - 3
			end
			if love.keyboard.isDown("d") then
				self.x = self.x + 3
			end
		end,
		draw = function(self, node)
			love.graphics.rectangle("fill", self.x, self.y, 16, 16)
		end
	}
)]]

function love.load()

end

function love.update(dt)
	scene:traverse(
		function(t, nx)
			if type(t.value) == "table" then
				if t.value.update then
					t.value:update(t, dt)
				end
			end
		end
	)
end

function love.draw()
	local y = 0
	scene:traverse(
		function(t, nx)
			if type(t.value) == "table" then
				if t.value.draw then
					t.value:draw(t)
				end
			end
			love.graphics.print(t.name .. ":"  .. tostring(t.value), nx*16, y)
			y = y + 16
		end
	)
	--draw_tree(scene, "fskpioa", 0, 0)
end

function love.keypressed(key)

end

function love.keyreleased(key)

end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end