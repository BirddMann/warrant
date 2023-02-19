-- ESX
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

--NPC Police Spawns
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		StopAnyPedModelBeingSuppressed()
		SetScenarioTypeEnabled(WORLD_VEHICLE_POLICE_CAR, true)  
		SetScenarioTypeEnabled(WORLD_VEHICLE_POLICE_BIKE, true)  
		SetScenarioTypeEnabled(WORLD_VEHICLE_POLICE_NEXT_TO_CAR, true)  
		SetCreateRandomCops(true)  
		SetCreateRandomCopsNotOnScenarios(true)
		SetCreateRandomCopsOnScenarios(true) 	
		SetVehicleModelIsSuppressed(GetHashKey("police"), false)  
		SetVehicleModelIsSuppressed(GetHashKey("police2"), false)  
		SetVehicleModelIsSuppressed(GetHashKey("police3"), false)  
		SetVehicleModelIsSuppressed(GetHashKey("police4"), false)  
		SetVehicleModelIsSuppressed(GetHashKey("policeb"), false)  
		SetVehicleModelIsSuppressed(GetHashKey("policet"), false)  
		SetVehicleModelIsSuppressed(GetHashKey("pranger"), false)  
		SetVehicleModelIsSuppressed(GetHashKey("sheriff"), false)	
		SetVehicleModelIsSuppressed(GetHashKey("sheriff2"), false)	
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			SetDispatchIdealSpawnDistance(490.0) --Ensure no pop-ins while driving fast
		else
			SetDispatchIdealSpawnDistance(200.0)
		end
	end
end)

-- Ignore PD5M Police Job 
arrestable = true
Citizen.CreateThread(function()
  while true do
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
    Wait(2000)
  end
end)
RegisterCommand('policeonduty', function()
    if PlayerData.job.name == 'police' then
		if arrestable == true then
			ESX.ShowHelpNotification("~b~On Duty")
			SetMaxWantedLevel(0)
			arrestable = false
		else 
			exports["mythic_notify"]:SendAlert("inform", "Already On Duty")
		end
	else 
		ESX.ShowNotification("Take ~b~Police~w~ Job")
    end
end)
RegisterCommand('policeoffduty', function()
    if PlayerData.job.name == 'police' then
		if arrestable == false then
			ESX.ShowNotification("Off Duty")
			SetMaxWantedLevel(5)
			arrestable = true
		else 
			exports["mythic_notify"]:SendAlert("inform", "Already Off Duty")
		end
	else 
		exports["mythic_notify"]:SendAlert("error", "Take Police Job from F5")
    end
end)

--Reset PD5M Job exepmtion if crime is committed
Citizen.CreateThread(function()
  while true do
	local playerPed2 = PlayerId()
	local wantedlevel = GetPlayerWantedLevel(playerPed2)
	if wantedlevel > 0 then
		arrestable = true
	end
    Wait(3000)
  end
end)

-- Enumeration
local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}
local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
      
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
      
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
      
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end
function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end
function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
function GetAllPeds()
    local peds = {}
    for ped in EnumeratePeds() do
        if DoesEntityExist(ped) then
            table.insert(peds, ped)
        end
    end
    return peds
end
function GetAllVehicles()
    local vehicles = {}
    for vehicle in EnumerateVehicles() do
        if DoesEntityExist(vehicle) then
            table.insert(vehicles, vehicle)
        end
    end
    return vehicles
end

-- NPC Modifications/Ambiance
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		StartAudioScene('CHARACTER_CHANGE_IN_SKY_SCENE')
		SetAudioFlag("PoliceScannerDisabled", true)
		AddRelationshipGroup('Prisonnpcs')
		AddRelationshipGroup('Players')
		local playerPed = GetPlayerPed(-1)
		local playerPed2 = PlayerId()
		local pCoords = GetEntityCoords(playerPed, true)
		for Ped in EnumeratePeds() do
			if Ped ~= playerPed and Ped ~= playerPed2 then 
				local tCoords = GetEntityCoords(Ped, true)
				local incar = IsPedInAnyVehicle(playerPed, false)
				local pedtype = GetPedType(Ped, false)
				--Give Weapons to Peds and modify NPC accuracy
				if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, tCoords.x, tCoords.y, tCoords.z, true) <= 100.0 and pedtype ~= 6 then 
					local chance = math.random(1,50)
					if chance == 1 then
						GiveWeaponToPed(Ped, GetHashKey("WEAPON_HEAVYPISTOL"), 40, false, false)
						SetPedAccuracy(Ped, 10)
					end
				end
				--Give Stunguns to Cops if Wanted < 2 and modify NPC police accuracy
				if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, tCoords.x, tCoords.y, tCoords.z, true) <= 100.0 then 
					if pedtype == 6 then
						SetPedAccuracy(Ped, 15)
						local wantedlevel = GetPlayerWantedLevel(playerPed2)
						if wantedlevel == 1 or wantedlevel == 2 then
							GiveWeaponToPed(Ped, GetHashKey("WEAPON_STUNGUN_MP"), 120, false, false)
							SetCurrentPedWeapon(Ped, GetHashKey("WEAPON_STUNGUN_MP"), 120, true)
						end
					end
				end
				--Calm Prison NPCs
				if GetDistanceBetweenCoords(tCoords.x, tCoords.y, tCoords.z, 1690.79, 2565.38, 45.91, true) <= 125.0 then 
					SetPedRelationshipGroupHash(playerPed, 'Players')
					SetPedRelationshipGroupHash(Ped, 'Prisonnpcs')
					SetRelationshipBetweenGroups(3, 'Players', 'Prisonnpcs')
				end
			end
		end
    end
