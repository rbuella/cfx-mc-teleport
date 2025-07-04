local ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('teleport:checkPermission', function(source, cb)
    local Player = ESX.GetPlayerFromId(source)

    if not Config.RequirePermission then
        cb(true)
        return
    end

    local steamID = GetPlayerIdentifier(source, 0)
    for _, allowedSteamID in ipairs(Config.AllowedSteamIDs) do
        if steamID == allowedSteamID then
            cb(true)
            return
        end
    end

    local playerJob = Player.job.name
    for _, job in ipairs(Config.AllowedJobs) do
        if playerJob == job then
            cb(true)
            return
        end
    end

    cb(false)
end)

RegisterNetEvent("teleport:logTeleport", function(data)
    local src = source
    local name = GetPlayerName(src)
    local coords = data.coords
    local label = data.label or "Unknown"
    local message = string.format("**%s** teleported to **%s** (x: %.2f, y: %.2f, z: %.2f)", name, label, coords.x, coords.y, coords.z)
    SendDiscordLog("Teleport Used", message, 3447003)
end)

function SendDiscordLog(title, message, color)
    local embed = {{
        ["title"] = title,
        ["description"] = message,
        ["color"] = color or 65280
    }}

    PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST', json.encode({
        username = "Teleport Logs",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end
