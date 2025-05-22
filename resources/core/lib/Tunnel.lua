local Tunnel = {}
local registeredInterfaces = {}

local IDManagerClass = module("lib/IDManager")

local function resolveHandler(self, key)
    local name = self.__name
    local id = self.__identifier
    local callbacks = self.__callbacks
    local idManager = self.__idManager

    local function callFunc(...)
        local promise = promise.new()
        local reqId = idManager:gen()

        callbacks[reqId] = promise

        if self.__isServer then
            TriggerClientEvent(name .. ":tunnel_request", source, key, {...}, id, reqId)
        else
            TriggerServerEvent(name .. ":tunnel_request", key, {...}, id, reqId)
        end

        local result = Citizen.Await(promise)
        return table.unpack(result)
    end

    self[key] = callFunc
    return callFunc
end


function Tunnel.bindInterface(name, interface)
    registeredInterfaces[name] = interface

    RegisterNetEvent(name .. ":tunnel_request", function(member, args, identifier, reqId)
        local src = source
        local func = interface[member]

        if type(func) == "function" then
            local status, result = pcall(func, table.unpack(args or {}))
            if not status then
                print(("Tunnel Error [%s - %s]: %s"):format(name, member, result))
                result = {}
            else
                result = {result}
            end


            if reqId then
                if src then
                    TriggerClientEvent(name .. ":" .. identifier .. ":eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.JLCOo2CvoJSdAimDgSA_panhK1HNVaqRyOnh6cIl_uI", src, reqId, result)
                else
                    TriggerServerEvent(name .. ":" .. identifier .. ":eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.JLCOo2CvoJSdAimDgSA_panhK1HNVaqRyOnh6cIl_uI", reqId, result)
                end
            end
        end
    end)
end

function Tunnel.getInterface(name, identifier, isServer)
    identifier = identifier or GetCurrentResourceName()

    local callbacks = {}
    local idManager = IDManagerClass:new()

    local obj = setmetatable({
        __name = name,
        __identifier = identifier,
        __callbacks = callbacks,
        __idManager = idManager, 
        __isServer = isServer or IsDuplicityVersion()
    }, {
        __index = resolveHandler
    })

    RegisterNetEvent(name .. ":" .. identifier .. ":eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.JLCOo2CvoJSdAimDgSA_panhK1HNVaqRyOnh6cIl_uI", function(reqId, response)
        if callbacks[reqId] then
            callbacks[reqId]:resolve(response)
            callbacks[reqId] = nil
        end
    end)

    return obj
end


return Tunnel
