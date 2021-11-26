RaycastResult = class()

RaycastResult:set {
    type = "class<raycast_result>",
    mResult = 0,
    mDidHit = false,
    mHitEntity = nil,
    mHitCoords = nil,
    mSurfaceNormal = nil
}

function RaycastResult:init(handle)
    self.mResult, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(handle)
    if DoesEntityExist(entityHit) then
        self.mHitEntity = entityHit
    else
        self.mHitEntity = 0
    end
end

function RaycastResult:Result()
    return self.mResult
end

function RaycastResult:DidHitEntity()
    return mHitEntity:getHandle() ~= 0
end

function RaycastResult:DidHitAnything()
    return self.mDidHit
end

function RaycastResult:HitEntity()
    return self.mHitEntity
end

function RaycastResult:HitCoords()
    return self.mHitCoords
end

function RaycastResult:SurfaceNormal()
    return self.mSurfaceNormal
end

RaycastResult.Raycast = function(source, target, options, ignoreEntity)
    local ret =
        StartExpensiveSynchronousShapeTestLosProbe(
        source.x,
        source.y,
        source.z,
        target.x,
        target.y,
        target.z,
        options,
        ignoreEntity.getHandle(),
        7
    )
    return RaycastResult(ret)
end

RaycastResult.Raycast2 = function(source, direction, maxDistance, options, ignoreEntity)
    local target = Vector3(source + (direction * maxDistance))
    local ret =
        StartExpensiveSynchronousShapeTestLosProbe(
        source.x,
        source.y,
        source.z,
        target.x,
        target.y,
        target.z,
        options,
        ignoreEntity.getHandle(),
        7
    )
    return RaycastResult(ret)
end

RaycastResult.RaycastCapsule = function(source, target, radius, options, ignoreEntity)
    local ret =
        StartShapeTestCapsule(
        source.x,
        source.y,
        source.z,
        target.x,
        target.y,
        target.z,
        radius,
        options,
        ignoreEntity.getHandle(),
        7
    )
    return RaycastResult(ret)
end

RaycastResult.RaycastCapsule2 = function(source, direction, maxDistance, radius, options, ignoreEntity)
    local target = Vector3(source + (direction * maxDistance))
    local ret =
        StartShapeTestCapsule(
        source.x,
        source.y,
        source.z,
        target.x,
        target.y,
        target.z,
        radius,
        options,
        ignoreEntity.getHandle(),
        7
    )
    return RaycastResult(ret)
end
