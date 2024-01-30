local QBCore = exports['qb-core']:GetCoreObject()
PlayerData = {}

-- Kontrol edilecek silahlar
Weapons = {
    "WEAPON_GLOCK",
    "WEAPON_STUNGUN",
    "WEAPON_PUMPSHOTGUN",
    "WEAPON_SMG",
    "WEAPON_M4",
    "WEAPON_NIGHTSTICK",
    "WEAPON_FLASHLIGHT",
}

-- Meslekler
Jobs = {
    "police",
}

local isPlayerWhitelisted = false
local cooldownActive = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
    isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local player = PlayerPedId()

        -- Eğer oyuncu whitelistlenmemişse ve cooldown süresi bitmişse
        if not isPlayerWhitelisted and not cooldownActive then
            for k, v in pairs(Weapons) do
                local weapon = GetHashKey(v)
                if HasPedGotWeapon(player, weapon, false) == 1 then
                    RemoveWeaponFromPed(player, weapon)
                    QBCore.Functions.Notify("Bu Silahı Kullanmaya Yetkin Yok Laa Gardaşşşş :).", "error")
                end
            end
            cooldownActive = true
            Citizen.Wait(600000) -- 10 dakika cooldown süresi
            cooldownActive = false
        end
    end
end)

function refreshPlayerWhitelisted()
    if not PlayerData or not PlayerData.job then
        return false
    end

    -- Eğer oyuncunun mesleği whitelistteki mesleklerden biriyse true döndür
    for k, v in ipairs(Jobs) do
        if v == PlayerData.job.name then
            return true
        end
    end

    return false
end
