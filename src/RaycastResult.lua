RaycastResult = class()
RaycastResult:set("type", "class<raycastresult>")

RaycastResult:set(
    {
        mResult = 0,
        mDidHit = false,
        mHitEntity = 0,
        mHitCoords = Vector3(),
        mSurfaceNormal = Vector3()
    }
)

RaycastResult.Raycast1 = function(source, target, options, ignoreEntity)
    assert(
        (type(source) == "table" and source.type and source.type == "class<vector3>") or type(source) == "vector3",
        "Invalid Vector3 class"
    )
    assert(
        (type(target) == "table" and target.type and target.type == "class<vector3>") or type(target) == "vector3",
        "Invalid Vector3 class"
    )
    assert(
        type(ignoreEntity) == "table" and ignoreEntity.type and ignoreEntity.type == "class<gtaentity>",
        "Invalid GTA ENTITY class"
    )
    return RaycastResult(
        StartExpensiveSynchronousShapeTestLosProbe(source.x, source.y, source.z, target.x, target.y, target.z, options, ignoreEntity:Handle(), 7)
    )
end

RaycastResult.Raycast2 = function(source, direction, maxDistance, options, ignoreEntity)
    assert(
        (type(source) == "table" and source.type and source.type == "class<vector3>") or type(source) == "vector3",
        "Invalid Vector3 class"
    )
    assert(
        (type(direction) == "table" and direction.type and direction.type == "class<vector3>") or type(direction) == "vector3",
        "Invalid Vector3 class"
    )
    assert(
        type(ignoreEntity) == "table" and ignoreEntity.type and ignoreEntity.type == "class<gtaentity>",
        "Invalid GTA ENTITY class"
    )

    local s = source
    if type(source) == "table" then
        s = source:toNative()
    end

    local d = direction
    if type(direction) == "table" then
        t = direction:toNative()
    end

    local target = s + ( d * maxDistance )

    return RaycastResult(
        StartExpensiveSynchronousShapeTestLosProbe(source.x, source.y, source.z, target.x, target.y, target.z, options, ignoreEntity:Handle(), 7)
    )


end

RaycastResult.RaycastCapsule1 = function(source, target, radius, options, ignoreEntity)
    assert(
        (type(source) == "table" and source.type and source.type == "class<vector3>") or type(source) == "vector3",
        "Invalid Vector3 class"
    )
    assert(
        (type(target) == "table" and target.type and target.type == "class<vector3>") or type(target) == "vector3",
        "Invalid Vector3 class"
    )
    assert(
        type(ignoreEntity) == "table" and ignoreEntity.type and ignoreEntity.type == "class<gtaentity>",
        "Invalid GTA ENTITY class"
    )

    return RaycastResult(StartShapeTestCapsule(source.x, source.y, source.z, target.x, target.y, target.z, radius, options, ignoreEntity:Handle(), 7))
end

RaycastResult.RaycastCapsule2 = function(source, direction, maxDistance, radius, options, ignoreEntity)
    assert(
        (type(source) == "table" and source.type and source.type == "class<vector3>") or type(source) == "vector3",
        "Invalid Vector3 class"
    )
    assert(
        (type(target) == "table" and target.type and target.type == "class<vector3>") or type(target) == "vector3",
        "Invalid Vector3 class"
    )
    assert(
        type(ignoreEntity) == "table" and ignoreEntity.type and ignoreEntity.type == "class<gtaentity>",
        "Invalid GTA ENTITY class"
    )

    local s = source
    if type(source) == "table" then
        s = source:toNative()
    end

    local d = direction
    if type(direction) == "table" then
        t = direction:toNative()
    end

    local target = s + ( d * maxDistance )

    return RaycastResult(StartShapeTestCapsule(source.x, source.y, source.z, target.x, target.y, target.z, radius, options, ignoreEntity:Handle(), 7))
end

function RaycastResult:init(...)
    local p = ...
    if not p then
        self.mResult = 0
        self.mDidHit = false
    elseif type(p) == "table" and p.type == "class<raycastresult>" then
        self.mResult = p:Result()
        self.mDidHit = p:DidHitAnything()
        self.mHitEntity = p:HitEntity()
        self.mHitCoords = p:HitCoords()
        self.mSurfaceNormal = p:SurfaceNormal()
    elseif type(p) == "number" then
        local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(p)

        print(retval, hit, endCoords, surfaceNormal, entityHit)

        self.mResult = retval
        self.mDidHit = Vector3(hit)
        self.mHitCoords = Vector3(endCoords)
        self.mSurfaceNormal = Vector3(surfaceNormal)
        if
            DoesEntityExist(entityHit) and
                (IsEntityAPed(entityHit) or IsEntityAVehicle(entityHit) or IsEntityAnObject(entityHit))
         then
            self.mHitEntity = GTAentity(entityHit)
        else
            self.mHitEntity = GTAentity(0)
        end

        print(self.mResult, self.mDidHit, self.mHitCoords, self.mSurfaceNormal, self.mHitEntity)
    end
end

function RaycastResult:Result()
    return self.mResult
end

function RaycastResult:DidHitAnything()
    return self.mDidHit
end

function RaycastResult:HitEntity()
    if self.mHitEntity and type(self.mHitEntity) == "table" and self.mHitEntity.type == "class<gtaentity>" then
        return self.mHitEntity:Handle()
    end
    return self.mHitEntity
end

function RaycastResult:HitCoords()
    return self.mHitCoords
end

function RaycastResult:SurfaceNormal()
    return self.mSurfaceNormal
end
