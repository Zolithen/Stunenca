GuiElement = Node:extend("GuiElement");

function GuiElement:get_stencil()
	if self.wc_stencil then return self.wc_stencil else
		return self.parent:get_stencil();
	end
end