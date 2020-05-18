Inspector = GuiElement:extend("Inspector");

function Inspector:init(parent, name, x, y, selector)
	Inspector.super.init(self, parent, name, x, y);
	self.selector = selector;
	self.default_loaders = {
		x = "text",
		y = "text"
	}
end

function Inspector:draw()
	local sk = self:get_skin();

	sk:set_color("default");

	love.graphics.rectangle("fill",
		self:get_x(),
		self:get_y(),
		200,
		lg.getHeight());

	-- Draw the selected node's properties
	if self.selector.selected > -1 then
		sk:set_color("font");
		love.graphics.print(self:get_node().name,self:get_x(),self:get_y());
		love.graphics.print(self:get_node().x,self:get_x(),self:get_y()+16);
		love.graphics.print(self:get_node().y,self:get_x(),self:get_y()+32);
	end
end

function Inspector:reload_selected()
	-- Create all the GUI elements related to the node
	--[[for i, v in ipairs(self.children) do
		v:remove();
	end]]
	self:remove_all();

	local j = 0;
	for i, v in pairs(self.default_loaders) do
		--print("loading " .. i, self.x, self.y+(j+2)*16);
		TextInput(self, "ins_"..i, 0, ((j+3)*16)/lg.getHeight(), "text");
		j = j + 1;
	end
end

function Inspector:get_node()
	return self.selector.selected_node;
end