end)

-- NPC Vehicle Modifications
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		local playerPed = GetPlayerPed(-1)
		local playerPed2 = PlayerId()
		local pCoords = GetEntityCoords(playerPed, true)
		local wantedlevel = GetPlayerWantedLevel(playerPed2)
		for vehicle in EnumerateVehicles() do
			local vtype = GetVehicleClass(vehicle)
			local vCoords = GetEntityCoords(vehicle, true)
			local copped = GetPedInVehicleSeat(vehicle, -1)
			local pedvehicle = GetVehiclePedIsIn(playerPed, false)
			local speed = GetEntitySpeed(pedvehicle)
			local mphcalc = speed * 2.236936
			local inpedvehicle = IsPedInVehicle(playerPed, pedvehicle, false)
			--Warrant Detection
			if arrestable == true then
				if HasEntityClearLosToEntityInFront(copped, playerPed) then
					if vtype == 18 and DoesEntityExist(copped) then
						if hidden == true then
							if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, vCoords.x, vCoords.y, vCoords.z, true) <= 10.0 then 
								if copped ~= playerPed and copped ~= playerPed2 then 
									TriggerServerEvent('warrant:getwanted')
								end
							end
						elseif hidden == false then
							if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, vCoords.x, vCoords.y, vCoords.z, true) <= 20.0 then 
								if copped ~= playerPed and copped ~= playerPed2 then 
									TriggerServerEvent('warrant:getwanted')
								end
							end
						end
					end
				end
			end
			--Stolen Vehicle Detection
			if wantedlevel == 0 then
				if vtype == 18 and DoesEntityExist(copped) and HasEntityClearLosToEntityInFront(copped, playerPed) then
					if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, vCoords.x, vCoords.y, vCoords.z, true) <= 35.0 then 
						if copped ~= playerPed and copped ~= playerPed2 and pedvehicle ~= nil then 
							local vehplate = ESX.Math.Trim(GetVehicleNumberPlateText(pedvehicle))
							TriggerServerEvent('warrant:checkstolen', vehplate)
						end
					end
				end
			end
			--Speeding Tickets from NPC Cops
			if vtype == 18 then  
				local vCoords = GetEntityCoords(vehicle, true)
				if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, vCoords.x, vCoords.y, vCoords.z, true) <= 35.0 then 
					if copped ~= playerPed and copped ~= playerPed2 and wantedlevel == 0 and inpedvehicle == 1 and arrestable == true 
					and HasEntityClearLosToEntityInFront(copped, playerPed) then
						if mphcalc >= 45.0 and mphcalc <= 70.9 and DoesEntityExist(copped) and ESX.PlayerData.job.name ~= 'police' then
							local mph = ESX.Math.Round(mphcalc)
							exports['mythic_notify']:SendAlert("inform", 'Radar Detected - '..mph..' / 65 mph', 1500)
						end
						if mphcalc >= 71.0 and mphcalc <= 139.9 and DoesEntityExist(copped) and ESX.PlayerData.job.name ~= 'police' then
							local mph = ESX.Math.Round(mphcalc)
							SetEntityAsMissionEntity(vehicle, true, true)
							SetEntityAsMissionEntity(copped, true, true)
							SetEntityInvincible(vehicle, true)
							exports['mythic_notify']:SendAlert("error", 'Radar Detected - '..mph..' / 65 mph', 2500)
							Citizen.Wait(2000)
							TaskVehicleFollow(copped, vehicle, pedvehicle, 35.0, 572, 20)
							Citizen.Wait(20000)
							SetVehicleSiren(vehicle, true)
							exports['progressBars']:startUI(20000, "PULL OVER...")
							Citizen.Wait(20000)
							local speed2 = GetEntitySpeed(pedvehicle)
							local mphcalc2 = speed2 * 2.236936
							local pCoords = GetEntityCoords(playerPed, true)
							local copCoords = GetEntityCoords(copped, true)
							local distance = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, copCoords.x, copCoords.y, copCoords.z, true) 
							local driverdoor = GetWorldPositionOfEntityBone(pedvehicle, GetEntityBoneIndexByName(pedvehicle, "door_dside_f"))
							local wantedlevel2 = GetPlayerWantedLevel(playerPed2)
							if mphcalc2 <= 2.5 and wantedlevel2 == 0 and distance <= 25.0 then
								exports['mythic_notify']:SendAlert("error", 'Engine Off')
								exports['mythic_notify']:SendAlert("inform", 'Window Down')
								Citizen.Wait(3000)
								TaskLeaveVehicle(copped, vehicle, 0)
								TaskGoToCoordAnyMeans(copped, pCoords, 1.0, 0, 786603, 0xbf800000)
								Citizen.Wait(15000)
								TriggerServerEvent('warrant:speedingticket')
								exports['mythic_notify']:SendAlert("inform", 'You have been fined $500 for speeding')
								exports['mythic_notify']:SendAlert("success", 'You are free to go')
								SetPedAsNoLongerNeeded(copped)
								SetVehicleAsNoLongerNeeded(vehicle)
							elseif mphcalc2 <= 2.5 and wantedlevel2 == 0 and distance >= 25.0 then
								TriggerServerEvent('warrant:speedingticket')
								Citizen.Wait(1000)
								exports['mythic_notify']:SendAlert("error", 'The officer has been called away')
								exports['mythic_notify']:SendAlert("inform", 'Your plate has been fined $500 for speeding')
								exports['mythic_notify']:SendAlert("success", 'You are free to go')
								SetPedAsNoLongerNeeded(copped)
								SetVehicleAsNoLongerNeeded(vehicle)
							elseif mphcalc2 > 2.5 and wantedlevel2 == 0 then 
								exports['mythic_notify']:SendAlert("inform", 'Failed to Stop')
								exports['mythic_notify']:SendAlert("error", 'A Warrant has been issued for your arrest')
								SetPlayerWantedLevel(PlayerId(), 1, false)
								SetPlayerWantedLevelNow(PlayerId(), false)
								Citizen.Wait(200)
								SetPedAsNoLongerNeeded(copped)
								SetVehicleAsNoLongerNeeded(vehicle)
							else
								SetPedAsNoLongerNeeded(copped)
								SetVehicleAsNoLongerNeeded(vehicle)
							end
						end
						if mphcalc >= 140.0 and DoesEntityExist(copped) and ESX.PlayerData.job.name ~= 'police' then
							local mph = ESX.Math.Round(mphcalc)
							exports['mythic_notify']:SendAlert("error", 'Radar Detected - '..mph..' / 135 mph', 2500)
							Citizen.Wait(1000)
							exports['mythic_notify']:SendAlert("success", 'Excessive Speeding')
							exports['mythic_notify']:SendAlert("inform", 'A Warrant has been issued for your arrest')
							SetPlayerWantedLevel(PlayerId(), 1, false)
							SetPlayerWantedLevelNow(PlayerId(), false)
							Citizen.Wait(200)
							SetPedAsNoLongerNeeded(copped)
							SetVehicleAsNoLongerNeeded(vehicle)
						end
					end
				end
			end
		end
    end
