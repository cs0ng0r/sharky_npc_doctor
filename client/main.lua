local ESX       = exports.es_extended:getSharedObject()

local canUse    = true

local ems = 0

local Explosion = { GetHashKey("weapon_explosion"), GetHashKey("WEAPON_PETROL_PUMP"), GetHashKey("WEAPON_PETROLCAN"),  GetHashKey("weapon_heli_crash") }

function checkExplosion()
    for k, v in pairs(Explosion) do
        if GetPedCauseOfDeath(PlayerPedId()) == v then
            return true
        end
    end
    return false
end

RegisterNetEvent('sharky_mentonpc:setOnlineAmbulance')
AddEventHandler('sharky_mentonpc:setOnlineAmbulance', function(onlineAmbulance)
    ems = onlineambulance
end)

Citizen.CreateThread(function()
    local pedModel = Config.PedSettings.PedModel
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(1)
    end
    local ped = CreatePed(4, pedModel, Config.PedSettings.Coords.x, Config.PedSettings.Coords.y, Config.PedSettings.Coords.z, Config.PedSettings.Coords.h, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetModelAsNoLongerNeeded(pedModel)

    Citizen.CreateThread(function()
        while true do
            Wait(Config.Options.CheckInterval * 1000)
           
                if ems > 0 then
                    canUse = false
                else
                    canUse = true
                end
          

    while true do
        Wait(5)
        local coords = GetEntityCoords(ped)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(coords, playerCoords, true)
        local playerHealth = GetEntityHealth(PlayerPedId())

        local asd, headBone = GetPedLastDamageBone(playerPed)
        if distance < 3 then
            if IsControlJustPressed(0, 38) then
                if asd == 1 and headBone == 31086 then
                    ESX.ShowNotification('Nem tudlak gyógyítani, mert fejsérülést szenvedtél!')
                elseif checkExplosion() == true then
                    ESX.ShowNotification('Nem tudlak gyógyítani, mert felrobbantál!')
                elseif not canUse then
                    ESX.ShowNotification('Jelenleg van elérhető mentős!')
                elseif playerHealth == 0 then
                    ESX.TriggerServerCallback('sharky_mentonpc:removeMoney', function()
                        ESX.ShowNotification('Feltámadtál!')
                        TriggerEvent('esx_ambulancejob:revive')
                    end, Config.Options.RevivePrice)
                elseif playerHealth > 0 and playerHealth < GetEntityMaxHealth(playerPed) then
                    ESX.TriggerServerCallback('sharky_mentonpc:removeMoney', function()
                        ESX.ShowNotification('Meggyógyultál!')
                        SetEntityHealth(PlayerPedId(), 200)
                    end, Config.Options.HealPrice)
                end
            else
                if not canUse then
                    DrawText3D(coords + vec3(0, 0, 1), Config.NPCText.npc_ems_online)
                elseif playerHealth > 0 then
                    DrawText3D(coords + vec3(0, 0, 1), Config.NPCText.npc_heal_txt)
                elseif playerHealth == 0 then
                    DrawText3D(coords + vec3(0, 0, 1), Config.NPCText.npc_revive_txt)
                end
            end
        elseif distance > 5 then
            Wait(2000)
        end
    end
end)


function DrawText3D(coords, text)
    SetDrawOrigin(coords)
    SetTextScale(0.0, 0.4)
    SetTextFont(4)
    SetTextCentre(1)
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentString(text)
    EndTextCommandDisplayText(0, 0)
    ClearDrawOrigin()
end



AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
end)
