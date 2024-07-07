local ESX    = exports.es_extended:getSharedObject()

local canUse = false

CreateThread(function()
    while true do
        Wait(Sharky.Options.CheckInterval * 1000)
        ESX.TriggerServerCallback('sharky_mentonpc:getOnlineAmbulance', function(onlineAmbulance)
            if onlineAmbulance > 0 then
                canUse = false
            else
                canUse = true
            end
        end)
    end
end)

CreateThread(function()
    local pedModel = GetHashKey("s_m_m_doctor_01")
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(1)
    end
    local ped = CreatePed(4, pedModel, Sharky.PedSettings.Coords.x, Sharky.PedSettings.Coords.y,
        Sharky.PedSettings.Coords.z, Sharky.PedSettings.Coords.h, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetModelAsNoLongerNeeded(pedModel)

    while true do
        Wait(0)
        local coords = GetEntityCoords(ped)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(coords, playerCoords, true)
        local playerHealth = GetEntityHealth(PlayerPedId())
        if distance < 2 then
            if canUse then
                DrawText3D(coords + vec3(0, 0, 1), "Nyomd meg az ~g~E~s~ gombot a mentéshez")
                if IsControlJustPressed(0, 38) then
                    if playerHealth >= Sharky.Options.heal.minHealth then
                        ESX.ShowNotification('Nem vagy beteg!')
                        return
                    end
                    ESX.TriggerServerCallback('sharky_mentonpc:removeMoney', function()
                        ESX.ShowNotification('Sikeresen meggyógyultál!')
                        SetEntityHealth(PlayerPedId(), 200)
                    end, 10000)
                end
            else
                DrawText3D(coords + vec3(0, 0, 1), "Bocsi, jelenleg van elérhetö kollégám!")
            end
        end
    end
end)

function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, coords.x, coords.y, coords.z, 1)
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
