
function new_gui_button(name, func)
	local button = new_game_node(name)

	

	button:add_event("mousepressed", function(self, x, y, button)

	end)

	return button
end