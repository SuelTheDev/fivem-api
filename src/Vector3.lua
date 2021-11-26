function DegreeToRadian(angle)
	return angle * 0.0174532925199433
end

function RadianToDegree(angle)
	return angle / 0.0174532925199433
end

function get_random_float_in_range(min, max)
    local min = math.ceil(min)
    local max = math.floor(max)
    return math.random() * (max - min + 1) + min
end

function get_random_int_in_range(min, max)
    return math.floor( get_random_float_in_range(min, max))
end

function GetHeadingFromCoords(source, target)
    assert((type(source) == "table" and source.type and source.type == "class<vector3>") or type(source) == "vector3", "Invalid Vector3 class")
    assert((type(target) == "table" and target.type and target.type == "class<vector3>") or type(target) == "vector3", "Invalid Vector3 class")
    return math.atan2((target.y - source.y), (target.x - source.x))
end

Vector3 = class()
Vector3:set("type", "class<vector3>")
Vector3:set("x", 0)
Vector3:set("y", 0)
Vector3:set("z", 0)

function Vector3:init(...)
    local t = ...
    if t then
        if type(x) == "vector3" then
            self.x = t.x
            self.y = t.y
            self.z = t.z
        else
            local t = {...}
            self.x = t[1]
            self.y = t[2]
            self.z = t[3]
        end
    end
end

Vector3.Zero = function()
    return Vector3()
end

Vector3.One = function()
    return Vector3(1,1,1)
end

Vector3.WorldUp = function()
    return Vector3(0,0,1)
end

Vector3.WorldDown = function()
    return Vector3(0,0,-1)
end

Vector3.WorldNorth = function()
    return Vector3(0,1,0)
end

Vector3.WorldSouth = function()
    return Vector3(0,-1,0)
end

Vector3.WorldEast = function()
    return Vector3(1,0,0)
end

Vector3.WorldWest = function()
    return Vector3(-1,0,0)
end

Vector3.RelativeRight = function()
    return Vector3(1,0,0)
end

Vector3.RelativeLeft = function()
    return Vector3(-1,0,0)
end

Vector3.RelativeFront = function()
    return Vector3(0,1,0)
end

Vector3.RelativeBack = function()
    return Vector3(0,-1,0)
end

Vector3.RelativeTop = function()
    return Vector3(0,0,1)
end

Vector3.RelativeBottom = function()
    return Vector3(0,0,-1)
end

function Vector3:Length()
    return math.sqrt( (self.x * self.x) + (self.y * self.y) + (self.z * self.z) )
end

function Vector3:LengthSquared()
    return (self.x * self.x) + (self.y * self.y) + (self.z * self.z)
end

function Vector3:Normalize(vec)
    if not vec then
        local len = self:Length()
        if len == 0 then
            return
        end
        local num = 1.0 / len
        self.x = self.x * num
        self.y = self.y * num
        self.z = self.z * num
    else
        assert(type(vec) == "table" and vec.type and vec.type == "class<vector3>", "Invalid Vector3 class")
        vec:Normalize()
        return vec
    end
end

function Vector3:DistanceTo(vec)
    assert((type(vec) == "table" and vec.type and vec.type == "class<vector3>") or type(vec) == "vector3", "Invalid Vector3 class")
    return Vector3( Vector3.Sub(vec, self) ):Length()
end

function Vector3:Around(distance)
    return Vector3.Add( self, Vector3.Mul( Vector3.RandomXY(), distance ))
end

function Vector3:PointOnCircle(radius, angleInDeg)
    local point = Vector3()
    point.x = radius * math.cos( DegreeToRadian(angleInDeg) ) + self.x
    point.y = radius * math.sin( DegreeToRadian(angleInDeg) ) + self.y
    point.z = self.z
    return point
end

function Vector3:PointsOnCircle(fullRadius, angleDifference, intervalDistance, includeCentre)
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
            local current = Vector3()
            current.x = j * math.cos( DegreeToRadian(i) ) + origin.x
            current.y = j * math.sin( DegreeToRadian(i) ) + origin.y
            table.insert(results, current)
        end
    end
    return results
end

