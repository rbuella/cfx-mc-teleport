Config = {}

Config.Framework = "esx"
Config.WebhookName = "Teleport Logs"
Config.DiscordWebhook = "https://discord.com/api/webhooks/..." -- Put your webhook URL here


Config.RequirePermission = false -- true = only allowed jobs/SteamIDs can teleport
Config.AllowedJobs = {"police", "ambulance"} -- Allowed jobs if permission is required
Config.TeleportWithVehicle = true -- true = teleport with vehicle if player is in one, false = always teleport only the player

Config.Locations = {
    {label = "Police Station 🚔", coords = vector3(425.1, -979.5, 30.7)},
    {label = "Hospital 🏥", coords = vector3(300.6624, -615.8224, 43.4537)},
    {label = "Vinewood Sign 🎥", coords = vector3(709.7, 1208.3, 325.3)},
    {label = "Mount Chiliad 🗻", coords = vector3(456.1953, 5571.6230, 781.1845)},
}

Config.AllowedSteamIDs = { -- Add your Steam hex IDs here
    -- "steam:110000000000000",
    -- "steam:110000000000000"
}

Config.Messages = {
    NoPermission = "You do not have access to the teleport menu!",
    TeleportSuccess = "You teleported!"
}
