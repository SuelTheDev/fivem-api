fx_version "cerulean"
game "gta5"

shared_scripts {
    "shared/class.lua",
    "shared/Utils.lua"
}

client_scripts {
    "src/*.lua",
    "test/*.lua"
}

files {
    "shared/*.lua"
}

lua54 "yes"
