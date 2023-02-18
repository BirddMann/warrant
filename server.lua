ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('warrant:checkwarrantbeforerecord')
AddEventHandler('warrant:checkwarrantbeforerecord', function(src)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer then
		MySQL.Async.fetchScalar("SELECT wanted FROM users WHERE identifier = @identifier", 
		{
			['@identifier'] = xPlayer.getIdentifier()
		}, function(data)
			TriggerClientEvent('warrant:recordingwanted', src, data)
		end)
	end
end)

RegisterServerEvent('warrant:recordjailtime')
AddEventHandler('warrant:recordjailtime', function(jailtime)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local jailed = 1
	local jtime = jailtime
	if xPlayer then
		MySQL.Async.execute("UPDATE users SET jailtime = @jailtime WHERE identifier = @identifier",
		{
			['@identifier'] = xPlayer.identifier,
			['@jailtime'] = jtime
		})
		--xPlayer.showNotification(jtime)
		MySQL.Async.execute("UPDATE users SET is_jailed = @is_jailed WHERE identifier = @identifier",
		{
			['@identifier'] = xPlayer.identifier,
			['@is_jailed'] = jailed
		})
	end
end)

RegisterServerEvent('warrant:updatejailtime')
AddEventHandler('warrant:updatejailtime', function(remaining)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local jtime = remaining
	--xPlayer.showNotification(jtime)
	
	if xPlayer then
		MySQL.Async.execute("UPDATE users SET jailtime = @jailtime WHERE identifier = @identifier",
		{
			['@identifier'] = xPlayer.identifier,
			['@jailtime'] = jtime
		})
	end
end)

RegisterServerEvent('warrant:releasefromjail')
AddEventHandler('warrant:releasefromjail', function()
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local jailed = 0
	
	if xPlayer then
		MySQL.Async.execute("UPDATE users SET is_jailed = @is_jailed WHERE identifier = @identifier",
		{
			['@identifier'] = xPlayer.identifier,
			['@is_jailed'] = jailed
		})
	end
end)

RegisterServerEvent('warrant:recordwanted')
AddEventHandler('warrant:recordwanted', function(wantedlevel)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local wanted = wantedlevel
	
	if xPlayer then
		MySQL.Async.execute("UPDATE users SET wanted = @wanted WHERE identifier = @identifier",
		{
			['@identifier'] = xPlayer.identifier,
			['@wanted'] = wantedlevel
		})
		MySQL.Async.execute('UPDATE users SET `job` = @job WHERE identifier = @identifier',
		{
			['@job']       = 'unemployed',
			['@identifier'] = xPlayer.identifier
		})
	end
end)

RegisterServerEvent('warrant:getwanted')
AddEventHandler('warrant:getwanted', function(src)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer then
		MySQL.Async.fetchScalar("SELECT wanted FROM users WHERE identifier = @identifier", 
		{
			['@identifier'] = xPlayer.getIdentifier()
		}, function(data)
			TriggerClientEvent('warrant:getwanted', src, data)
		end)
	end
end)

RegisterServerEvent('warrant:getwantedcharity')
AddEventHandler('warrant:getwantedcharity', function(src)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer then
		MySQL.Async.fetchScalar("SELECT wanted FROM users WHERE identifier = @identifier", 
		{
			['@identifier'] = xPlayer.getIdentifier()
		}, function(data)
			TriggerClientEvent('warrant:charitycontributionreturn', src, data)
		end)
	end
end)

RegisterServerEvent('warrant:checkwanted')
AddEventHandler('warrant:checkwanted', function(src)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer then
		MySQL.Async.fetchScalar("SELECT wanted FROM users WHERE identifier = @identifier", 
		{
			['@identifier'] = xPlayer.getIdentifier()
		}, function(data)
			TriggerClientEvent('warrant:checkwanted', src, data)
		end)
	end
end)

