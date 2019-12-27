
local inventory = scene()

inventory:add(
	gui_button()
)

game_states:push(
	{
		update = function(self, dt)
			print("AYO")
			block_update()
		end
	}
)

function love.load()

end

function love.update(dt)
	game_states:update(dt)
end

function love.draw()

end

function love.keypressed(key)

end

function love.keyreleased(key)

end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

end