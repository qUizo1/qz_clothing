Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")

local cvRP = module("vrp", "client/vRP")
vRP = cvRP()

local pvRP = {}
pvRP.loadScript = module
Proxy.addInterface("vRP", pvRP)

local QZClothing = class("QZClothing", vRP.Extension)

function QZClothing:__construct()
    vRP.Extension.__construct(self)
end

local originalClothes = {}
local purchasedOutfit = nil
local cam = nil
local originalCamCoords = nil
local originalCamRot = nil

local componentCategories = {
    [0] = "head",
    [1] = "mask",
    [2] = "hair",
    [3] = "glove",
    [4] = "pants",
    [5] = "bags",
    [6] = "shoes",
    [7] = "neck",
    [8] = "shirt",
    [9] = "vest",
    [10] = "decals",
    [11] = "hoodie"
}

local propCategories = {
    [0] = "hat",
    [1] = "glasses",
    [2] = "ears",
    [3] = "watches",
    [4] = "bracelets",
    [5] = "unknown",
    [6] = "unknown",
    [7] = "unknown"
}

local cameraPositions = {
    upper = {
        coords = vector3(0.0, -1.5, 0.3),
        rot = vector3(0.0, 0.0, 0.0)
    },
    lower = {
        coords = vector3(0.0, -1.0, -0.5),
        rot = vector3(0.0, 0.0, 0.0)
    },
    accessories = {
        coords = vector3(0.0, -2.0, 0.3),
        rot = vector3(0.0, 0.0, 0.0)
    }
}

RegisterCommand('scanclothing', function()
    local clothingData = {components = {}, props = {}}
    local ped = PlayerPedId()
    print("Starting clothing scan...")
    for comp = 0, 11 do
        local numDrawables = GetNumberOfPedDrawableVariations(ped, comp)
        print("Component " .. comp .. " has " .. numDrawables .. " drawables")
        clothingData.components[tostring(comp)] = {items = {}}
        for drawable = 0, numDrawables - 1 do
            local numTextures = GetNumberOfPedTextureVariations(ped, comp, drawable)
            for texture = 0, numTextures - 1 do
                local category = componentCategories[comp] or "unknown"
                local item = {
                    id = comp .. "_" .. drawable .. "_" .. texture,
                    name = "Component " .. comp .. " Var " .. drawable .. " Tex " .. texture,
                    price = 100,
                    image = "https://cdn.jsdelivr.net/gh/qUizo1/clothing_images/"..category.."/"..drawable.."/"..texture..".webp",
                    category = category,
                    drawable = drawable,
                    texture = texture
                }
                table.insert(clothingData.components[tostring(comp)].items, item)
            end
        end
    end

    for prop = 0, 7 do
        local numDrawables = GetNumberOfPedPropDrawableVariations(ped, prop)
        clothingData.props[tostring(prop)] = {items = {}}
        for drawable = 0, numDrawables - 1 do
            local numTextures = GetNumberOfPedPropTextureVariations(ped, prop, drawable)
            for texture = 0, numTextures - 1 do
                local category = propCategories[prop] or "unknown"
                local item = {
                    id = "prop_" .. prop .. "_" .. drawable .. "_" .. texture,
                    name = "Prop " .. prop .. " Var " .. drawable .. " Tex " .. texture,
                    price = 100,
                    image = "https://cdn.jsdelivr.net/gh/qUizo1/clothing_images/"..category.."/"..drawable.."/"..texture..".webp",
                    category = category,
                    drawable = drawable,
                    texture = texture
                }
                table.insert(clothingData.props[tostring(prop)].items, item)
            end
        end
    end

    for comp, data in pairs(clothingData.components) do
        if #data.items > 100 then
            local batchSize = 50
            for i = 1, #data.items, batchSize do
                local batch = {items = {}}
                for j = i, math.min(i + batchSize - 1, #data.items) do
                    table.insert(batch.items, data.items[j])
                end
                print("Sending component " .. comp .. " batch " .. math.ceil(i/batchSize) .. "...")
                TriggerServerEvent('qz_clothing:saveComponent', comp, batch)
                Citizen.Wait(500)
            end
        else
            print("Sending component " .. comp .. " to server...")
            TriggerServerEvent('qz_clothing:saveComponent', comp, data)
            Citizen.Wait(500)
        end
    end
    for prop, data in pairs(clothingData.props) do
        print("Sending prop " .. prop .. " to server...")
        TriggerServerEvent('qz_clothing:saveProp', prop, data)
        Citizen.Wait(500)
    end
    print("Clothing scan complete. Data sent to server.")
    TriggerServerEvent('qz_clothing:finalizeSave')
end, false)

RegisterNetEvent('qz_clothing:openMenu', function()
    openClothingMenu()
end)

function openClothingMenu()
    originalClothes = {}
    purchasedOutfit = nil
    for i = 0, 11 do
        originalClothes[i] = {GetPedDrawableVariation(PlayerPedId(), i), GetPedTextureVariation(PlayerPedId(), i)}
    end
    for i = 0, 7 do
        originalClothes['prop_' .. i] = {GetPedPropIndex(PlayerPedId(), i), GetPedPropTextureIndex(PlayerPedId(), i)}
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open'
    })
    
    createCamera('upper')
