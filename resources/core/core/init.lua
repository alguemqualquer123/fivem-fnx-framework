FCore = {}
players = {}

CreateThread(function()
    Wait(100)
    exports[GetCurrentResourceName()]:initDatabase()
end)



RegisterCommand("restartserver", function(source, args, rawCommand)
    if source == 0 then
        print("[coreNova] Reiniciando servidor com script externo...")
        os.execute("start restart.bat")
    end
end, true)
