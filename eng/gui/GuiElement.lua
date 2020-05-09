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
end

function GuiElement:get_skin()
	if self.skin then return self.skin else
		return self.parent:get_skin();
	end
end

--[[function GuiElement:get_skin_attribute(name)
	return self:get_skin()[name];
end]]