RegisterCommand(
    "tapi",
    function(s, a, r)
        local x = RaycastResult.RaycastCapsule1(
            vector3(306.03, -590.14, 43.32), 
            vector3(316.54, -588.4, 43.3), 
            50.0, 
            -1, 
            GTAentity()
        )
        print(x:HitEntity())
    end
)
