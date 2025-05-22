local Tunnel = lib.Tunnel
local Proxy = lib.Proxy

Core = {}
players = {}

Proxy.addInterface(GetCurrentResourceName(), Core)
Tunnel.bindInterface(GetCurrentResourceName(), Core)

CoreClient = Tunnel.getInterface(GetCurrentResourceName())


CreateThread(function()
    Wait(100)
    exports[GetCurrentResourceName()]:initDatabase()
    Core.StartServerLog("Iniciando servidor", "na porta", 30120)
end)

RegisterCommand("restartserver", function(source, args, rawCommand)
    if source == 0 then
        print("[coreNova] Reiniciando servidor com script externo...")
        os.execute("start restart.bat")
    end
end, true)
