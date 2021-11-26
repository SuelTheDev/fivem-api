Vector2 = class()
Vector2:set("type", "class<vector2>")
Vector2:set("x", 0)
Vector2:set("y", 0)



function Vector2:init(...)
    local t = ...
    if t then
        if type(x) == "vector2" then
            self.x = t.x
            self.y = t.y
        else
            local t = {...}
            self.x = t[1]
            self.y = t[2]
        end
    end
end

Vector2.Zero = function()
    return Vector2()
end

Vector2.One = function()
    return Vector2(1,1)
end

Vector2.Up = function()
    return Vector2(0.0, 1.0)
end

Vector2.Down = function()
    return Vector2(0,-1.0)
end

Vector2.Left = function()
    return Vector2(-1.0,0.0)
end

Vector2.Right = function()
    return Vector2(1.0,0.0)
end


function Vector2:Length()
    return math.sqrt( (self.x * self.x) + (self.y * self.y) )
end

function Vector2:PointOnCircle(radius, angleInDeg)
    local point = Vector2()
    point.x = radius * math.cos( DegreeToRadian(angleInDeg) ) + self.x
    point.y = radius * math.sin( DegreeToRadian(angleInDeg) ) + self.y
    return point
end


function Vector2:PointsOnCircle(fullRadius, angleDifference, intervalDistance, includeCentre)
    local origin = self
    local u, d = 0.0, 0.0
    local results = {}
    if includeCentre then
        table.insert(results, origin)        
    end

    if intervalDistance == 0.0 then
        return
    end

    for i = 0.0, 360.0, angleDifference do
        for j = intervalDistance, fullRadius, intervalDistance do
            local current = Vector2()
            current.x = j * math.cos( DegreeToRadian(i) ) + origin.x
            current.y = j * math.sin( DegreeToRadian(i) ) + origin.y
            table.insert(results, current)
        end
    end
    return results
end

function Vector2:LengthSquared()
    return (self.x * self.x) + (self.y * self.y)
end

function Vector2:Normalize(vec)
    if not vec then
        local len = self:Length()
        if len == 0 then
            return
        end
        local num = 1.0 / len
        self.x = self.x * num
        self.y = self.y * num       
    else
        assert(type(vec) == "table" and vec.type and vec.type == "class<vector2>", "Invalid Vector2 class")
        vec:Normalize()
        return vec
    end
end

function Vector2:DistanceTo(vec)
    assert((type(vec) == "table" and vec.type and vec.type == "class<vector2>") or type(vec) == "vector2", "Invalid Vector2 class")
    return Vector2( Vector2.Sub(vec, self) ):Length()
end

function Vector2:Around(distance)
    return Vector2.Add( self, Vector2.Mul( Vector2.RandomXY(), distance ))
end


function Vector2:IsZero()
    return self.x == 0 and self.y == 0
end

Vector2.RandomXY = function()
    local v = Vector2();
	v.x = get_random_float_in_range(0.0, 1.0) - 0.5;
	v.y = get_random_float_in_range(0.0, 1.0) - 0.5;
	v:Normalize();
	return v;
end

Vector2.Add = function(left, right)
    assert((type(left) == "table" and left.type and left.type == "class<vector2>") or type(left) == "vector2", "Invalid Vector2 class")
    assert((type(right) == "table" and right.type and right.type == "class<vector2>") or type(right) == "vector2", "Invalid Vector2 class")
    return Vector2(left.x + right.x, left.y + right.y)
end

Vector2.Sub = function(left, right)
    assert((type(left) == "table" and left.type and left.type == "class<vector2>") or type(left) == "vector2", "Invalid Vector2 class")
    assert((type(right) == "table" and right.type and right.type == "class<vector2>") or type(right) == "vector2", "Invalid Vector2 class")
    return Vector2(left.x - right.x, left.y - right.y)
end

Vector2.Mul = function(left, scalar)
    assert((type(left) == "table" and left.type and left.type == "class<vector2>") or type(left) == "vector2", "Invalid Vector2 class")    
    return Vector2(left.x * scalar, left.y * scalar)
end

Vector2.Mod = function(left, right)
    assert((type(left) == "table" and left.type and left.type == "class<vector2>") or type(left) == "vector2", "Invalid Vector2 class")
    assert((type(right) == "table" and right.type and right.type == "class<vector2>") or type(right) == "vector2", "Invalid Vector2 class")
    return Vector2(left.x * right.x, left.y * right.y)
end

Vector2.Div = function(left, scalar)
    assert((type(left) == "table" and left.type and left.type == "class<vector2>") or type(left) == "vector2", "Invalid Vector2 class")
    return Vector2(left.x / scalar, left.y / scalar)
end

