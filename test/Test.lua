RegisterCommand(
    "tapi",
    function(s, a, r)
        local r, coord = Camera.WorldToScreenRel(Vector3(-434.74, 5598.59, 68.41))
        if r then
            print(coord:toString())
        end
    end
)
