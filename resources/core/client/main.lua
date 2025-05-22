local noClip = false
local speed = 1.0

Citizen.CreateThread(function()
    local resposta = CoreServer.testar("Olá servidor!")
    print(resposta)
end)

CoreClient.noClip = function()
    print("aaaaaaaaa")
    noClip = not noClip
    local ped = PlayerPedId()

    if noClip then
        SetEntityInvincible(ped, true)
        SetEntityVisible(ped, false, false)
        SetEntityCollision(ped, false, false)
        SetEntityAlpha(ped, 0, false)
        SetEntityFreeze(ped, false, false)
        SetEveryoneIgnorePlayer(PlayerId(), true)
        SetPoliceIgnorePlayer(PlayerId(), true)
        TriggerEvent("chat:addMessage", {
            args = {"[NoClip]", "Ativado"}
        })
    else
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, false)
        SetEntityCollision(ped, true, true)
        ResetEntityAlpha(ped)
        SetEveryoneIgnorePlayer(PlayerId(), false)
        SetPoliceIgnorePlayer(PlayerId(), false)
        TriggerEvent("chat:addMessage", {
            args = {"[NoClip]", "Desativado"}
        })
    end
end

RegisterClientCallback("noClip", function(data, cb)
    CoreClient.noClip()
    cb(noClip)
end)

-- Movimento noClip
CreateThread(function()
    while true do
        Wait(0)
        if noClip then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            local forward = GetEntityForwardVector(ped)

            -- Controle de movimento
            DisableControlAction(0, 32, true) -- W
            DisableControlAction(0, 33, true) -- S
            DisableControlAction(0, 34, true) -- A
            DisableControlAction(0, 35, true) -- D

            local x, y, z = table.unpack(coords)

            if IsControlPressed(0, 32) then -- W
                x = x + forward.x * speed
                y = y + forward.y * speed
                z = z + forward.z * speed
            end

            if IsControlPressed(0, 33) then -- S
                x = x - forward.x * speed
                y = y - forward.y * speed
                z = z - forward.z * speed
            end

            if IsControlPressed(0, 44) then -- Q
                z = z + speed
            end

            if IsControlPressed(0, 36) then -- LSHIFT
                z = z - speed
            end

            SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(2000)
        local player = LocalPlayer.state
        if player.money then
            print("Você tem $" .. player.money)
        end
        local job = CoreServer.getPlayerJob()
        if job then
            print('Meu trabalho é: ', job)
        end
    end
end)