end)

-- Cops don't track vehicle without line-of-sight
Citizen.CreateThread(function()
	while true do
		local playerPed = GetPlayerPed(-1)
		local incar = IsPedInAnyVehicle(playerPed, false)
		if incar then 
			local pedvehicle = GetVehiclePedIsIn(playerPed, false)
			SetPoliceFocusWillTrackVehicle(pedvehicle, false)
		end
		Citizen.Wait(3000)
    end
end)

-- Warrant Update Thread
spotted = false
jailed = false
Citizen.CreateThread(function(warrant)
	while true do
		local playerPed = PlayerId()
		local wantedlevel = GetPlayerWantedLevel(playerPed)
		if wantedlevel >= 1 and jailed == false then
			TriggerServerEvent('warrant:checkwarrantbeforerecord', warrant)
		end
		if wantedlevel == 0 then
			spotted = false
		end
		Citizen.Wait(10000)
    end
end)

-- Warrant Update Thread Return
RegisterNetEvent('warrant:recordingwanted')
AddEventHandler('warrant:recordingwanted', function(warrant)
	local playerPed = PlayerId()
	local wantedlevel = GetPlayerWantedLevel(playerPed)
	if warrant > wantedlevel then
		TriggerServerEvent('warrant:recordwanted', warrant)
	elseif warrant <= wantedlevel then
		TriggerServerEvent('warrant:recordwanted', wantedlevel)
	end
end)

-- Warrant check
RegisterCommand('checkwarrant', function(warrant)
	TriggerServerEvent('warrant:checkwanted', warrant)
end, false)

-- Warrant check return
RegisterNetEvent('warrant:checkwanted')
AddEventHandler('warrant:checkwanted', function(warrant)
	if warrant >= 1 then
		exports['mythic_notify']:SendAlert("inform", 'Warrant Level:')
		exports['mythic_notify']:SendAlert("error", warrant)
	elseif warrant == 0 then
		exports['mythic_notify']:SendAlert("success", 'No Warrants')
	end
end)

-- Warrant detection area reduction
hidden = false
RegisterNetEvent('warrant:reducedetection')
AddEventHandler('warrant:reducedetection', function(activated)
	hidden = activated
end)
	
