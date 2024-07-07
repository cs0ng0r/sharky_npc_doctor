local ESX = exports.es_extended:getSharedObject()

ESX.RegisterServerCallback('sharky_mentonpc:getOnlineAmbulance', function(source, cb)
    local xPlayers = ESX.GetPlayers()
    local onlineAmbulance = 0
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'ambulance' then
            onlineAmbulance = onlineAmbulance + 1
        end
    end
    cb(onlineAmbulance)
    print(onlineAmbulance)
end)

ESX.RegisterServerCallback('sharky_mentonpc:removeMoney', function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or source == nil or source == 0 then
        return
    end
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        cb()
    else
        xPlayer.showNotification('Nincs elég pénzed!')
    end
end)
