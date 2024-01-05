local QBCore = exports['qb-core']:GetCoreObject()
PlayerData = {}

Weapons = {
    "WEAPON_COMBATPISTOL",
    "WEAPON_STUNGUN",
    "WEAPON_PUMPSHOTGUN",
    "WEAPON_SMG",
    "WEAPON_CARBINERIFLE",
    "WEAPON_NIGHTSTICK",
    "WEAPON_FLASHLIGHT",
}

Jobs = {
    "police",
}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
    local isPlayerWhitelisted = refreshPlayerWhitelisted()

    if not isPlayerWhitelisted then
        CheckAndRemoveIllegalWeapons()
    end
end)

function refreshPlayerWhitelisted()
    if not PlayerData or not PlayerData.job then
        return false
    end

    for k, v in ipairs(Jobs) do
        if v == PlayerData.job.name then
            return true
        end
    end

    return false
end

function CheckAndRemoveIllegalWeapons()
    local player = PlayerPedId()
    for k, v in pairs(Weapons) do
        local weapon = GetHashKey(v)
        if HasPedGotWeapon(player, weapon, false) == 1 then
            RemoveWeaponFromPed(player, weapon)
            QBCore.Functions.Notify("Bu Silahı Kullanmaya Yetkin Yok.", "error")
        end
    end
end