-- Warrant Detection - Patrol
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		local playerPed = GetPlayerPed(-1)
		local playerPed2 = PlayerId()
		local pCoords = GetEntityCoords(playerPed, true)
		if hidden == true then
			local copcoords = GetEntityCoords(playerPed, true) + 10
			local iscopinarea = IsCopPedInArea_3d(pCoords.x, pCoords.y, pCoords.z, copcoords.x, copcoords.y, copcoords.z)
			if iscopinarea == 1 then
				if arrestable == true then
					TriggerServerEvent('warrant:getwanted')
				end
			end
		elseif hidden == false then
			local copcoords = GetEntityCoords(playerPed, true) + 20
			local iscopinarea = IsCopPedInArea_3d(pCoords.x, pCoords.y, pCoords.z, copcoords.x, copcoords.y, copcoords.z)
			if iscopinarea == 1 then
				if arrestable == true then
					TriggerServerEvent('warrant:getwanted')
				end
			end
		end
    end
end)	

-- Warrant activation
RegisterNetEvent('warrant:getwanted')
AddEventHandler('warrant:getwanted', function(wanted)
	if wanted >= 1 and spotted == false then
		local wantedlevel = wanted
		SetPlayerWantedLevel(PlayerId(), wantedlevel, false)
		SetPlayerWantedLevelNow(PlayerId(), false)
		notify(wantedlevel)
		spotted = true
		Citizen.Wait(5000)
	end
end)

-- Warrant Clear - Charity Contribution
RegisterNetEvent('warrant:charitycontribution')
AddEventHandler('warrant:charitycontribution', function()
	TriggerServerEvent('warrant:getwantedcharity')
end)

-- Warrant Clear - Charity Contribution Return
negotiating = false
donation = 0
RegisterNetEvent('warrant:charitycontributionreturn')
AddEventHandler('warrant:charitycontributionreturn', function(wanted)
	negotiating = true
	if wanted < 2 then
		donation = 5000
	elseif wanted == 2 then
		donation = 10000
	elseif wanted == 3 then
		donation = 20000
	elseif wanted == 4 then
		donation = 50000
	elseif wanted == 5 then
		donation = 100000
	end
	if wanted == 0 then
		ESX.ShowHelpNotification("You have no outstanding warrants\n\nA standard donation is ~g~$50,000")
		Citizen.Wait(5000)
		ESX.ShowHelpNotification("Would you still like to donate to charity?\n\nExit the phone and press ~INPUT_CONTEXT~")
	else
		ESX.ShowHelpNotification("Your Warrant Level is ~r~"..wanted.."~w~\n\nYour donation would need to be ~g~$"..ESX.Math.GroupDigits(donation))
		Citizen.Wait(5000)
		ESX.ShowHelpNotification("Do you want to donate?\n\nExit the phone and press ~INPUT_CONTEXT~")
	end
	Citizen.Wait(15000)
	negotiating = false
end)

-- Warrant Clear - Charity Contribution Confirmation
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if negotiating ~= true then
			Citizen.Wait(3000)
		elseif negotiating == true then
			if IsControlJustPressed(0, 38) then
				TriggerServerEvent('warrant:donationpayment', donation)	
				negotiating = false
			end
		end
    end
end)

-- Wanted Notification
function notify(wantedlevel)
	local playerPed2 = PlayerId()
	local deadman = IsPlayerDead(playerPed2)
	if not deadman then
		exports['mythic_notify']:SendAlert("inform", 'WARRANT')
		exports['mythic_notify']:SendAlert("error", wantedlevel)
	end
end

-- Stolen Vehicle Warrant
RegisterNetEvent('warrant:activatestolen')
AddEventHandler('warrant:activatestolen', function(stolen)
	local playerPed2 = PlayerId()
	local wantedlevel2 = GetPlayerWantedLevel(playerPed2)
	if stolen == 1 and wantedlevel2 == 0 then
		exports['mythic_notify']:SendAlert("error", 'Your plates were just scanned', 1000)
		Citizen.Wait(3000)
		exports['mythic_notify']:SendAlert("inform", 'Warrant Issued')
		exports['mythic_notify']:SendAlert("error", 'Stolen Vehicle')
		SetPlayerWantedLevel(PlayerId(), 2, false)
		SetPlayerWantedLevelNow(PlayerId(), false)
		Citizen.Wait(200)
	end
end)

--Surrender Command
surrendered = false
RegisterCommand('surrender', function(source)
	if GetPlayerWantedLevel(PlayerId()) ~= 0 then
		if not IsPedInAnyVehicle(PlayerId(), false) then
			if surrendered == false then
				surrendered = true
				jailyourass()
			end
		end
	else 
		exports['mythic_notify']:SendAlert("success", 'No wanted level')
	end
end)

--Auto Surrender When Stunned
secondsleft = 10
surrendered = false
Citizen.CreateThread(function()
	while true do
		local playerPed = GetPlayerPed(-1)
		local beingstunned = IsPedBeingStunned(playerPed)
		if beingstunned then
			if arrestable == true then
				if secondsleft > 0 then
					ESX.ShowHelpNotification('AutoSurrender in ~r~'..secondsleft) 
					secondsleft = secondsleft - 1
				else
					ESX.ShowHelpNotification('~r~AutoSurrender') 
					ExecuteCommand("surrender")
					surrendered = true
				end
			end
		end
		Citizen.Wait(1000)
    end
end)	

