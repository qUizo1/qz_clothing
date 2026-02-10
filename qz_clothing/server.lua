local QZClothing = class("QZClothing", vRP.Extension)

function QZClothing:__construct()
    vRP.Extension.__construct(self)
end


local clothingCache = nil

RegisterServerEvent('qz_clothing:saveComponent')
AddEventHandler('qz_clothing:saveComponent', function(comp, data)
    if not clothingCache then
        local current = LoadResourceFile(GetCurrentResourceName(), 'nui/clothing.json')
        if current then
            clothingCache = json.decode(current)
        end
        if not clothingCache then
            clothingCache = {components = {}, props = {}}
        end
    end
    if clothingCache.components[comp] and clothingCache.components[comp].items then
        for _, item in ipairs(data.items) do
            table.insert(clothingCache.components[comp].items, item)
        end
    else
        clothingCache.components[comp] = data
    end
    print("Component " .. comp .. " merged. Total items: " .. (#clothingCache.components[comp].items or 0))
end)

RegisterServerEvent('qz_clothing:finalizeSave')
AddEventHandler('qz_clothing:finalizeSave', function()
    if clothingCache then
        SaveResourceFile(GetCurrentResourceName(), 'nui/clothing.json', json.encode(clothingCache), -1)
        print("Clothing data finalized and saved to clothing.json")
        clothingCache = nil 
    end
end)

RegisterServerEvent('qz_clothing:saveProp')
AddEventHandler('qz_clothing:saveProp', function(prop, data)
    if not clothingCache then
        local current = LoadResourceFile(GetCurrentResourceName(), 'nui/clothing.json')
        if current then
            clothingCache = json.decode(current)
        end
        if not clothingCache then
            clothingCache = {components = {}, props = {}}
        end
    end
    if clothingCache.props[prop] and clothingCache.props[prop].items then
        for _, item in ipairs(data.items) do
            table.insert(clothingCache.props[prop].items, item)
        end
    else
        clothingCache.props[prop] = data
    end
    print("Prop " .. prop .. " merged. Total items: " .. (#clothingCache.props[prop].items or 0))
end)

RegisterServerEvent('qz_clothing:processPurchase')
AddEventHandler('qz_clothing:processPurchase', function(cart)
    local source = source
    local total = 0
    
    for _, item in ipairs(cart) do
        total = total + (item.price or 100)
    end
    
    local user = vRP.users_by_source[source]
    
    local wallet = user:getWallet()
    local bank = user:getBank()
    
    if wallet >= total or bank >= total then
        user:tryPayment(total)
        vRP.EXT.Base.remote._notify(user.source, "Purchase successful! Paid $" .. total)
        TriggerClientEvent('qz_clothing:purchaseResult', source, true)
    else 
        vRP.EXT.Base.remote._notify(user.source, "Not enough money! Need $" .. total)
        TriggerClientEvent('qz_clothing:purchaseResult', source, false)
    end
end)

vRP:registerExtension(QZClothing)