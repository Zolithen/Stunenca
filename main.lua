require "eng/tree"
require "eng/gui/GuiSkin"
require "eng/gui/GuiElement"
require "eng/gui/Button"
require "eng/gui/NodeTreeEditor"



local scene = Node(nil, "scene", 0, 0); -- uses absolute positioning
local gui = GuiElement(nil, "gui", 0, 0); -- uses relative positioning


local gui_skin = GuiSkin(gui);
gui.skin = gui_skin;

local Player = Node:extend("Player");

function Player:init(x, y)
	Player.super.init(self, scene, "player", x, y);
end

function Player:draw()
	love.graphics.rectangle("fill", self:get_x(), self:get_y(), 16 ,16);
end

--Player(0, 0);

local aaaa = Button(gui, "aaaa", 0.1, 0.1, "presioname", love.graphics.getFont());

GuiElement(aaaa, "guuuu", 0, 0);

local tree_editor = NodeTreeEditor(gui, "node_tree_editor", 0,0, gui);

function love.draw()
	scene:propagate_event("draw");
	gui:propagate_event("draw");
end

function love.update(dt)
	scene:propagate_event("update", dt);
	gui:propagate_event("update", dt);
end

function love.mousepressed(x, y, b)
	scene:propagate_event("mousepressed", x, y, b);
	gui:propagate_event("mousepressed", x, y, b);
end

function love.wheelmoved(y, x)
	scene:propagate_event("wheelmoved", y, x);
	gui:propagate_event("wheelmoved", y, x);
end