--Turn yourself in
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local surrendercoordsprison = vector3(1847.45, 2585.93, 45.67)
		local surrendercoordssandy = vector3(1854.07, 3687.32, 34.27)
		local surrendercoordspaleto = vector3(-447.25, 6014.16, 31.72)
		local surrendercoordsvespucci = vector3(-1093.43, -809.07, 19.28)
		local surrendercoordsrockford = vector3(-561.12, -133.16, 38.06)
		local surrendercoordsvinewood = vector3(640.22, 1.19, 82.79)
		local surrendercoordsmissionrow = vector3(441.24, -981.89, 30.69)
		local surrendercoordslamesa = vector3(825.79, -1290.09, 28.24)
		if #(pedCoords - surrendercoordsprison) < 200.0 
		or #(pedCoords - surrendercoordssandy) < 200.0 
		or #(pedCoords - surrendercoordspaleto) < 200.0 
		or #(pedCoords - surrendercoordsvespucci) < 200.0 
		or #(pedCoords - surrendercoordsrockford) < 200.0 
		or #(pedCoords - surrendercoordsvinewood) < 200.0 
		or #(pedCoords - surrendercoordsmissionrow) < 200.0 
		or #(pedCoords - surrendercoordslamesa) < 200.0 
		then
			--DrawMarker(27, surrendercoordsprison.x, surrendercoordsprison.y, surrendercoordsprison.z-0.95, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 0, 0, 200, 0, 0, 0, 0)
			DrawMarker(27, surrendercoordssandy.x, surrendercoordssandy.y, surrendercoordssandy.z-0.95, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 0, 0, 200, 0, 0, 0, 0)
			DrawMarker(27, surrendercoordspaleto.x, surrendercoordspaleto.y, surrendercoordspaleto.z-0.95, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 0, 0, 200, 0, 0, 0, 0)
			DrawMarker(27, surrendercoordsvespucci.x, surrendercoordsvespucci.y, surrendercoordsvespucci.z-0.95, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 0, 0, 200, 0, 0, 0, 0)
			DrawMarker(27, surrendercoordsrockford.x, surrendercoordsrockford.y, surrendercoordsrockford.z-0.95, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 0, 0, 200, 0, 0, 0, 0)
			DrawMarker(27, surrendercoordsvinewood.x, surrendercoordsvinewood.y, surrendercoordsvinewood.z-0.95, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 0, 0, 200, 0, 0, 0, 0)
			DrawMarker(27, surrendercoordsmissionrow.x, surrendercoordsmissionrow.y, surrendercoordsmissionrow.z-0.95, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 0, 0, 200, 0, 0, 0, 0)
			DrawMarker(27, surrendercoordslamesa.x, surrendercoordslamesa.y, surrendercoordslamesa.z-0.95, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 255, 0, 0, 200, 0, 0, 0, 0)
			--if #(pedCoords - surrendercoordsprison) < 2.0 
			--or #(pedCoords - surrendercoordssandy) < 2.0 
			if #(pedCoords - surrendercoordssandy) < 2.0 
			or #(pedCoords - surrendercoordspaleto) < 2.0 
			or #(pedCoords - surrendercoordsvespucci) < 2.0 
			or #(pedCoords - surrendercoordsrockford) < 2.0 
			or #(pedCoords - surrendercoordsvinewood) < 2.0 
			or #(pedCoords - surrendercoordsmissionrow) < 2.0 
			or #(pedCoords - surrendercoordslamesa) < 2.0 
			then
				ESX.ShowNotification('Press ~r~E~w~ to Turn Yourself In') 
				if IsControlJustPressed(0, 38) then
					TriggerServerEvent('warrant:getwanted')
					Citizen.Wait(200)
					ExecuteCommand("surrender")
				end
			end
		end
	end
end)

--Jail Function
local enable = false
local heading = 360.00
local signmodel = GetHashKey("prop_police_id_board")
local textmodel = GetHashKey("prop_police_id_text")
local text = {}
local cam = nil
local cam2 = nil
local cam3 = nil
local cam4 = nil
local coords = nil
local SignProp1 = {}
local SignProp2 = {}
local isinjail = false

