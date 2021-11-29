fx_version "cerulean"
game "gta5"

shared_scripts {
    "shared/class.lua",
    "shared/Utils.lua"
}

client_scripts {
    "src/Vector2.lua",
    "src/Vector3.lua",
    "src/GTAentity.lua",
    "src/RaycastResult.lua",
    "src/Camera.lua",   
    "test/*.lua"
}

files {
    "shared/*.lua"
}

lua54 "yes"
