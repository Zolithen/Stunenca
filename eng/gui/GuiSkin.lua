GuiSkin = Node:extend("GuiSkin");

GuiSkin.default_color = {0.1, 0.1, 0.1, 1};
GuiSkin.highlight_color = {0.4, 0.4, 0.4, 1};
GuiSkin.font_color = {1, 1, 1, 1};

function GuiSkin:init(parent)
	GuiSkin.super.init(self, parent, "gui_skin", 0, 0);
end