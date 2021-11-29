GTAentity = class()
GTAentity:set("type", "class<gtaentity>")

function GTAentity:init(handle)
    self.mHandle = handle
end

function GTAentity:Handle()
    return self.mHandle
end