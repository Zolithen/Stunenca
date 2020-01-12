
utf8 = require("utf8")

require "cmath"
require "eng/tree"
require "eng/game_state"

scene = new_tree("scene")

require "eng/console"

require "eng/gui/gui_element"
require "eng/gui/button"
require "eng/gui/list"

--[[local menu = new_tree("menu")

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

local fps_counter = new_game_node("fps_counter")
fps_counter:add_event("draw", function(self)
	love.graphics.print("FPS: " .. love.timer.getFPS(), clipx(0.9), 0)
end)
fps_counter.tag = "player"

local console = create_console()
console.visible = false

local oldp = print

function print(s, ...)
	oldp(s, ...)
	local ress = s
	for i, v in pairs({...}) do
		ress = ress .. " " .. tostring(v)
	end
	table.insert(console.value.log, ress)
end

scene:set(console)
scene:set(player)
scene:set(title)
scene:set(fps_counter)


scene:node_listen("scene")

scene:event_order("console", "draw", -1)
--scene:event_order("fps_counter_renderer", "draw", -1)
scene:event_order("fps_counter", "draw", -1)

--print(scene:find("fps_counter"):find("renderer"))]]

--[[local gui_layer = new_game_node("gui_layer")
gui_layer:set_value("color", {0.1, 0.1, 0.1, 1})]]

local console = create_console()
console.visible = false

local oldp = print

function print(s, ...)
	oldp(s, ...)
	local ress = tostring(s)
	for i, v in pairs({...}) do
		ress = ress .. " " .. tostring(v)
	end
	table.insert(console.value.log, ress)
end

local player = new_game_node("player")
player:set_value("interactable", 1)
player:add_event("draw", function(self)
	love.graphics.rectangle("fill", self.x, self.y, 16, 16)
end)

local enemy = new_game_node("enemy", 100, 100)
enemy:set_value("interactable", 1)
enemy:add_event("draw", function(self)
	love.graphics.rectangle("fill", self.x, self.y, 16, 16)
end)

scene:set(console)
scene:set(player)
scene:set(enemy)
scene:node_listen("player")
scene:node_listen("enemy")
scene:node_listen("console")

print("interactable")
for i, v in pairs(scene:find_func_all(function(self)
	return self.value.interactable ~= nil
end)) do
	print(i, v, v.name)
end

print("non interactable")
for i, v in pairs(scene:find_func_all(function(self)
	return self.value.interactable == nil
end)) do
	print(i, v, v.name)
end

--[[local button = new_gui_button("ye", function(self, mx, my, button) 
	print("Button has been clicked")
end, 0.1, 0.1, 0.8, 0.8, "fjskahk")]]

--[[local panel = new_gui_element("panel", 0.1, 0.1, 0.8, 0.8)

local list = new_gui_list("perk_list", 0.1, 0.1, 0.2, 0.5, {"Assasin", "Damage Boost", "Dash"})

local remove_button = new_gui_button("remove_button", function(self, x, y, button)
	table.remove(list.value.li, list.value.selected)
end, 0.1, 0.6, 0.07, 0.1, "Remove")

--gui_layer:set(button)
gui_layer:set(list)
gui_layer:set(panel)
gui_layer:set(remove_button)
scene:set(gui_layer)
scene:node_listen("gui_layer")

gui_layer:event_order("panel", "draw", 1)
scene:event_order("console", "draw", -1)]]
--[[for i, v in pairs(scene:find_func_all(function(self) return self.tag == "player" end)) do 
	--print(i, v, v.name)
end]]

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
	scene:event("mousepressed", x, y, button)
end


function love.wheelmoved(x, y)
	scene:event("wheelmoved", x, y)
end

function love.mousereleased(x, y, button)

end