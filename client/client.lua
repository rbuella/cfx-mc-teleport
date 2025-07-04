local ESX = exports['es_extended']:getSharedObject()
local lastLocation = nil

RegisterCommand("teleport", function()
    CheckPermissions(function(hasPermission)
        if hasPermission then
            OpenTeleportMenu()
        else
            Notify(Config.Messages.NoPermission, "error")
        end
    end)
end)

function OpenTeleportMenu()
    local options = {}

    if lastLocation then
        table.insert(options, {
            title = "Last Location 📍",
            description = "Return to your last location.",
            icon = "fa-solid fa-location-arrow",
            onSelect = function()
                TeleportTo(lastLocation, "Last Location")
            end
        })
    end

    for _, location in ipairs(Config.Locations) do
        table.insert(options, {
            title = location.label,
            description = "Teleport to " .. location.label,
            icon = "fa-solid fa-location-dot",
            onSelect = function()
                TeleportTo(location.coords, location.label)
            end
        })
    end

    lib.registerContext({
        id = 'teleport_menu',
        title = 'Teleport Menu',
        options = options
    })

    lib.showContext('teleport_menu')
end

function TeleportTo(coords, label)
    if not coords or not coords.x or not coords.y or not coords.z then
        Notify("Invalid coordinates.", "error")
        return
    end

    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    lastLocation = GetEntityCoords(ped)

    if vehicle ~= 0 and Config.TeleportWithVehicle then
        -- In vehicle & config allows teleporting with vehicle
        SetEntityCoords(vehicle, coords.x, coords.y, coords.z + 0.5, false, false, false, true)
        SetEntityHeading(vehicle, coords.w or GetEntityHeading(vehicle))
    else
        -- Always teleport ped only
        SetEntityCoords(ped, coords.x, coords.y, coords.z + 0.5, false, false, false, true)
        SetEntityHeading(ped, coords.w or GetEntityHeading(ped))
    end

    Notify(Config.Messages.TeleportSuccess, "success")
    TriggerServerEvent("teleport:logTeleport", { coords = coords, label = label })
end

function CheckPermissions(callback)
    if not Config.RequirePermission then
        callback(true)
        return
    end

    ESX.TriggerServerCallback('teleport:checkPermission', function(hasPermission)
        callback(hasPermission)
    end)
end

function Notify(message, type)
    if lib and lib.notify then
        lib.notify({
            title = "Teleport",
            description = message,
            type = type or "inform"
        })
    else
        print("[Teleport] " .. (type or "info") .. ": " .. message)
    end
end
