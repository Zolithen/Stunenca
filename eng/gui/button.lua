Button = GuiElement:extend("Button");

function Button:init(parent, name, x, y, label, fnt, skin)
	Button.super.init(self, parent, name, x, y, skin);
	self.text_obj = love.graphics.newText(fnt, label);
	self:set_text(label, fnt);
end

function Button:set_text(st, fnt)
	self.text_obj = love.graphics.newText(fnt or self.fnt, st);
	self.w = (self.text_obj:getWidth() + 16);
	self.h = (self.text_obj:getHeight() + 32);
end

function Button:mousepressed(x, y, b)
	if math.pointraw(
		x/love.graphics.getPixelWidth(), 
		y/love.graphics.getPixelHeight(), 
		self:get_x(), 
		self:get_y(), 
		self.w/love.graphics.getPixelWidth(), 
		self.h/love.graphics.getPixelHeight()
	) then
		print("dsadas");
	end
end

function Button:draw()
	local sk = self:get_skin();
	--print(sk);

	--[[love.graphics.print("W: " .. self.w, 0, 32);
	love.graphics.print("H: " .. self.h, 0, 48);
	love.graphics.print("X: " .. self:get_x()*love.graphics.getPixelWidth(), 0, 64);
	love.graphics.print("Y: " .. self:get_y()*love.graphics.getPixelHeight(), 0, 80);
	love.graphics.print("MX: " .. love.mouse.getX(), 0, 96);
	love.graphics.print("MY: " .. love.mouse.getY(), 0, 112);]]

	if math.pointraw(
		love.mouse.getX()/lg.getWidth(), 
		love.mouse.getY()/lg.getHeight(), 
		self:get_x(), 
		self:get_y(), 
		self.w/love.graphics.getPixelWidth(), 
		self.h/love.graphics.getPixelHeight()
	) then
		love.graphics.setColor(
			sk.highlight_color
		);
	else
		love.graphics.setColor(
			sk.default_color
		);
	end
	love.graphics.rectangle("fill", 
		self:get_x()*love.graphics.getPixelWidth(), 
		self:get_y()*love.graphics.getPixelHeight(), 
		self.w, 
		self.h
	);
	love.graphics.setColor(
		--self:get_skin_attribute("font_color")
		sk.font_color
	);
	love.graphics.draw(self.text_obj, self:get_x()*love.graphics.getPixelWidth()+8, self:get_y()*love.graphics.getPixelHeight()+16);
	love.graphics.setColor(1, 1, 1, 1);

end