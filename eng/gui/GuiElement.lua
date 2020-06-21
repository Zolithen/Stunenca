GuiElement = Node:extend("GuiElement");

-- needs parent set to relative positioning
function GuiElement:init(parent, name, x, y, skin)
	GuiElement.super.init(self, parent, name, x, y);
	if skin then
		self.skin = skin;
	else
		--[[if parent then
			parent:get_skin();
		end]]
	end
	self.focused = false;
end

function GuiElement:get_skin()
	if self.skin then return self.skin else
		return self.parent:get_skin();
	end
end

function GuiElement:unfocus()
	self.focused = false;
end

function GuiElement:get_x()
	if self.parent then
		return (self.x*lg.getWidth() or 0) + (self.parent:get_x() or 0);
	else
		return self.x or 0;
	end
end

function GuiElement:get_y()
	if self.parent then
		return (self.y*lg.getHeight() or 0) + (self.parent:get_y() or 0);
	else
		return self.y or 0;
	end
end

--[[function GuiElement:get_skin_attribute(name)
	return self:get_skin()[name];
end]]

return GuiElement