function jailyourass(source)
	local dict = 'random@mugging3'
	local wantedlevel = (GetPlayerWantedLevel(PlayerId()))
	local jailtime = wantedlevel * 86400000
	FreezeEntityPosition(PlayerPedId(), true)
    RequestAnimDict(dict)
    Citizen.Wait(200)
	TaskPlayAnim(PlayerPedId(), dict, 'handsup_standing_base', 8.0, -8, .01, 49, 0, 0, 0, 0)
	SetPlayerWantedLevel(PlayerId(), 0, false)
	SetPlayerWantedLevelNow(PlayerId(), false)
	SetPlayerWantedLevel(PlayerId(), 1, false)
	SetPlayerWantedLevelNow(PlayerId(), false)
    Citizen.Wait(200)
	ESX.ShowHelpNotification ('~r~JAILED - WANTED LEVEL '..wantedlevel)
	Citizen.Wait(5000)
	DoScreenFadeOut(3000)
	Citizen.Wait(3000)
	SetPlayerWantedLevel(PlayerId(), 0, false)
	SetPlayerWantedLevelNow(PlayerId(), false)
	SetMaxWantedLevel(0)
	TriggerServerEvent('warrant:removewanted')
	TriggerServerEvent('warrant:recordjailtime', jailtime)
	exports['mythic_notify']:SendAlert("success", 'Warrants Cleared')
	exports['mythic_notify']:SendAlert("inform", 'You must serve '..ESX.Math.Round(jailtime/3600000)..' hours in jail')
    SetEntityCoords(PlayerPedId(), 402.8, -996.6, -100.00, 0.0, 0.0, 0.0, true)
    SetEntityHeading(PlayerPedId(), 175.14)
	CreateCam()
    SignProp1 = CreateObject(signmodel, 1, 1, 1, false, true, false)
    SignProp2 = CreateObject(textmodel, 1, 1, 1, false, true, false)
    AttachEntityToEntity(SignProp1, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 58868), 0.12, 0.24, 0.0, 5.0, 0.0, 70.0, true, true, false, false, 2, true);
    AttachEntityToEntity(SignProp2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 58868), 0.12, 0.24, 0.0, 5.0, 0.0, 70.0, true, true, false, false, 2, true);
    DestroyAllCams(true)
    cam3 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 402.92, -1000.72, -99.01, 0.00, 0.00, 0.00, 50.00, false, 0)
    SetCamActive(cam3, true)
    DoScreenFadeIn(2000)
    Citizen.Wait(2000)
	RemoveAllPedWeapons(GetPlayerPed(-1), false)
    RequestAnimDict("mp_character_creation@lineup@male_a")
    Citizen.Wait(200)
    TaskPlayAnim(PlayerPedId(), "mp_character_creation@lineup@male_a", "outro", 1.0, 1.0, 20000, 0, 1, 0, 0, 0)
    cam4 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 402.99, -998.02, -99.00, 0.00, 0.00, 0.00, 70.00, false, 0)
    PointCamAtCoord(cam4, 402.99, -998.02, -99.00)
    SetCamActiveWithInterp(cam4, cam3, 20000, true, true)
    Citizen.Wait(4000)
    RenderScriptCams(false, true, 500, true, true)      
    RequestAnimDict("mp_character_creation@customise@male_a")
    Citizen.Wait(200)
    DeleteObject(SignProp1)
    DeleteObject(SignProp2)
    TaskPlayAnim(PlayerPedId(), "mp_character_creation@customise@male_a", "intro", 1.0, 1.0, 5000, 0, 1, 0, 0, 0)
	ESX.TriggerServerCallback('esx_ambulancejob:removeillegalitems')
	DoScreenFadeOut(3000)
	Citizen.Wait(3000)
	SetEntityCoords(PlayerPedId(), 1690.79, 2565.38, 45.91, false, false, false, true)
	DoScreenFadeIn(3000)
	FreezeEntityPosition(PlayerPedId(), false)
	TriggerServerEvent('warrant:checkjail')
end
function CreateCam()
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 415.55, -998.50, -99.29, 0.00, 0.00, 89.75, 50.00, false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 2000, true, true) 
end	

--Update Tick
Citizen.CreateThread(function()
	while true do
		TriggerServerEvent('warrant:checkjail')
		Citizen.Wait(10000)
	end
end)

--Jail Catch
isoutofjail = true
RegisterNetEvent('warrant:checkjailreturn')
AddEventHandler('warrant:checkjailreturn', function(data)
	local isjailed = data
	if isjailed then
		TriggerServerEvent('warrant:removewanted')
		jailed = true
		isinjail = true
		if isoutofjail then
			ESX.ShowNotification("In ~r~Jail")
			SetMaxWantedLevel(0)
			Citizen.Wait(3000)
			isoutofjail = false
			local player = PlayerPedId()
			local playermodel = GetEntityModel(player)
			if playermodel == -1667301416 then --MP Female
				SetPedMaxHealth(player, 200)
				SetPedComponentVariation(player, 0, -1, 0, 0)
				SetPedComponentVariation(player, 1, -1, 0, 0)
				SetPedComponentVariation(player, 3, 0, 0, 0)
				SetPedComponentVariation(player, 4, 3, 15, 0)
				SetPedComponentVariation(player, 5, -1, 0, 0)
				SetPedComponentVariation(player, 6, 4, 1, 0)
				SetPedComponentVariation(player, 7, -1, 0, 0)
				SetPedComponentVariation(player, 8, -1, 0, 0)
				SetPedComponentVariation(player, 9, -1, 0, 0)
				SetPedComponentVariation(player, 10, -1, 0, 0)
				SetPedComponentVariation(player, 11, 0, 0, 0)
			elseif playermodel == 1885233650 then --MP Male 
				SetPedComponentVariation(player, 0, -1, 0, 0)
				SetPedComponentVariation(player, 1, -1, 0, 0)
				SetPedComponentVariation(player, 3, 0, 0, 0)
				SetPedComponentVariation(player, 4, 7, 15, 0)
				SetPedComponentVariation(player, 5, -1, 0, 0)
				SetPedComponentVariation(player, 6, 42, 2, 0)
				SetPedComponentVariation(player, 7, -1, 0, 0)
				SetPedComponentVariation(player, 8, -1, 0, 0)
				SetPedComponentVariation(player, 9, -1, 0, 0)
				SetPedComponentVariation(player, 10, -1, 0, 0)
				SetPedComponentVariation(player, 11, 0, 0, 0)
			end
		end
		Citizen.Wait(200)
		TriggerServerEvent('warrant:checkjailwhileinjail')
	end
end)

