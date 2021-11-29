Camera = class()

Camera.D2R = 0.01745329251994329576923690768489

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
    assert(
        (type(worldCoords) == "table" and worldCoords.type and worldCoords.type == "class<vector3>") or
            type(worldCoords) == "vector3",
        "Invalid Vector3 class"
    )
    local ret, screenX, screenY = GetScreenCoordFromWorldCoord(worldCoords.x, worldCoords.y, worldCoords.z)
    if ret then
        return true, Vector2((screenX - 0.5) * 2.0, (screenY - 0.5) * 2.0)
    end
    return false, Vector2()
end

Camera:set("type", "class<camera>")
Camera:set("mHandle", 0)
Camera:set("mShakeAmplitude", 0.0)
Camera:set("mShakeType", Camera.CameraShake.Hand)

function Camera:getHandle()
    return self.mHandle
end

function Camera:init(handle)
    self.mHandle = handle
    self.mShakeAmplitude = 0
    self.mShakeType = Camera.CameraShake.Hand
end

function Camera:setDepthOfFieldStrength(value)
    SetCamDofStrength(self.mHandle, value)
end

function Camera:getFieldOfView()
    return GetCamFov(self.mHandle)
end

function Camera:setFieldOfView(value)
    SetCamFov(self.mHandle, value)
end

function Camera:getFarClip()
    return GetCamFarClip(self.mHandle)
end

function Camera:setFarClip(value)
    SetCamFarClip(self.mHandle, value)
end

function Camera:getFarDepthOfField()
    return getFarDepthOfField(self.mHandle)
end

function Camera:setFarDepthOfField(value)
    setFarDepthOfField(self.mHandle, value)
end

function Camera:getNearClip()
    return GetCamNearClip(self.mHandle)
end

function Camera:setNearClip(value)
    SetCamNearClip(self.mHandle, value)
end

function Camera:setNearDepthOfField(value)
    SetCamNearDof(self.mHandle, value)
end

function Camera:IsActive()
    return IsCamActive(self.mHandle) ~= 0
end

function Camera:SetActive(Value)
    SetCamActive(self.mHandle, value)
end

function Camera:IsInterpolating()
    return IsCamInterpolating(self.mHandle) ~= 0
end

function Camera:IsShaking()
    return IsCamShaking(self.mHandle) ~= 0
end

function Camera:setShake(status)
    if status then
        ShakeCam(self.mHandle, Camera.CameraShakeNames[self.mShakeType], self.mShakeAmplitude)
    else
        StopCamShaking(self.mHandle, true)
    end
end

function Camera:setMotionBlurStrength(value)
    SetCamMotionBlurStrength(self.mHandle, value)
end

function Camera:getPosition()
    local x, y, z = table.unpack(GetCamCoord(self.mHandle))
    return Vector3(x, y, z)
end

function Camera:setPosition(...)
    local vec = ...
    assert(
        (type(vec) == "table" and vec.type and vec.type == "class<vector3>") or type(vec) == "vector3",
        "Invalid Vector3 class"
    )
    SetCamCoord(self.mHandle, vec.x, vec.y, vec.z)
end

function Camera:getRotation(unk)
    local x, y, z = table.unpack(GetCamRot(self.mHandle, unk or 2))
    return Vector3(x, y, z)
end

function Camera:setRotation(...)
    local vec = ...
    assert(
        (type(vec) == "table" and vec.type and vec.type == "class<vector3>") or type(vec) == "vector3",
        "Invalid Vector3 class"
    )
    SetCamRot(self.mHandle, vec.x, vec.y, vec.z, 2)
end

function Camera:getDirection()
    return Vector3.RotationToDirection(GetCamRot(self.mHandle, 2))
end

function Camera:setDirection(...)
    local vec = ...
    assert(
        (type(vec) == "table" and vec.type and vec.type == "class<vector3>") or type(vec) == "vector3",
        "Invalid Vector3 class"
    )
    local dir = Vector3.DirectionToRotation(vec)
    SetCamRot(self.mHandle, dir.x, dir.y, dir.z, 2)
end

function Camera:getHeading()
    return GetCamRot(self.mHandle, 2).z
end

function Camera:setHeading(value)
    local oldRot = self:getRotation()
    SetCamRot(self.mHandle, oldRot.x, oldRot.y, value, 2)
end

