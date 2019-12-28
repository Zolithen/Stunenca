
require "cmath"
require "eng/tree"
require "eng/game_state"
require "eng/console"

scene = new_tree("scene")

local menu = new_tree("menu")

menu:set("title", {draw=function(self) love.graphics.print("sfa", 100, 100) end})

local player = new_game_node("player")
player:set_value("hello", true)

player:add_event("update", function(self, dt)
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
end)
player:add_event("draw", function(self)
	love.graphics.rectangle("fill",  self.x,  self.y, 16, 16)	
end)


scene:set(create_console())
scene:set(player)

--scene:set(menu)

--print(scene:find("player"):get_value("hello"))

love.keyboard.setKeyRepeat(true)

function love.load()

end

function love.update(dt)
	scene:traverse(
		function(t, nx)
			if is_game_node(t) then
				if t.value.update then
					t.value:update(dt)
				end
			end
		end
	)
	--should_act_keys = true
end

function love.draw()
	local y = 0
	scene:traverse(
		function(t, nx)
			if is_game_node(t) then
				if t.value.draw and t.visible then
					t.value:draw()
				end
			end
			love.graphics.print(t.name .. ":"  .. tostring(t.value), nx*16, y)
			y = y + 16
		end
	)
end

function love.textinput(text)
	scene:traverse(
		function(t, nx)
			if is_game_node(t) then
				if t.value.textinput then
					t.value:textinput(text)
				end
			end
		end
	)
end

function love.keypressed(key)
	scene:traverse(
		function(t, nx)
			if is_game_node(t) then
				if t.value.keypressed then
					if t.value:keypressed(key) then 
						return true
					end
				end
			end
		end
	)
end

function love.keyreleased(key)

end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end