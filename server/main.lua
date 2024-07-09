local ESX = exports.es_extended:getSharedObject()

local onlineAmbulance = 0

Citizen.CreateThread(function()
    while true do
        local xPlayers = ESX.GetPlayers()
        local _onlineAmbulance = 0
        for i = 1, #xPlayers do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'ambulance' then
                onlineAmbulance = onlineAmbulance + 1
            end
        end
        onlineAmbulance = _onlineAmbulance
        TriggerServerEvent('sharky_mentonpc:setOnlineAmbulance', -1, onlineAmbulance)
        Citizen.Wait(Config.Options.CheckInterval * 1000)
    end
end)

ESX.RegisterServerCallback('sharky_mentonpc:getOnlineAmbulance', function(source, cb)
    cb(onlineAmbulance)
end)

ESX.RegisterServerCallback('sharky_mentonpc:removeMoney', function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return
    end
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        cb()
    elseif xPlayer.getAccount('bank').money >= price then
        xPlayer.removeAccountMoney('bank', price)
        cb()
    else
        xPlayer.showNotification('Nincs elég pénzed!')
    end
end)
