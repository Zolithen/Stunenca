
scene = new_node(nil, "root")

--local las = new_layered_sprite(scene, "assets/colored_tilemap.png", 0, 0, 8, 8, 10, 10, 1, 1);
local las = new_layered_sprite(scene, "assets/layered.png", 0, 0, 8, 8, 2, 1, 0, 0);
las.x = 128
las.y = 128

local sprs = new_sprite_sheet(scene, "assets/layered.png", {
	{
		x=0, --starting x
		y=0, --starting y
		qx=0, --space between quads horizontally
		qy=0, --space between quads vertically
		qw=8, --width of every quad
		qh=8, --height of every quad
		ax=2, --amount of quads horizontally
		ay=1, --amount of quads vertically
		index={ --way to "call" created quads
			{ 
				type="animation",
				name="idle",
				speed = 1,
				quads={1,2}	
			},
			{
				type="frame",
				name="test",
				quad=2
			}
		}
	}
});

local n = new_node(scene, "player");
n.draw = function(self)
	love.graphics.draw(sprs.sheet, sprs:get_quad("test"),0, 0);
end

--[[
n.quads = {}
	n.index_data = {}
]]

--table.insert(las.layers[1].effects, new_graphical_effect("color", {1,1,1,0.5}))
--table.insert(las.layers[1].effects, new_graphical_effect("rotate", 1))
table.insert(las.layers[1].effects, new_graphical_effect("scale", {16, 16}))
table.insert(las.layers[2].effects, new_graphical_effect("scale", {16, 16}))
table.insert(las.layers[2].effects, new_graphical_effect("translate", {16, 0}))
--table.insert(las.layers[2].effects, new_graphical_effect("color", {0, 0, 0, 0}))

--[[function love.draw()
	scene:propagate_event("draw");
end]]

--[[function love.draw()
	love.graphics.translate(100, 100)
	local t = love.timer.getTime()
	love.graphics.shear(math.cos(t), math.cos(t * 1.3))
	love.graphics.rectangle('fill', 0, 0, 100, 50)
end]]