function Vector3:PointOnSphere(radius, longitude, latitude)
    local u = DegreeToRadian(longitude);
	local v = DegreeToRadian(latitude);
	local point = Vector3();
	point.x = radius * math.sin(u) * math.cos(v) + self.x;
	point.y = radius * math.cos(u) * math.cos(v) + self.y;
	point.z = radius * math.sin(v) + self.z;

	return point;
end

function Vector3:IsZero()
    return self.x == 0 and self.y == 0 and self.z == 0
end

Vector3.RandomXY = function()
    local v = Vector3();
	v.x = get_random_float_in_range(0.0, 1.0) - 0.5;
	v.y = get_random_float_in_range(0.0, 1.0) - 0.5;
	v.z = 0.0;
	v.Normalize();
	return v;
end

Vector3.RandomXYZ = function()
    local v = Vector3();
	v.x = get_random_float_in_range(0.0, 1.0) - 0.5;
	v.y = get_random_float_in_range(0.0, 1.0) - 0.5;
	v.z = get_random_float_in_range(0.0, 1.0) - 0.5;
	v.Normalize();
	return v;
end

Vector3.Add = function(left, right)
    assert((type(left) == "table" and left.type and left.type == "class<vector3>") or type(left) == "vector3", "Invalid Vector3 class")
    assert((type(right) == "table" and right.type and right.type == "class<vector3>") or type(right) == "vector3", "Invalid Vector3 class")
    return Vector3(left.x + right.x, left.y + right.y, left.z + right.z)
end

Vector3.Sub = function(a, b)
    assert((type(left) == "table" and left.type and left.type == "class<vector3>") or type(left) == "vector3", "Invalid Vector3 class")
    assert((type(right) == "table" and right.type and right.type == "class<vector3>") or type(right) == "vector3", "Invalid Vector3 class")
    return Vector3(left.x - right.x, left.y - right.y, left.z - right.z)
end

Vector3.Mul = function(left, scalar)
    assert((type(left) == "table" and left.type and left.type == "class<vector3>") or type(left) == "vector3", "Invalid Vector3 class")    
    return Vector3(left.x * scalar, left.y * scalar, left.z * scalar)
end


Vector3.Mod = function(a, b)
    assert((type(left) == "table" and left.type and left.type == "class<vector3>") or type(left) == "vector3", "Invalid Vector3 class")
    assert((type(right) == "table" and right.type and right.type == "class<vector3>") or type(right) == "vector3", "Invalid Vector3 class")
    return Vector3(left.x * right.x, left.y * right.y, left.z * right.z)
end

Vector3.Div = function(left, scalar)
    assert((type(left) == "table" and left.type and left.type == "class<vector3>") or type(left) == "vector3", "Invalid Vector3 class")
    return Vector3(left.x / scalar, left.y / scalar, left.z / scalar)
end

Vector3.DivVec = function(a, b)
    assert((type(left) == "table" and left.type and left.type == "class<vector3>") or type(left) == "vector3", "Invalid Vector3 class")
    assert((type(right) == "table" and right.type and right.type == "class<vector3>") or type(right) == "vector3", "Invalid Vector3 class")
    return Vector3(left.x / right.x, left.y / right.y, left.z / right.z)
end

Vector3.Negate = function(left)
    assert((type(left) == "table" and left.type and left.type == "class<vector3>") or type(left) == "vector3", "Invalid Vector3 class")
    return Vector3(-left.x, -left.y, -left.z)
end

Vector3.Clamp = function(v, min, max)
end

Vector3.Lerp = function(start, _end, amount)
end

Vector3.Dot = function(left, right)
end

Vector3.Cross = function(left, right)
end

Vector3.Reflect = function (v, n)
end

Vector3.Minimize = function(a, b)
end

Vector3.Maximize = function(a, b)
end

function Vector3:Equals(othe)
end

Vector3.Equals = function(a, b)
end

Vector3.DistanceBetween = function(a, b)
end

Vector3.RotationToDirection = function( rotation )
end

Vector3.DirectionToRotation = function(direction)
end


function Vector3:toString()
    return tostring(vector3(self.x, self.y, self.z))
end

function Vector3:clear()
    self.x = 0
    self.y = 0
    self.z = 0
end


