local Test = Node:extend("TestNode");
local CorruptedTest = "haha";

Test.defname = "holamundo";
Test.uwu = {
	"owo",
	"awa",
	"ewe",
	"iwi",
	"uwu"
}

function Test:init(par, nam)
	Test.super.init(self, par, nam, 0, 0);
	self.t = "Test"
end

function Test:draw()
	love.graphics.setColor(0.5, 0.5, 0.5, 1);
	love.graphics.print(self.t, self.x, self.y);
	love.graphics.setColor(1, 1, 1, 1);
end

return Test;