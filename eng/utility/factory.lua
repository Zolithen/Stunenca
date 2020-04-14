-- Factories are used for instantiating nodes in bulk from data tables
--[[local ft = {}

function ft:generate(data)
	local l = {}
	for i, v in pairs(self.consumer) do
		local n = i
	end
	for i, v in pairs(data) do
		if self.dict[v.factory_type] then
			local cons = self.dict[v.factory_type];

		end
	end
	return l;
end

function new_factory(dict, consumer)
	local f = {
		dict = dict,
		consumer = consumer
	}

	local fcons = {}
	for i, v in pairs(consumer) do
		local n = i;
		for index, data in pairs(v.provided) do

		end
	end

	f.final_consumer = fcons;

	setmetatable(f, {__index = ft})

	return f
end]]

--[[
	consumer -> set of functions that take the needed arguments and maps them
	to the dict function in conjuction with the provided arguments
]]

--[[
	local f = new_factory(
		{
			line = new_line_collider,
			circle = new_circle_collider,
			rect = new_rectangle_collider
		},
		{
			line = {
				provided = {
					1 = scene,
					2 = world
				},
				needed = {
					3 = "x1",
					4 = "y1",
					5 = "x2",
					6 = "y2"
				}

			}
			circle = {
				provided = {
					1 = scene,
					2 = world
				},
				needed = {
					3 = "x",
					4 = "y",
					5 = "r"
				}
			},
			rect = {
				provided = {
					1 = scene,
					2 = world
				},
				needed = {
					3 = "x",
					4 = "y",
					5 = "w",
					6 = "h"
				}
			}

		}
	);

	local n = f:generate(persistence.load("map.map"));
]]

--[[local ft = {}

function new_factory()

end]]