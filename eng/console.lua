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
	console.tag = "console"
	--console:set_value("font", love.graphics.newFont("defont.ttf", 16))
	console:set_value("font", love.graphics.getFont())
	console:set_value("def_font", love.graphics.getFont())
	console:set_value("log", {})
	console:set_value("text", "")

	console:add_event("update", function(self, dt)

	end)

	console:add_event("textinput", function(self, text)
		--print(text)
		if self.node.visible and text ~= "backspace" then
			self.text = self.text .. text
		end
	end)

	console:add_event("keypressed", function(self, key)
		if key == "f4" then
			self.node.visible = not self.node.visible
		end
		if self.node.visible then
			if key == "return" then
				table.insert(self.log, "> " .. self.text)
       			local status, err = pcall(
					function() 
						loadstring(self.text)()
					end
				)
				if err then table.insert(self.log, err) end
				self.text = ""
			elseif key == "backspace" then
				local byteoffset = utf8.offset(self.text, -1)
				if byteoffset then
					self.text = string.sub(self.text, 1, byteoffset - 1)
				end
			elseif key == "up" then
				self.text = self.log[#self.log]
			end
			block_keys()
		else
			should_act_keys = true
		end
	end)

	console:add_event("keyreleased", function(self, key)
		if self.node.visible then
			should_act_keys = true
		end
	end)

	--console:add_event("update")

	console:add_event("draw", function(self)
		if self.node.visible then
			love.graphics.setFont(self.font)
			love.graphics.setColor(0.2, 0.2, 0.2, 0.75)
			love.graphics.rectangle("fill", 0, 0, clipx(1), clipy(0.75))
			love.graphics.setColor(1, 1, 1, 1)
			--print(self.text)
			love.graphics.print("> " .. self.text, 0, math.floor(clipy(0.72)))
			local y = 0.68
			for i = #self.log, 1, -1 do
				local v = self.log[i]
				love.graphics.print(v, 0, clipy(y))
				y = y - 0.04
			end
			love.graphics.setFont(self.def_font)
		end
	end)

	return console
end