--Jail Time Tick
RegisterNetEvent('warrant:checkjailwhileinjailreturn')
AddEventHandler('warrant:checkjailwhileinjailreturn', function(data)
	local jtime = tonumber(data)
	if jtime >= 1 then
		Citizen.Wait(10)
		DisableControlAction(1, 246, true)
		local timer1 = GetGameTimer()
		local remaining = jtime - (GetGameTimer()-timer1)
		if (GetGameTimer()-timer1) < jtime and (GetGameTimer() >= timer1) then
			if remaining > 5400000 then 
				local remaining = jtime - 5000
				TriggerServerEvent('warrant:updatejailtime', remaining)
				ESX.ShowNotification("~g~"..ESX.Math.Round(remaining/3600000).."~w~ hours left")
			end 
			if remaining <= 5400000 and remaining > 115000 then 
				local remaining = jtime - 5000
				TriggerServerEvent('warrant:updatejailtime', remaining)
				ESX.ShowNotification("~g~"..ESX.Math.Round(remaining/60000).."~w~ minutes left")
			end
			if remaining <= 60000 and remaining > 0 then 
				local remaining = jtime - 5000
				TriggerServerEvent('warrant:updatejailtime', remaining)
				ESX.ShowNotification("Less than ~g~1~w~ minute left")
			end
		end
	else
		ESX.ShowNotification("You have ~g~Served~w~ your Jail Sentence")
		TriggerServerEvent('warrant:releasefromjail')
		exports['mythic_notify']:SendAlert("success", 'You are about to be released', 10000)
		exports['progressBars']:startUI(30000, "Processing Release...")
		Citizen.Wait(30000)
		DoScreenFadeOut(3000)
		Citizen.Wait(3000)
		DoScreenFadeIn(2000)
		SetEntityCoords(PlayerPedId(), 1853.31, 2586.06, 45.67, false, false, false, true)
		EnableControlAction(1, 246, true)
		ESX.TriggerServerCallback('esx_ambulancejob:removeillegalitems')
		Wait(200)
		ExecuteCommand('clothes')
		exports['mythic_notify']:SendAlert("success", 'Bye!')
		SetMaxWantedLevel(5)
		surrendered = false
		jtime = 0 
		TriggerServerEvent('warrant:updatejailtime', jtime)
		isoutofjail = true
		isinjail = false
		jailed = false
	end
end)

--Disable Phone
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if isinjail == true then
			DisableControlAction(1, 246, true)
		end
	end
end)