function Camera:GetOffsetInWorldCoords(offset)
    assert(
        (type(offset) == "table" and offset.type and offset.type == "class<vector3>") or type(offset) == "vector3",
        "Invalid Vector3 class"
    )
    local rotation = self:getRotation()
    local forward = Vector3.RotationToDirection(rotation)
    local D2R = Camera.D2R
    local num1 = math.cos(rotation.x * D2R)
    local x = num1 * math.cos(-rotation.z * D2R)
    local y = num1 * math.sin(rotation.z * D2R)
    local z = math.sin(-rotation.y * D2R)
    local right = Vector3(x, y, z)
    local up = Vector3.Cross(right, forward)
    local rx = Vector3.Mul(right, offset.x)
    local ry = Vector3.Mul(forward, offset.y)
    local rz = Vector3.Mul(up, offset.z)
    local r1 = Vector3.Add(self:getPosition(), rx)
    local r2 = Vector3.Add(r1, ry)
    return Vector3.Add(r2, rz)
end

function Camera:GetOffsetGivenWorldCoords(worldCoords)
    assert(
        (type(offset) == "table" and offset.type and offset.type == "class<vector3>") or type(offset) == "vector3",
        "Invalid Vector3 class"
    )
    local rotation = self:getRotation()
    local forward = Vector3.RotationToDirection(rotation)
    local D2R = Camera.D2R
    local num1 = math.cos(rotation.x * D2R)
    local x = num1 * math.cos(-rotation.z * D2R)
    local y = num1 * math.sin(rotation.z * D2R)
    local z = math.sin(-rotation.y * D2R)
    local right = Vector3(x, y, z)
    local up = Vector3.Cross(right, forward)
    local delta = Vector3.Sub(worldCoords, self:getPosition())
    local xr = Vector.Dot(right, delta)
    local yr = Vector3.Dot(forward, delta)
    local zr = Vector3.Dot(up, delta)
    return Vector3(xr, yr, zr)
end

function Camera:getShakeAmplitude()
    return self.mShakeAmplitude
end

function Camera:setShakeAmplitude(value)
    self.mShakeAmplitude = value
    SetCamShakeAmplitude(self.mHandle, value)
end

function Camera:getShakeType()
    return self.mShakeType
end

function Camera:setShakeType(value)
    self.mShakeType = value
    if self:IsShaking() then
        ShakeCam(self.mHandle, Camera.CameraShakeNames[self.mShakeType], self.mShakeAmplitude)
    end
end

function Camera:AttachToEntity(entity, offset)
    AttachCamToEntity(self.mHandle, entity, offset.x, offset.y, offset.y, true)
end

function Camera:AttachToPedBone(ped, boneIndex, offset)
    AttachCamToPedBone(self.mHandle, ped, boneIndex, offset.x, offset.y, offset.z, true)
end

function Camera:Detach()
    DetachCam(self.mHandle)
end

function Camera:InterpTo(to, duration, easePosition, easeRotation)
    assert(
        (type(to) == "table" and to.type and to.type == "class<camera>") or type(to) == "vector3",
        "Invalid Vector3 class"
    )
    SetCamActiveWithInterp(to:getHandle(), self:getHandle(), duration, easePosition, easeRotation)
end

function Camera:PointAtCoord(target)
    assert(
        (type(target) == "table" and target.type and target.type == "class<vector3>") or type(target) == "vector3",
        "Invalid Vector3 class"
    )
    PointCamAtCoord(self.mHandle, target.x + 0.0001, target.y + 0.0001, target.z + 0.0001)
end

function Camera:PointAtEntity(target, offset)
    assert(
        (type(offset) == "table" and offset.type and offset.type == "class<vector3>") or type(offset) == "vector3",
        "Invalid Vector3 class"
    )
    local handle = 0
    if target and type(target) == "table" and target.type and target.type == "class<entity>" then
        handle = target:getHandle()
    else
        if target and type(target) == "number" and tonumber(target) > 0 then
            handle = target
        end
    end
    if handle > 0 then
        PointCamAtEntity(self.mHandle, handle, offset.x + 0.0001, offset.y + 0.0001, offset.z + 0.0001, true)
    end
end

function Camera:PointAtPedBone(target, boneIndex, offset)
    if offset then
        assert(
            (type(offset) == "table" and offset.type and offset.type == "class<vector3>") or type(offset) == "vector3",
            "Invalid Vector3 class"
        )
    else
        offset = Vector3()
    end
    if target and type(target) == "table" and target.type and target.type == "class<ped>" then
        handle = target:getHandle()
    else
        if target and type(target) == "number" and tonumber(target) > 0 then
            handle = target
        end
    end
    if handle > 0 then
        PointCamAtPedBone(
            self.mHandle,
            handle,
            boneIndex,
            offset.x + 0.0001,
            offset.y + 0.0001,
            offset.z + 0.0001,
            true
        )
    end
