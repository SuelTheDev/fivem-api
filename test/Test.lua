RegisterCommand("tapi", function(s, a, r)
    local v1 = Vector2()
    local v2 = Vector2(5.3, 5.3)
    print( Vector2.DistanceBetween(v1, v2) )
end)