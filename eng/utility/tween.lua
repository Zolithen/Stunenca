
--[[local easing = {
	quad_in = function(v)
		return v*v
	end
}

active_tweens = {}
local tt = {}

function tween(t, from, to, duration)
	local t = {
		t = new_timer_after(duration, function() end),
		from = from,
		to = to,
		duration = duration
	}

	setmetatable(t, {__index = tt});

	table.insert(active_tweens, t);

	return t;
end

function update_tweens(dt)
	for i, v in pairs(active_tweens) do
		v.t:update(dt)
	end
end]]

--[[
	Math.linearTween = function (t, b, c, d) {
	return c*t/d + b;
};

t: time passed
d: duration
c: change in value
b: starting value
]]

flux = require "eng/utility/flux"

function new_tween_controller(s)
	local tc = new_node(s, "tweens");

	tc.tweens = {}

	tc.update = function(self, dt)
		--[[for i, v in pairs(tc.tweens) do
			v:update(dt);
		end]]
		flux.update(dt);
	end

	--setmetatable(tc, {__index = tm});

	return tc;
end