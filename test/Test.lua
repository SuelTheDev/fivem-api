RegisterCommand("tapi", function(s, a, r)
    local v = Vector3(1,2,4)   
    print(v:PointOnCircle(25.76, 5.3):toString())   
end)