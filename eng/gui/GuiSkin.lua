GuiSkin = Node:extend("GuiSkin");

GuiSkin.default_color = {0.1, 0.1, 0.1, 1};
GuiSkin.shighlight_color = {0.2, 0.2, 0.2, 1};
GuiSkin.highlight_color = {0.4, 0.4, 0.4, 1};
GuiSkin.font_color = {1, 1, 1, 1};

function GuiSkin:init(parent)
	GuiSkin.super.init(self, parent, "gui_skin", 0, 0);
end

function GuiSkin:set_color(s)
	love.graphics.setColor(self[s.."_color"]);
end

function GuiSkin:get_clickable_color(x, y, w, h)
	if math.pointraw(love.mouse.getX(), 
		love.mouse.getY(), 
		x*love.graphics.getWidth(), 
		y*love.graphics.getHeight(), 
		w, 
		h) then

		return self.default_color
	else
		return self.highlight_color
	end
end

return GuiSkin