--Prison Gym
local isNearExersices = false
local isAtExersice = false
local isTraining = false
local isNearJob = false
local isAtJob = false
local isWorking = false
Citizen.CreateThread(function()
	if Config.EnableBlip then
		local blip = AddBlipForCoord( Config.MapBlip.Pos.x,  Config.MapBlip.Pos.y,  Config.MapBlip.Pos.z)
		SetBlipSprite (blip,  Config.MapBlip.Sprite)
		SetBlipDisplay(blip,  Config.MapBlip.Display)
		SetBlipScale  (blip,  Config.MapBlip.Scale)
		SetBlipColour (blip,  Config.MapBlip.Colour)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.MapBlip.Name)
		EndTextCommandSetBlipName(blip)
	end
	while true do
		Citizen.Wait(100)
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
		isNearExersices = false
		isAtExersice = false
		isNearJob = false
		isAtJob = false
		for k, v in pairs(Config.Exersices) do
			local distance = Vdist(playerCoords, v.x, v.y, v.z)
			if distance < 150.0 then
				isNearExersices = true
			end
			if distance < 1.5 then
				isAtExersice = true
				currentExersice = v
			end
		end
		for k, v in pairs(Config.Jobs) do
			local distance = Vdist(playerCoords, v.x, v.y, v.z)
			if distance < 150.0 then
				isNearJob = true
			end
			if distance < 1.5 then
				isAtJob = true
				currentJob = v
			end
		end
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if isNearExersices then
			for k, v in pairs(Config.Exersices) do
				--DrawMarker(21, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.301, 0.301, 0.3001, 0, 255, 55, 200, 0, 50, false, true, 2, nil, nil, false)
				DrawMarker(21, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.301, 0.301, 0.3001, 0, 255, 55, 200, true, true, 2, true, nil, nil, false)
			end
		end
		if isAtExersice then
			if not isTraining then
				--showInfobar(Config.ExersiceString .. '~y~' .. currentExersice.type)
					ESX.ShowNotification('Press ~g~[E]~w~ to use this machine')
			else
				--showInfobar(Config.AbortString)
					ESX.ShowHelpNotification('Press ~g~[E]~w~ to stop the set')
			end
			if IsControlJustReleased(0, Config.ExersiceKey) then
				
				if isTraining then
					isTraining = false	
					ClearPedTasksImmediately(PlayerPedId())
					FreezeEntityPosition(PlayerPedId(), false)
					SetEntityCollision(PlayerPedId(), true, true)
					--ShowNotification(Config.FinishString)
					SetEntityHeading(PlayerPedId(), 220.0)
				else
					if currentExersice.type == 'Chin Ups' then
						SetEntityCoords(PlayerPedId(), currentExersice.fixedChinPos.x, currentExersice.fixedChinPos.y, currentExersice.fixedChinPos.z - 1)
						SetEntityHeading(PlayerPedId(), currentExersice.fixedChinPos.rot)
					end
					if currentExersice.type == 'Bench Press' then
						SetEntityCoords(PlayerPedId(), currentExersice.fixedBenchPos.x, currentExersice.fixedBenchPos.y, currentExersice.fixedBenchPos.z - 1.9)
						SetEntityHeading(PlayerPedId(), currentExersice.fixedBenchPos.rot)
						SetEntityCollision(PlayerPedId(), false, false)
						FreezeEntityPosition(PlayerPedId(), true)
					end
					isTraining = true
					TaskStartScenarioInPlace(PlayerPedId(), currentExersice.scenario, 0, true)
					--SetEntityHeading(PlayerPedId(), 220.0)
					--workOut()
				end
				
			end
		end
		if isNearJob then
			for k, v in pairs(Config.Jobs) do
				--DrawMarker(21, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.301, 0.301, 0.3001, 0, 255, 55, 200, 0, 50, false, true, 2, nil, nil, false)
				DrawMarker(21, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 0.301, 0.301, 0.3001, 255, 255, 0, 200, true, true, 2, true, nil, nil, false)
			end
		end
		if isAtJob then
			if IsControlJustReleased(0, Config.ExersiceKey) and not isWorking then
				--SetEntityHeading(PlayerPedId(), currentJob.fixedPos.rot)
				--SetEntityHeading(PlayerPedId(), 220.0)
				SetEntityCollision(PlayerPedId(), false, false)
				FreezeEntityPosition(PlayerPedId(), true)
				isWorking = true
				TaskStartScenarioInPlace(PlayerPedId(), currentJob.scenario, 0, true)
				--workOut()
				exports['progressBars']:startUI(10000, "Working...")
				Citizen.Wait(10000)
				ClearPedTasksImmediately(PlayerPedId())
				FreezeEntityPosition(PlayerPedId(), false)
				SetEntityCollision(PlayerPedId(), true, true)
				--ShowNotification(Config.FinishString)
				TriggerServerEvent('warrant:reducejailtime')
				Citizen.Wait(2000)
				TriggerServerEvent('warrant:checkjail', jailtime)
				Citizen.Wait(2000)
				isWorking = false	
				--exports['mythic_notify']:SendAlert("success", 'Jail Time Reduced 1 Hour', 1500)
			end
		end
	end
end)

-- Reduce Jail Time by working
RegisterNetEvent('warrant:reducetime')
AddEventHandler('warrant:reducetime', function(data)
	local jtime = tonumber(data)
	if jtime >= 1 then
		local remaining = jtime - 3600000
		TriggerServerEvent('warrant:updatejailtime', remaining)
		ESX.ShowNotification("Time Reduced by ~g~1~w~ hour")
	end
end)
function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end
function showInfobar(msg)
	CurrentActionMsg  = msg
	SetTextComponentFormat('STRING')
	AddTextComponentString(CurrentActionMsg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

--[[function workOut()
	Citizen.Wait(Config.ExersiceDuration * 1000)
	ClearPedTasksImmediately(PlayerPedId())
	ShowNotification(Config.FinishString)
	isTraining = false
end--]]

--RegisterCommand('removewanted', function(source)
--	local source = PlayerId()
--	TriggerServerEvent('warrant:removewanted', source)
--end, false)

--Spawn Check (db, wip)
--AddEventHandler('playerSpawned', function()
--	ESX.TriggerServerCallback('warrant:getJailedStatus', function(shouldJail)
--		if shouldJail then
--			Citizen.Wait(1)
--			ESX.ShowHelpNotification ('~r~JAILED - WANTED LEVEL '..wantedlevel)
--			SetPlayerWantedLevel(PlayerId(), 1, false)
--			SetPlayerWantedLevelNow(PlayerId(), false)
--			jailyourass()
--			exports['mythic_notify']:SendAlert("inform", 'Tried to skip town?')
--		end
--	end)
--end)

