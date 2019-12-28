math.angleBetween2Points = function(a, b)
	--[[var p1 = {
	x: 20,
	y: 20
};

var p2 = {
	x: 40,
	y: 40
};

// angle in radians
var angleRadians = Math.atan2(p2.y - p1.y, p2.x - p1.x);

// angle in degrees
var angleDeg = Math.atan2(p2.y - p1.y, p2.x - p1.x) * 180 / Math.PI;]]

	return math.atan2(b.y - a.y, b.x - a.x)

end

-- Generates an UUID
local random = math.random
function math.uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

math.stack = {}

-- Create a Table with stack functions
function math.stack:Create()

  -- stack table
  local t = {}
  -- entry table
  t._et = {}

  -- push a value on to the stack
  function t:push(...)
    if ... then
      local targs = {...}
      -- add values
      for _,v in ipairs(targs) do
        table.insert(self._et, v)
      end
    end
    return self
  end

  -- pop a value from the stack
  function t:pop(num)

    -- get num values from stack
    local num = num or 1

    -- return table
    local entries = {}

    -- get values into entries
    for i = 1, num do
      -- get last entry
      if #self._et ~= 0 then
        table.insert(entries, self._et[#self._et])
        -- remove last value
        table.remove(self._et)
      else
        break
      end
    end
    -- return unpacked entries
    return unpack(entries)
  end

  -- get entries
  function t:getn()
    return #self._et
  end

  -- list values
  function t:list()
    for i,v in pairs(self._et) do
      print(i, v)
    end
  end

  function t:has()
    return not (#self._et==0)
  end

  -- reverse
  function t:reverse()
  	local i, j = 1, #self._et
	while i < j do
		self._et[i], self._et[j] = self._et[j], self._et[i]
		i = i + 1
		j = j - 1
	end
	return self
  end
  return t
end

-- this file is imported from love2d wiki

function replace_char(pos, str, r)
    return str:sub(1, pos-1) .. r .. str:sub(pos+1)
end



function in_table(t,s)
  for i,v in pairs(t) do
    if (v==s) then 
      return true
    end
  end
end

-- Averages an arbitrary number of angles.
function math.averageAngles(...)
    local x,y = 0,0
    for i=1,select('#',...) do local a= select(i,...) x, y = x+math.cos(a), y+math.sin(a) end
    return math.atan2(y, x)
end


-- Returns the distance between two points.
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
-- Distance between two 3D points:
--function math.dist(x1,y1,z1, x2,y2,z2) return ((x2-x1)^2+(y2-y1)^2+(z2-z1)^2)^0.5 end


-- Returns the angle between two points.
function math.getAngle(x1,y1, x2,y2) return math.atan2(x2-x1, y2-y1) end


-- Returns the closest multiple of 'size' (defaulting to 10).
function math.multiple(n, size) size = size or 10 return math.round(n/size)*size end


-- Clamps a number to within a certain range.
function math.clamp(low, n, high) return math.min(math.max(n, low), high) end


-- Normalizes two numbers.
function math.normalize(x,y) local l=(x*x+y*y)^.5 if l==0 then return 0,0,0 else return x/l,y/l,l end end
-- Normalizes a table of numbers.
--function math.normalize(t) local n,m = #t,0 for i=1,n do m=m+t[i] end m=1/m for i=1,n do t[i]=t[i]*m end return t end


-- Returns 'n' rounded to the nearest 'deci'th.
function math.round(n, deci) deci = 10^(deci or 0) return math.floor(n*deci+.5)/deci end

-- Special not-decimal round
function math.sround(n, deci) return math.floor(n*deci+.5)/deci end


-- Randomly returns either -1 or 1.
function math.rsign() return math.random(2) == 2 and 1 or -1 end

-- Randomly return a boolean value
function math.rbool() return math.round(math.random()) == 0 end


-- Returns 1 if number is positive, -1 if it's negative, or 0 if it's 0.
function math.sign(n) return n>0 and 1 or n<0 and -1 or 0 end

-- Checks if two line segments intersect. Line segments are given in form of ({x,y},{x,y}, {x,y},{x,y}).
function checkIntersect(l1p1, l1p2, l2p1, l2p2)
    local function checkDir(pt1, pt2, pt3) return math.sign(((pt2.x-pt1.x)*(pt3.y-pt1.y)) - ((pt3.x-pt1.x)*(pt2.y-pt1.y))) end
    return (checkDir(l1p1,l1p2,l2p1) ~= checkDir(l1p1,l1p2,l2p2)) and (checkDir(l2p1,l2p2,l1p1) ~= checkDir(l2p1,l2p2,l1p2))
end

-- Fixes 2 values that make a diagonal vector into a random non-diagonal vector
function math.fixDiag(x, y) 
  if math.rbool() then return x,0 else return 0,y end
end

-- Collision detection function.
-- Checks if box1 and box2 overlap.
-- w and h mean width and height.
function CheckCollision(box1x, box1y, box1w, box1h, box2x, box2y, box2w, box2h)
    if box1x > box2x + box2w - 1 or -- Is box1 on the right side of box2?
       box1y > box2y + box2h - 1 or -- Is box1 under box2?
       box2x > box1x + box1w - 1 or -- Is box2 on the right side of box1?
       box2y > box1y + box1h - 1    -- Is b2 under b1?
    then
        return false                -- No collision. Yay!
    else
        return true                 -- Yes collision. Ouch!
    end
end

-- Some algorithm implementations
-- bresenham lines algorithm 
function getPointsFromLine(x0, y0, x1, y1)
  local points = {}
  local dx, dy = math.abs(x1-x0), math.abs(y1-y0)
  local err = dx - dy
  local sx, sy= (x0 < x1) and 1 or -1, (y0 < y1) and 1 or -1

  while true do
    points[#points + 1] = {x = x0, y = y0}
    if x0 == x1 and y0 == y1 then break end
    local e2 = 2 * err
    if e2 > -dy then
      err = err - dy
      x0 = x0 + sx
    end
    if e2 < dx then
      err = err + dx
      y0 = y0 + sy
    end
  end
  return points
end

function table.copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[table.copy(k, s)] = table.copy(v, s) end
  return res
end

function table.is_empty(t)
  return next(t) == nil
end

function math.point(point, box) return ((point.x > box.x) and (point.x < box.x + box.w)) and ((point.y > box.y) and (point.y < box.y + box.h)) end
function math.boverlap(b1, b2)
  return b1.x < b2.x+b2.w and
         b2.x < b1.x+b1.w and
         b1.y < b2.y+b2.h and
         b2.y < b1.y+b1.h
end

function Set (list)
  local set = {}
  for i, l in ipairs(list) do 
    set[l] = i 
  end
  return set
end