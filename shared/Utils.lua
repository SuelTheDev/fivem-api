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