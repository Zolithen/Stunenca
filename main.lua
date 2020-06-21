GuiState = {};

require "eng/tree"

require "eng/gui/GuiSkin"
require "eng/gui/GuiElement"
require "eng/gui/Button"
require "eng/gui/TextInput"

require "eng/gui/NodeTreeEditor"

require "eng/gui/engine/Inspector"

Slab = require "eng/Slab"

scene = Node(nil, "scene", 0, 0); -- uses absolute positioning

-- uses relative positioning
gui = GuiElement(nil, "gui", 0, 0); -- game's gui
egui = GuiElement(nil, "egui", 0, 0); -- engine's gui

local egui_skin = GuiSkin(egui);
egui.skin = egui_skin;

require "editor/SlabNode"

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

--[[local aaaa = Button(egui, "aaaa", 0.1, 0.1, "presioname", love.graphics.getFont());

GuiElement(aaaa, "guuuu", 0, 0);
GuiElement(egui, "eeeee", 0, 0);
GuiElement(egui, "sasa", 0, 0);
GuiElement(egui, "guuussu", 0, 0);
GuiElement(egui, "guuuaau", 0, 0);
GuiElement(egui, "guufsauu", 0, 0);

local tree_editor = NodeTreeEditor(egui, "node_tree_editor", 0,0, egui);

-- TODO : Make a dynamic position vector
-- TODO : Use relative positioning
local inspector = Inspector(egui, "inspector", (lg.getWidth()-200)/lg.getWidth(), 0, tree_editor)
tree_editor.inspector = inspector;]]

function love.load(args) 
	SlabNode(args)
end

function love.draw()
	scene:propagate_event("draw");
	egui:propagate_event("draw");
	love.graphics.setColor(1, 1, 1, 1);
	--love.graphics.print( (egui.selected_node or {name="nil"}).name, 0, 0 );
end

function love.update(dt)
	egui:propagate_event("update", dt);
	--scene:propagate_event("update", dt);
end

function love.mousepressed(x, y, b)
	egui:propagate_event("mousepressed", x, y, b);
	scene:propagate_event("mousepressed", x, y, b);
end

function love.wheelmoved(y, x)
	egui:propagate_event("wheelmoved", y, x);
	scene:propagate_event("wheelmoved", y, x);
end

function love.textinput(t)
	egui:propagate_event("textinput", t);
end

function love.keypressed(k)
	egui:propagate_event("keypressed", k);
	scene:propagate_event("keypressed", k);
end


