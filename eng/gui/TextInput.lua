TextInput = GuiElement:extend("TextInput");

function TextInput:init(parent, name, x, y, typ)
	TextInput.super.init(self, parent, name, x, y);
	self.type = typ;
	self.buffer = "";
	self.ins_text = love.graphics.newText(love.graphics.getFont(), self.buffer)
	self.synced = nil;

	self.w = 100;
	self.h = 16;
end

function TextInput:draw()
	local sk = self:get_skin();

	sk:set_color("highlight");
	--print("drawing at ", self:get_x(), self:get_y(), self.x, self.y, self.parent:get_x(), self.parent:get_y(), self.parent.x, self.parent.y, self.parent.parent.x, self.parent.parent.y);
	love.graphics.rectangle("fill", 
		self:get_x(), 
		self:get_y(), 
		self.w, 
		self.h
	);
	
	sk:set_color("font");
	lg.draw(self.ins_text, self:get_x(), self:get_y());
end

function TextInput:mousepressed(x,y,b)
	if math.pointraw(x, 
		y, 
		self:get_x(), 
		self:get_y(), 
		self.w, 
		self.h) and b == 1 then

		--[[local cy = y-(self:get_y()*love.graphics.getHeight())+self.ty

		self.selected = math.floor(cy/16);

		self:resolve_selected();]]
		self:get_root():propagate_event("unfocus");
		self.focused = true;

	end
end

function TextInput:textinput(t)
	if self.focused then
		self.buffer = self.buffer .. t;
		self.ins_text = love.graphics.newText(love.graphics.getFont(), self.buffer)
		self.w = self.ins_text:getWidth();
	end
end

return TextInput
