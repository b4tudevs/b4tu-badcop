local QBCore = exports['qb-core']:GetCoreObject()
PlayerData = {}

Weapons = {
    "WEAPON_GLOCK17",
    "WEAPON_STUNGUN",
    "WEAPON_PUMPSHOTGUN",
    "WEAPON_MP5",
    "WEAPON_HK416",
    "WEAPON_SCARH",
    "WEAPON_NIGHTSTICK",
    "WEAPON_FLASHLIGHT",
}

Jobs = {
    "police",
}

CreateThread(function()
    local QBCore = exports['qb-core']:GetCoreObject()
    PlayerData = QBCore.Functions.GetPlayerData()
    
    isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
    isPlayerWhitelisted = refreshPlayerWhitelisted()
end)


CreateThread(function()
    while true do
        Wait(500)
        local player = PlayerPedId()
        if not isPlayerWhitelisted then
            for k,v in pairs(Weapons) do
                local player = PlayerPedId()
                local weapon = GetHashKey(v)
                if HasPedGotWeapon(player, weapon, false) == 1 then
                    RemoveWeaponFromPed(player, weapon)
                    QBCore.Functions.Notify("Bu silahı kullanamazsın.", "error")
                end
            end
        end
    end
end)


function refreshPlayerWhitelisted()
	if not PlayerData then
		return false
	end

	if not PlayerData.job then
		return false
	end

	for k,v in ipairs(Jobs) do
		if v == PlayerData.job.name then
			return true
		end
	end

	return false
end
