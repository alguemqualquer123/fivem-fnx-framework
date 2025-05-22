local Tunnel = lib.Tunnel
local Proxy = lib.Proxy

CoreClient = {}
players = {}

Proxy.addInterface(GetCurrentResourceName(), CoreClient)
Tunnel.bindInterface(GetCurrentResourceName(), CoreClient)

CoreServer = Tunnel.getInterface(GetCurrentResourceName())