Vector2.DivVec = function(left, right)
    assert((type(left) == "table" and left.type and left.type == "class<vector2>") or type(left) == "vector2", "Invalid Vector2 class")
    assert((type(right) == "table" and right.type and right.type == "class<vector2>") or type(right) == "vector2", "Invalid Vector2 class")
    return Vector2(left.x / right.x, left.y / right.y)
end

Vector2.Negate = function(left)
    assert((type(left) == "table" and left.type and left.type == "class<vector2>") or type(left) == "vector2", "Invalid Vector2 class")
    return Vector2(-left.x, -left.y)
end

Vector2.Clamp = function(vec, min, max)
    assert((type(vec) == "table" and vec.type and vec.type == "class<vector2>") or type(vec) == "vector2", "Invalid Vector2 class")
    local x = vec.x
    x = (x > max.x) and max.x or x
    x = (x < min.x) and min.x or x

    local y = vec.y
    y = (y > may.y) and may.y or y
    y = (y < min.y) and min.y or y

    return Vector2(x, y)
end

Vector2.Lerp = function(start, _end, amount)
    assert((type(start) == "table" and start.type and start.type == "class<vector2>") or type(start) == "vector2", "Invalid Vector2 class")
    assert((type(_end) == "table" and _end.type and _end.type == "class<vector2>") or type(_end) == "vector2", "Invalid Vector2 class")
	local x = start.x + ((_end.x - start.x) * amount);
	local y = start.y + ((_end.y - start.y) * amount);
	return Vector2(x, y)
end

Vector2.Dot = function(left, right)
    assert((type(left) == "table" and left.type and left.type == "class<vector2>") or type(left) == "vector2", "Invalid Vector2 class")
    assert((type(right) == "table" and right.type and right.type == "class<vector2>") or type(right) == "vector2", "Invalid Vector2 class")
    return (left.x * right.x + left.y * right.y)
end

Vector2.Cross = function(left, right)
    assert((type(left) == "table" and left.type and left.type == "class<vector2>") or type(left) == "vector2", "Invalid Vector2 class")
    assert((type(right) == "table" and right.type and right.type == "class<vector2>") or type(right) == "vector2", "Invalid Vector2 class")
    local x = left.y * right.z - left.z * right.y
	local y = left.x * right.y - left.y * right.x
	return Vector2(x, y);
end

Vector2.Reflect = function (vector, normal)
    assert((type(vector) == "table" and vector.type and vector.type == "class<vector2>") or type(vector) == "vector2", "Invalid Vector2 class")
    assert((type(normal) == "table" and normal.type and normal.type == "class<vector2>") or type(normal) == "vector2", "Invalid Vector2 class")
    local dot = ( ( vector.x * normal.x ) +  ( vector.y * normal.y ) +  ( vector.z * normal.z ) )
    local x = vector.x - ((2.0 * dot) * normal.x)
	local y = vector.y - ((2.0 * dot) * normal.y)
    return Vector2(x, y);
end

Vector2.Minimize = function(a, b)
    assert((type(a) == "table" and a.type and a.type == "class<vector2>") or type(a) == "vector2", "Invalid Vector2 class")
    assert((type(b) == "table" and b.type and b.type == "class<vector2>") or type(b) == "vector2", "Invalid Vector2 class")
    local x = (a.x < b.x) and a.x or b.x
    local y = (a.y < b.y) and a.y or b.y
    return Vector2(x, y)
end

Vector2.Maximize = function(a, b)
    assert((type(a) == "table" and a.type and a.type == "class<vector2>") or type(a) == "vector2", "Invalid Vector2 class")
    assert((type(b) == "table" and b.type and b.type == "class<vector2>") or type(b) == "vector2", "Invalid Vector2 class")
    local x = (a.x > b.x) and a.x or b.x
    local y = (a.y > b.y) and a.y or b.y
    return Vector2(x, y)
end

function Vector2:Equals(a)
    assert((type(a) == "table" and a.type and a.type == "class<vector2>") or type(a) == "vector2", "Invalid Vector2 class")
    return (self.x == a.x) and (self.y == a.y)
end

Vector2.Equals = function(a, b)
    assert((type(a) == "table" and a.type and a.type == "class<vector2>") or type(a) == "vector2", "Invalid Vector2 class")
    assert((type(b) == "table" and b.type and b.type == "class<vector2>") or type(b) == "vector2", "Invalid Vector2 class")
    return (b.x == a.x) and (b.y == a.y)
end

Vector2.DistanceBetween = function(a, b)  
    assert((type(a) == "table" and a.type and a.type == "class<vector2>") or type(a) == "vector2", "Invalid Vector2 class")
    assert((type(b) == "table" and b.type and b.type == "class<vector2>") or type(b) == "vector2", "Invalid Vector2 class")
    return Vector2.Sub(a, b):Length()
end

function Vector2:toString()
    return tostring(Vector2(self.x, self.y))
end

function Vector2:clear()
    self.x = 0
    self.y = 0
end