end

function createCamera(category)
    if cam then
        DestroyCam(cam, false)
        cam = nil
    end
    
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    
    if not originalCamCoords then
        originalCamCoords = pedCoords + vector3(0.0, 2.5, 0.8)
        originalCamRot = vector3(0.0, 0.0, 0.0)
    end
    
    local camConfig = cameraPositions[category] or cameraPositions['upper']
    local camCoords = pedCoords + camConfig.coords
    
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, camCoords.x, camCoords.y, camCoords.z)
    SetCamRot(cam, camConfig.rot.x, camConfig.rot.y, camConfig.rot.z, 2)
    
    RenderScriptCams(true, false, 500, true, true)
end

function resetCamera()
    if cam then
        DestroyCam(cam, false)
        cam = nil
    end
    RenderScriptCams(false, false, 300, false, true)
    originalCamCoords = nil
    originalCamRot = nil
end

RegisterNUICallback('changeCategory', function(data, cb)
    local category = data.category
    if category and cameraPositions[category] then
        createCamera(category)
    end
    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    local ped = PlayerPedId()
    
    if data.keepClothes then
        purchasedOutfit = {}
        for i = 0, 11 do
            purchasedOutfit[i] = {
                GetPedDrawableVariation(ped, i),
                GetPedTextureVariation(ped, i)
            }
        end
        for i = 0, 7 do
            purchasedOutfit['prop_' .. i] = {
                GetPedPropIndex(ped, i),
                GetPedPropTextureIndex(ped, i)
            }
        end
    else
        for i = 0, 11 do
            if originalClothes[i] then
                SetPedComponentVariation(ped, i, originalClothes[i][1], originalClothes[i][2], 0)
            end
        end
        for i = 0, 7 do
            if originalClothes['prop_' .. i] then
                SetPedPropIndex(ped, i, originalClothes['prop_' .. i][1], originalClothes['prop_' .. i][2], true)
            end
        end
    end

    SetNuiFocus(false, false)
    resetCamera()
    cb('ok')
end)

local categoryToComponent = {
    ["head"] = 0,
    ["mask"] = 1,
    ["hair"] = 2,
    ["glove"] = 3,
    ["pants"] = 4,
    ["bags"] = 5,
    ["shoes"] = 6,
    ["neck"] = 7,
    ["shirt"] = 8,
    ["vest"] = 9,
    ["decals"] = 10,
    ["hoodie"] = 11
}

local categoryToProp = {
    ["hat"] = 0,
    ["glasses"] = 1,
    ["ears"] = 2,
    ["watches"] = 3,
    ["bracelets"] = 4
}

RegisterNUICallback('changeClothing', function(data, cb)
    local ped = PlayerPedId()
    if data.type == 'component' then
        SetPedComponentVariation(ped, data.component, data.drawable, data.texture, 0)
        print('Set component', data.component, data.drawable, data.texture)
    elseif data.type == 'prop' then
        SetPedPropIndex(ped, data.component, data.drawable, data.texture, true)
        print('Set prop', data.component, data.drawable, data.texture)
    end
    cb('ok')
end)

RegisterNUICallback('restoreClothing', function(data, cb)
    local ped = PlayerPedId()
    local category = data.category
    
    local compId = categoryToComponent[category]
    if compId then
        if originalClothes[compId] then
            SetPedComponentVariation(ped, compId, originalClothes[compId][1], originalClothes[compId][2], 0)
        end
    else
        local propId = categoryToProp[category]
        if propId then
            if originalClothes['prop_' .. propId] then
                SetPedPropIndex(ped, propId, originalClothes['prop_' .. propId][1], originalClothes['prop_' .. propId][2], true)
            end
        end
    end
    
    cb('ok')
end)

RegisterNUICallback('rotateCharacter', function(data, cb)
    local ped = PlayerPedId()
    local direction = data.direction
    local rotationSpeed = 2.5
    
    if direction == 'left' then
        SetEntityHeading(ped, GetEntityHeading(ped) - rotationSpeed)
    elseif direction == 'right' then
        SetEntityHeading(ped, GetEntityHeading(ped) + rotationSpeed)
    end
    
    cb('ok')
end)

RegisterNUICallback('purchase', function(data, cb)
    TriggerServerEvent('qz_clothing:processPurchase', data.cart)
    cb('ok')
end)

RegisterNetEvent('qz_clothing:purchaseResult', function(success, message)
    if success then
        SendNUIMessage({
            action = 'purchaseSuccess',
            message = message
        })
    else
        SendNUIMessage({
            action = 'purchaseError',
            message = message
        })
    end
end)

vRP:registerExtension(QZClothing)

