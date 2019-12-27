-- Developer console

--[[local player = new_game_node("player")
player:set_value("hello", true)

player:add_event("update", function(self, dt)
	if love.keyboard.isDown("w") then
		self.y = self.y - 3
	end
	if love.keyboard.isDown("s") then
		self.y = self.y + 3
	end
	if love.keyboard.isDown("a") then
		self.x = self.x - 3
	end
	if love.keyboard.isDown("d") then
		self.x = self.x + 3
	end
end)
player:add_event("draw", function(self)
	love.graphics.rectangle("fill",  self.x,  self.y, 16, 16)	
end)

menu:set(player)]]

function create_console()
	local console = new_game_node("console")

	console:add_event("textinput", function(self, text)
		self.text = (self.text or "") .. text
	end)

	console:add_event("keypressed", function(self, key)
		print(key)
		if key == "return" then
			loadstring(self.text)()
			self.text = ""
		elseif key == "backspace" then
			self.text = self.text:sub(1, #self.text-1)
		end
	end)

	console:add_event("draw", function(self)
		love.graphics.print(self.text or "", 200, 200)
	end)

	return console
end