RegisterServerEvent('warrant:checkjail')
AddEventHandler('warrant:checkjail', function(src)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer then
		MySQL.Async.fetchScalar("SELECT is_jailed FROM users WHERE identifier = @identifier", 
		{
			['@identifier'] = xPlayer.getIdentifier()
		}, function(data)
			--xPlayer.showNotification(data)
			TriggerClientEvent('warrant:checkjailreturn', src, data)
		end)
	end
end)

RegisterServerEvent('warrant:checkjailwhileinjail')
AddEventHandler('warrant:checkjailwhileinjail', function(src)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer then
		MySQL.Async.fetchScalar("SELECT jailtime FROM users WHERE identifier = @identifier", 
		{
			['@identifier'] = xPlayer.getIdentifier()
		}, function(data)
			TriggerClientEvent('warrant:checkjailwhileinjailreturn', src, data)
		end)
	end
end)

RegisterServerEvent('warrant:reducejailtime')
AddEventHandler('warrant:reducejailtime', function(src)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer then
		MySQL.Async.fetchScalar("SELECT jailtime FROM users WHERE identifier = @identifier", 
		{
			['@identifier'] = xPlayer.getIdentifier()
		}, function(data)
			TriggerClientEvent('warrant:reducetime', src, data)
		end)
	end
end)

ESX.RegisterServerCallback('warrant:checkoutstanding', function(source, cb, data)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		MySQL.Async.fetchScalar("SELECT wanted FROM users WHERE identifier = @identifier", 
		{
			['@identifier'] = xPlayer.getIdentifier()
		}, function(data)
		cb(data)
		--xPlayer.showNotification(data)
		end)
	else
		cb(data)
	end
end)

RegisterServerEvent('warrant:speedingticket')
AddEventHandler('warrant:speedingticket', function(src)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeAccountMoney('bank', 500)
end)

RegisterServerEvent('warrant:donationpayment')
AddEventHandler('warrant:donationpayment', function(donation)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getAccount("bank").money >= donation then 
		xPlayer.removeAccountMoney('bank', donation)
		xPlayer.ShowNotification("Thank you for your contribution to the city of ~g~Los Santos")
		xPlayer.ShowNotification("If you had any warrants, consider them forgotten...")
		local wantedlevel = '0'
		if xPlayer then
			MySQL.Async.execute("UPDATE users SET wanted = @wanted WHERE identifier = @identifier",
			{
				['@identifier'] = xPlayer.identifier,
				['@wanted'] = wantedlevel
			})
		end
	elseif xPlayer.getAccount("bank").money < donation then
		xPlayer.showNotification("You do not have enough in the ~b~Bank~w~ for a wire transfer")
	end
end)

RegisterServerEvent('warrant:checkstolen')
AddEventHandler('warrant:checkstolen', function(vehplate, isstolen)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)	
	local theplate = vehplate
	if xPlayer then
        MySQL.Async.fetchScalar("SELECT stolen FROM stolen_vehicles WHERE plate = @plate", 
		{
            ["@plate"] = theplate,
        }, function(data)
			TriggerClientEvent('warrant:activatestolen', src, data)
		end)
	end
end)

RegisterServerEvent('warrant:removewanted')
AddEventHandler('warrant:removewanted', function(wantedlevel)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local wantedlevel = '0'
	if xPlayer then
		MySQL.Async.execute("UPDATE users SET wanted = @wanted WHERE identifier = @identifier",
		{
			['@identifier'] = xPlayer.identifier,
			['@wanted'] = wantedlevel
		})
	end
end)	

--stolenvehiclesscavenged = false
--Citizen.CreateThread(function()
--  while true do
--    Citizen.Wait(1)
--	if stolenvehiclesscavenged == false then
--		MySQL.Async.execute("DELETE FROM stolen_vehicles WHERE 1", {
--		})
--		stolenvehiclesscavenged = true
--	elseif stolenvehiclesscavenged == true then
--		Citizen.Wait(8640000000)
--    end
--  end
--end)

