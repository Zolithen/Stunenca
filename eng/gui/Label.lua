Label = GuiElement:extend("Label");

function Label:init(win, name, text, x, y)
	Label.super.init(self, win, name, x, y);
	self.text = text;
	--[[ -- batched implementation ends here 
	self.t, self.tex_ind = win.batch:add_texture_print(
		love.graphics.newFont("assets/Roboto-Thin.ttf", 14),
		text
	);
	self.batch_ind = win.batch:add_rect(1);]]
end

function Label:draw()
	love.graphics.print(self.text, self:get_x(), self:get_y());
end