local ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('teleport:checkPermission', function(source, cb)
    local Player = ESX.GetPlayerFromId(source)

    if not Config.RequirePermission then
        cb(true)
        return
    end

    local identifier = Player.identifier
    for _, allowedID in ipairs(Config.AllowedSteamIDs) do
        if identifier == allowedID then
            cb(true)
            return
        end
    end

    local playerJob = string.lower(Player.job.name)
    for _, job in ipairs(Config.AllowedJobs) do
        if playerJob == string.lower(job) then
            cb(true)
            return
        end
    end

    cb(false)
end)

RegisterNetEvent("teleport:logTeleport", function(data)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local name = GetPlayerName(src) or "Unknown"
    local coords = data.coords
    local label = data.label or "Unknown"

    local message = string.format(
        "**%s** (ID: %s) teleported to **%s** (x: %.2f, y: %.2f, z: %.2f)\nIdentifier: `%s`",
        name, src, label, coords.x, coords.y, coords.z, Player.identifier
    )

    SendDiscordLog("Teleport Used", message, 3447003)
end)

function SendDiscordLog(title, message, color)
    if not Config.DiscordWebhook or Config.DiscordWebhook == "" then
        print("[Teleport Log] Discord webhook not set.")
        return
    end

    local embed = {{
        ["title"] = title,
        ["description"] = message,
        ["color"] = color or 65280
    }}

    PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST', json.encode({
        username = Config.WebhookName or "Teleport Logs",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end
