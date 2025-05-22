local modules = {}

function module(resource, path)
    if not path then
        path = resource
        resource = GetCurrentResourceName()
    end

    local key = ("%s/%s"):format(resource, path)

    if modules[key] then
        return modules[key]
    end

    local code = LoadResourceFile(resource, path .. ".lua")
    if not code then
        error(("Module not found: %s/%s.lua"):format(resource, path))
    end

    local chunk, err = load(code, key)
    if not chunk then
        error(("Failed to load module %s: %s"):format(key, err))
    end

    local success, result = pcall(chunk)
    if not success then
        error(("Error running module %s: %s"):format(key, result))
    end

    modules[key] = result or true

    return modules[key]
end

lib = setmetatable({}, {
    __index = function(_, name)
        return module("lib/" .. name)
    end
})
