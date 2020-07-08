love.graphics.setDefaultFilter("nearest", "nearest");

require "eng/tree"


--[[require "eng/utility/Input"
require "eng/graphics/SpriteBatch"

require "eng/gui/GuiElement"
require "eng/gui/WindowController"
require "eng/gui/Window"
require "eng/gui/Label"
require "eng/gui/Button"
require "eng/gui/SubWindow"]]

-- uses relative positioning
--[[gui = GuiElement(nil, "gui", 0, 0); -- game's gui
egui = GuiElement(nil, "egui", 0, 0); -- engine's gui


inp = InputManager(scene);

local rec_sprite = love.graphics.newImage("assets/rectangle.png");
batch = NodeSpriteBatch(scene, "batch", 1, 1);
batch:add_texture(rec_sprite, 0, 0);

inp:hook_up("left1", "a");
inp:hook_up("right1", "d");
inp:hook_up("down1", "s");
inp:hook_up("up1", "w");

inp:hook_up("left2", "left");
inp:hook_up("right2", "right");
inp:hook_up("up2", "up");
inp:hook_up("down2", "down");

inp:hook_up("left3", "j");
inp:hook_up("right3", "l");
inp:hook_up("down3", "k");
inp:hook_up("up3", "i");

local players = Node(scene, "players", 0, 0);

local Player = Node:extend("Player");

function Player:init(x, y)
	Player.super.init(self, players, "player", x, y);
	self.batch_index = batch:add_rect(1, self.x, self.y, 16, 16);
end

function Player:draw()
	love.graphics.setColor(1, 1, 1, 1);
	batch:set_rect(self.batch_index, 1, self.x, self.y, 16, 16);
end

function Player:update(dt)
	if inp:pressed("left" .. self.child_index) then
		self.x = self.x - 3;
	end
	if inp:pressed("right" .. self.child_index) then
		self.x = self.x + 3;
	end
	if inp:pressed("down" .. self.child_index) then
		self.y = self.y + 3;
	end
	if inp:pressed("up" .. self.child_index) then
		self.y = self.y - 3;
	end
end

Player(0, 0);
Player(16, 16);
Player(32, 32);]]

--local fnt = love.graphics.newFont("assets/Roboto-Thin.ttf", 14);
--[[local fnt = love.graphics.getFont();
egui = WindowController();]]

--[[Window(egui, "test_window", 100, 100, "1");
Window(egui, "test2", 200, 200, "2");]]
--[[local win1 = egui:add_window("test1", 100, 100, "1");
local win2 = egui:add_window("test2", 200, 200, "2");
--win1.evisible = false;
egui:register_element("label", Label);
egui:register_element("button", Button);
egui:register_element("subw", SubWindow);
egui:add_element("test1", "label", "AAAAAAAA", 0, 0);
egui:add_element("test1", "button", "AAAAAAAAAAAAAAAAAAAAAA", fnt, 0, 16);
egui:add_element("test1", "subw", 0, 0, 1000, 1000, 500, 500, function(self)
	self.winc:add_element("www", "subw", 100, 100, 300, 300, 50, 50);
end);
egui:add_element("test2", "subw", 0, 0, 1000, 1000, 500, 500);
egui:add_element("test2", "label", "wojñsfgbasf", 0, 200);]]
--abel(egui, "test1", "sklofa", "iaskfj");

function love.draw()
	--[[scene:propagate_event("predraw");
	egui:propagate_event("predraw");

	love.graphics.setStencilTest();
	love.graphics.setColor(1, 1, 1, 1);

	scene:propagate_event("draw");
	egui:propagate_event("draw");

	love.graphics.setStencilTest();
	love.graphics.setColor(1, 1, 1, 1);

	scene:propagate_event("postdraw");
	egui:propagate_event("postdraw");

	love.graphics.setStencilTest();
	love.graphics.setColor(1, 1, 1, 1);]]
end

function love.update(dt)
	--egui:propagate_event_reverse("update", dt);
	--scene:propagate_event_reverse("update", dt);
end

function love.mousepressed(x, y, b)
	--egui:propagate_event_reverse("mousepressed", x, y, b);
	--scene:propagate_event_reverse("mousepressed", x, y, b);
end

function love.mousereleased(x, y, b)
	--egui:propagate_event_reverse("mousereleased", x, y, b);
	--scene:propagate_event_reverse("mousereleased", x, y, b);
end

function love.mousemoved(x, y, dx, dy)
	--egui:propagate_event_reverse("mousemoved", x, y, dx, dy);
	--scene:propagate_event_reverse("mousemoved", x, y, dx, dy);
end

function love.wheelmoved(y, x)
	--egui:propagate_event_reverse("wheelmoved", y, x);
	--scene:propagate_event_reverse("wheelmoved", y, x);
end

function love.textinput(t)
	--egui:propagate_event_reverse("textinput", t);
end

function love.keypressed(k)
	--egui:propagate_event_reverse("keypressed", k);
	--scene:propagate_event_reverse("keypressed", k);
end

function love.keyreleased(k)
	--egui:propagate_event_reverse("keyreleased", k);
	--scene:propagate_event_reverse("keyreleased", k);
end