end

function Camera:StopPointing()
    StopCamPointing(self.mHandle)
end

function Camera:Exists()
    return DoesCamExist(self.mHandle) ~= 0
end

function Camera:Destroy()
    DestroyCam(self.mHandle, false)
end

Camera.DestroyAllCameras = function()
    DestroyAllCams(0)
end

function Camera:ScreenToWorld(screenCoord)
    assert(
        (type(screenCoord) == "table" and screenCoord.type and screenCoord.type == "class<vector2>") or
            type(screenCoord) == "vector2",
        "Invalid Vector2 class"
    )
    local camRot = self:getRotation():toNative()
    local camPos = self:getPosition():toNative()
    local direction = Vector3.RotationToDirection(camRot):toNative()
    local v3 = camRot + vector3(10.0, 0.0, 0.0)
    local v31 = camRot + vector3(-10.0, 0.0, 0.0)
    local v32 = camRot + vector3(0.0, 0.0, -10.0)
    local direction1 =
        Vector3.RotationToDirection(camRot + vector3(0.0, 0.0, 10.0)):toNative() -
        Vector3.RotationToDirection(v32):toNative()
    local direction2 = Vector3.RotationToDirection(v3):toNative() - Vector3.RotationToDirection(v31):toNative()
    local rad = -DegreeToRadian(camRot.y)
    local v33 = (direction1 * math.cos(rad)) - (direction2 * math.sin(rad))
    local v34 = (direction1 * math.sin(rad)) + (direction2 * math.cos(rad))
    
    local ret, v2 = Camera.WorldToScreenRel(((camPos + (direction * 10.0)) + v33) + v34)
    if not ret then
        return Vector3(camPos + (direction * 10.0))
    end
    
    ret, v21 = Camera.WorldToScreenRel(camPos + (direction * 10.0))
    if not ret then
        return Vector3(camPos + (direction * 10.0))
    end
    
    if math.abs( v2.x - v21.x ) < 0.001 or math.abs(v2.y - v21.y) < 0.001 then
        return Vector3( camPos + ( direction * 10.0 ) )
    end

    local x = (screenCoord.x - v21.x) / ( v2.x - v21.x )
    local y = (screenCoord.y - v21.y) / (v2.y - v21.y)
    return Vector3( ((camPos + (direction * 10.0)) + (v33 * x)) + (v34 * y) )
end

function Camera:RaycastForEntity(screenCoord, ignoreEntity, maxDistance)
    local world = self:ScreenToWorld(screenCoord)
    local v3 = self:getPosition()
    local v31 = Vector3(world:toNative() - v3:toNative())
    v31:Normalize()
    local raycastResult =
        RaycastResult.Raycast(
        v3:toNative() + (v32:toNative() * 1.0),
        v3:toNative() + (v31:toNative() * maxDistance),
        IntersectOptions(287),
        ignoreEntity
    )
    return raycastResult:DidHitEntity() and raycastResult:HitEntity() or 0
end

function Camera:RaycastForCoord(screenCoord, ignoreEntity, maxDistance, failDistance)
    local position = self:getPosition():toNative()
    local world = self:ScreenToWorld(screenCoord):toNative()
    local v3 = position
    local v31 = Vector3(world - v3)
    v31:Normalize()
    local raycastResult = RaycastResult.Raycast(v3 + (v31 * 1.0), v3 + (v31 * maxDistance), 287, ignoreEntity)
    return raycastResult:DidHitAnything() and raycastResult:HitCoords() or (position + (v3 + failDistance))
end

function Camera:getDirectionFromScreenCentre()
    local position = self:getPosition():toNative()
    local world = self:ScreenToWorld(Vector2()):toNative()      
    return Vector3.Normalize2(Vector3(world - position))
end

Camera.RenderScriptCams = function(render)
    RenderScriptCams(render, 0, 3000, 1, 0)
end

function get_coords_from_cam(camid, distance)
    local rx, ry, rz = table.unpack(DegreeToRadian(GetCamRot(camid, 2)))
    local Coord = GetCamCoord(camid)
    ry = distance * math.cos(rx)
    cx = Coord.x + ry + math.sin(rz * -1.0)
    cy = Coord.y + ry + math.cos(rz * -1.0)
    cz = Coord.z + distance * math.sin(rz)
    return Vector3(cx, cy, cz)
end
