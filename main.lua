
require "cmath"
require "eng/tree"
require "eng/game_state"
require "eng/console"

require "eng/gui/gui_element"
require "eng/gui/button"

scene = new_tree("scene")

local menu = new_tree("menu")

local title = new_game_node("title")
title:add_event("draw", function(self)
	love.graphics.print("sfa", 100, 100)
end)
--menu:set("title", {draw=function(self) love.graphics.print("sfa", 100, 100) end})

local player = new_game_node("player")
player.tag = "player"
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

--[[scene:set(create_console()):order(
	"console", "draw", -1, "keypressed", 1, "keyreleased", 1
)]]
local fps_counter = new_game_node("fps_counter")
fps_counter:add_event("draw", function(self)
	love.graphics.print("FPS: " .. love.timer.getFPS(), clipx(0.9), 0)
end)

local console = create_console()
console.visible = false

local oldp = print

function print(s, ...)
	oldp(s, ...)
	local ress = s
	for i, v in pairs({...}) do
		ress = ress .. " " .. v
	end
	table.insert(console.value.log, ress)
end

scene:set(console)
scene:set(player)
scene:set(title)
scene:set(fps_counter)

scene:node_listen("player")
scene:node_listen("console")
scene:node_listen("title")
scene:node_listen("fps_counter")

scene:event_order("console", "draw", -1)
scene:event_order("fps_counter", "draw", -1)

--[[scene:listen("draw", "console", "player", "title")
scene:listen("update", "console", "player")
scene:listen("keypressed", "console")
scene:listen("keyreleased", "console")
scene:listen("textinput", "console")]]

--scene:apply_order()

--scene:set(menu)

--print(scene:find("player"):get_value("hello"))

love.keyboard.setKeyRepeat(true)

function love.load()

end

function love.update(dt)
	scene:event("update", dt)
end

function love.draw()
	scene:event("draw")
end

function love.textinput(text)
	scene:event("textinput", text)
end

function love.keypressed(key)
	scene:event("keypressed", key)
end

function love.keyreleased(key)

end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end