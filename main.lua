GuiState = {};

require "eng/tree"

require "eng/gui/GuiSkin"
require "eng/gui/GuiElement"
require "eng/gui/Button"
require "eng/gui/TextInput"

require "eng/gui/NodeTreeEditor"

require "eng/gui/engine/Inspector"

scene = Node(nil, "scene", 0, 0); -- uses absolute positioning

-- uses relative positioning
gui = GuiElement(nil, "gui", 0, 0); -- game's gui
egui = GuiElement(nil, "egui", 0, 0); -- engine's gui

local egui_skin = GuiSkin(egui);
egui.skin = egui_skin;

local Player = Node:extend("Player");

function Player:init(x, y)
	Player.super.init(self, scene, "player", x, y);
end

function Player:draw()
	love.graphics.setColor(1, 1, 1, 1);
	love.graphics.rectangle("fill", self:get_x(), self:get_y(), 16 ,16);
end

local Map = Node:extend("Map");

Player(0, 0);

function love.draw()
	scene:propagate_event("draw");
	egui:propagate_event("draw");
	love.graphics.setColor(1, 1, 1, 1);
end

function love.update(dt)
	egui:propagate_event_reverse("update", dt);
	scene:propagate_event_reverse("update", dt);
end

function love.mousepressed(x, y, b)
	egui:propagate_event_reverse("mousepressed", x, y, b);
	scene:propagate_event_reverse("mousepressed", x, y, b);
end

function love.wheelmoved(y, x)
	egui:propagate_event_reverse("wheelmoved", y, x);
	scene:propagate_event_reverse("wheelmoved", y, x);
end

function love.textinput(t)
	egui:propagate_event_reverse("textinput", t);
end

function love.keypressed(k)
	egui:propagate_event_reverse("keypressed", k);
	scene:propagate_event_reverse("keypressed", k);
end


