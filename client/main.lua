local ESX = exports.es_extended:getSharedObject()
local onlineAmbulance = 0


local canUse = true
local ped = nil
local Explosion = { GetHashKey("weapon_explosion"), GetHashKey("WEAPON_PETROL_PUMP"), GetHashKey("WEAPON_PETROLCAN"),
    GetHashKey("weapon_heli_crash") }

function checkExplosion()
    for k, v in pairs(Explosion) do
        if GetPedCauseOfDeath(PlayerPedId()) == v then
            return true
        end
    end
    return false
end

function spawnPed()
    if not DoesEntityExist(ped) then
        local pedModel = Config.PedSettings.PedModel
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Wait(1)
        end

        ped = CreatePed(4, pedModel, Config.PedSettings.Coords.x, Config.PedSettings.Coords.y,
            Config.PedSettings.Coords.z, Config.PedSettings.Coords.h, false, true)

        SetEntityAsMissionEntity(ped, true, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetModelAsNoLongerNeeded(pedModel)
    end
end

function deletePed()
    if DoesEntityExist(ped) then
        DeleteEntity(ped)
        ped = nil
    end
end

-- Citizen.CreateThread(function()
--     while false do
--         Wait(5000)
--         ESX.TriggerServerCallback('sharky_mentonpc:getOnlineAmbulance', function(onlineAmbulance)
            
--         end)
--     end
-- end)

RegisterNetEvent('sharky_mentonpc:regOnlineAmbulance', function(onlineAmbulance)
    if onlineAmbulance > 0 then
        deletePed()
        canUse = false
    else
        spawnPed()
        canUse = true
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        if DoesEntityExist(ped) then
            local coords = GetEntityCoords(ped)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = GetDistanceBetweenCoords(coords, playerCoords, true)
            local playerHealth = GetEntityHealth(playerPed)

            local asd, headBone = GetPedLastDamageBone(playerPed)
            if distance < 3 then
                if IsControlJustPressed(0, 38) then
                    if asd == 1 and headBone == 31086 then
                        ESX.ShowNotification('Nem tudlak gyógyítani, mert fejsérülést szenvedtél!')
                    elseif checkExplosion() then
                        ESX.ShowNotification('Nem tudlak gyógyítani, mert felrobbantál!')
                    elseif not canUse then
                        ESX.ShowNotification('Jelenleg van elérhető mentős!')
                    elseif playerHealth == 0 then
                        ESX.TriggerServerCallback('sharky_mentonpc:removeMoney', function()
                            ESX.ShowNotification('Újra élesztetek!')
                            TriggerEvent('esx_ambulancejob:revive')
                        end, Config.Options.RevivePrice)
                    elseif playerHealth > 0 and playerHealth < GetEntityMaxHealth(playerPed) then
                        ESX.TriggerServerCallback('sharky_mentonpc:removeMoney', function()
                            ESX.ShowNotification('Meggyógyultál!')
                            SetEntityHealth(playerPed, 200)
                        end, Config.Options.HealPrice)
                    end
                else
                    if not canUse then
                        DrawText3D(coords + vec3(0, 0, 1), "~b~ Ügyeletes \n ~s~Bocsi, jelenleg van elérhetö kollégám!")
                    elseif playerHealth > 150 then
                        DrawText3D(coords + vec3(0, 0, 1), "~b~ Ügyeletes \n ~s~Nem szorulsz ellátásra!")
                    elseif playerHealth > 0 then
                        DrawText3D(coords + vec3(0, 0, 1), "~b~ Ügyeletes \n ~s~Nyomd meg az ~g~E~w~ gombot az ellátás igényléséhez! ~g~10.000$")
                    elseif playerHealth == 0 then
                        DrawText3D(coords + vec3(0, 0, 1), "~b~ Ügyeletes \n ~s~Nyomd meg az ~g~E~w~ gombot az újraélesztéshez! ~g~20.000$")
                    end
                end
            elseif distance > 5 then
                Wait(2000)
            end
        end
    end
end)

function DrawText3D(coords, text)
    SetDrawOrigin(coords)
    SetTextScale(0.0, 0.4)
    SetTextFont(4)
    SetTextCentre(1)
    SetTextOutline(1)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentString(text)
    EndTextCommandDisplayText(0, 0)
    ClearDrawOrigin()
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        deletePed()
    end
end)
