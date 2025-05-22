local Proxy = {}
local registeredProxies = {}

local function resolveHandler(self, key)
    local name = self.__name
    local id = self.__identifier
    local callbacks = self.__callbacks

    local function callFunc(...)
        local promise = promise.new()
        local reqId = math.random(1000000, 9999999) .. os.time()

        callbacks[reqId] = promise

        TriggerEvent(name .. ":eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.7ra0bNUklcgvK4XVFLLh-thcdvVgQnNT5EMSMVGFm1E", key, {...}, id, reqId)

        local result = Citizen.Await(promise)
        return table.unpack(result)
    end

    self[key] = callFunc
    return callFunc
end

function Proxy.addInterface(name, interface)
    registeredProxies[name] = interface

    AddEventHandler(name .. ":eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.7ra0bNUklcgvK4XVFLLh-thcdvVgQnNT5EMSMVGFm1E", function(member, args, identifier, reqId)
        local func = interface[member]

        if type(func) == "function" then
            local result = {pcall(func, table.unpack(args or {}))}
            local status = table.remove(result, 1)

            if not status then
                print(("Proxy Error [%s - %s]: %s"):format(name, member, result[1]))
                result = {}
            end

            TriggerEvent(name .. ":" .. identifier .. ":eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ._eB2wyXoZGrj_ImIhM_TvgAuXiscyNk2jQD10NFgLDQ", reqId, result)
        end
    end)
end

function Proxy.getInterface(name, identifier)
    identifier = identifier or GetCurrentResourceName()

    local callbacks = {}
    local obj = setmetatable({
        __name = name,
        __identifier = identifier,
        __callbacks = callbacks,
    }, {__index = resolveHandler})

    AddEventHandler(name .. ":" .. identifier .. ":eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ._eB2wyXoZGrj_ImIhM_TvgAuXiscyNk2jQD10NFgLDQ", function(reqId, response)
        if callbacks[reqId] then
            callbacks[reqId]:resolve(response)
            callbacks[reqId] = nil
        end
    end)

    return obj
end

return Proxy
