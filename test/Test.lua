RegisterCommand(
    "tapi",
    function(s, a, r)
        local c = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        local x = Camera(x):getDirectionFromScreenCentre():toNative()
    end
)
