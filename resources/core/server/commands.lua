RegisterCommand("nc", function(source, args)
    local src = source
    TriggerClientCallback("noClip", src)
end, true)


RegisterCommand("god", function(source, args, rawCommand) 
    SetEntityHealth(GetPlayerPed(source), 200)
end, true)