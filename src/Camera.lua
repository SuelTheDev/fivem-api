Camera = class()

Camera.CameraShake = {
    Hand = 0,
    SmallExplosion = 1,
    MediumExplosion = 2,
    LargeExplosion = 3,
    Jolt = 4,
    Vibrate = 5,
    RoadVibration = 6,
    Drunk = 7,
    SkyDiving = 8,
    FamilyDrugTrip = 9,
    DeathFail = 10
}

Camera.CameraShakeNames = {
    [0] = "HAND_SHAKE",
    [1] = "SMALL_EXPLOSION_SHAKE",
    [2] = "MEDIUM_EXPLOSION_SHAKE",
    [3] = "LARGE_EXPLOSION_SHAKE",
    [4] = "JOLT_SHAKE",
    [5] = "VIBRATE_SHAKE",
    [6] = "ROAD_VIBRATION_SHAKE",
    [7] = "DRUNK_SHAKE",
    [8] = "SKY_DIVING_SHAKE",
    [9] = "FAMILY5_DRUG_TRIP_SHAKE",
    [10] = "DEATH_FAIL_IN_EFFECT_SHAKE"
}


Camera.WorldToScreenRel = function(worldCoords)    
    assert((type(worldCoords) == "table" and worldCoords.type and worldCoords.type == "class<vector3>") or type(worldCoords) == "vector3", "Invalid Vector3 class")
    local ret, screenX, screenY = GetScreenCoordFromWorldCoord(worldCoords.x, worldCoords.y, worldCoords.z)
    if ret then
        return true, Vector2( (screenX - 0.5) * 2.0, (screenY - 0.5) * 2.0 )
    end
    return false
end

Camera:set("type", "class<camera>")
Camera:set("mHandle", 0)
Camera:set("mShakeAmplitude", 0.0)
Camera:set("mShakeType", Camera.CameraShake.Hand)



function get_coords_from_cam(camid, distance)
    local rx, ry, rz = table.unpack(DegreeToRadian(GetCamRot(camid, 2)))
    local Coord = GetCamCoord(camid)
    ry = distance * math.cos(rx)

    cx = Coord.x + ry + math.sin(rz * -1.0)
    cy = Coord.y + ry + math.cos(rz * -1.0)
    cz = Coord.z + distance * math.sin(rz)

    return Vector3(cx, cy, cz)
end
