ESX = nil
local dataHU     = nil
local datamaengel               = nil

-- Setze Blip für Job
-- JobMenü F6
local blips623226 = {
  {title="TÜV Dortmund", colour=11, id=209, x = -370.358, y = -116.163, z = 38.849}
}

Citizen.CreateThread(function()

 for _, info in pairs(blips623226) do
   info.blip = AddBlipForCoord(info.x, info.y, info.z)
   SetBlipSprite(info.blip, info.id)
   SetBlipDisplay(info.blip, 4)
   SetBlipScale(info.blip, 1.0)
   SetBlipColour(info.blip, info.colour)
   SetBlipAsShortRange(info.blip, true)
 BeginTextCommandSetBlipName("STRING")
   AddTextComponentString(info.title)
   EndTextCommandSetBlipName(info.blip)
 end
end)  


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'tuevdortmund', Config.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'tuevdortmund', 'tuevdortmund', 'society_tuevdortmund', 'society_tuevdortmund', 'society_tuevdortmund', {type = 'whitelisted'})

RegisterServerEvent('esx_tuevdortmundjob:giveWeapon')
AddEventHandler('esx_tuevdortmundjob:giveWeapon', function(weapon, ammo)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addWeapon(weapon, ammo)
end)

RegisterServerEvent('esx_tuevdortmundjob:confiscatePlayerItem')
AddEventHandler('esx_tuevdortmundjob:confiscatePlayerItem', function(target, itemType, itemName, amount)

  local sourceXPlayer = ESX.GetPlayerFromId(source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

    if itemType == 'item_standard' then

     local label = sourceXPlayer.getInventoryItem(itemName).label

     targetXPlayer.removeInventoryItem(itemName, amount)
     sourceXPlayer.addInventoryItem(itemName, amount)

	    sourceXPlayer.showNotification(_U('you_have_confinv') .. amount .. ' ' .. label .. _U('from') .. targetXPlayer.name)
    	targetXPlayer.showNotification( '~b~' .. targetXPlayer.name .. _U('confinv') .. amount .. ' ' .. label )

     end

     if itemType == 'item_account' then

      targetXPlayer.removeAccountMoney(itemName, amount)
      sourceXPlayer.addAccountMoney(itemName, amount)

    	sourceXPlayer.showNotification(_U('you_have_confdm') .. amount .. _U('from') .. targetXPlayer.name)
    	targetXPlayer.showNotification('~b~' .. targetXPlayer.name .. _U('confdm') .. amount)
	
     end

     if itemType == 'item_weapon' then

      targetXPlayer.removeWeapon(itemName)
      sourceXPlayer.addWeapon(itemName, amount)

	    sourceXPlayer.showNotification(_U('you_have_confweapon') .. ESX.GetWeaponLabel(itemName) .. _U('from') .. targetXPlayer.name)
	    targetXPlayer.showNotification('~b~' .. targetXPlayer.name .. _U('confweapon') .. ESX.GetWeaponLabel(itemName))
	
     end

end)

RegisterServerEvent('esx_tuevdortmundjob:handcuff')
AddEventHandler('esx_tuevdortmundjob:handcuff', function(target)
	TriggerClientEvent('esx_tuevdortmundjob:handcuff', target)
end)

RegisterServerEvent('esx_tuevdortmundjob:drag')
AddEventHandler('esx_tuevdortmundjob:drag', function(target)
	local _source = source
	TriggerClientEvent('esx_tuevdortmundjob:drag', target, _source)
end)

RegisterServerEvent('esx_tuevdortmundjob:putInVehicle')
AddEventHandler('esx_tuevdortmundjob:putInVehicle', function(target)
	TriggerClientEvent('esx_tuevdortmundjob:putInVehicle', target)
end)

RegisterServerEvent('esx_tuevdortmundjob:OutVehicle')
AddEventHandler('esx_tuevdortmundjob:OutVehicle', function(target)
	TriggerClientEvent('esx_tuevdortmundjob:OutVehicle', target)
end)

RegisterServerEvent('esx_tuevdortmundjob:getStockItem')
AddEventHandler('esx_tuevdortmundjob:getStockItem', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tuevdortmund', function(inventory)

		  local item = inventory.getItem(itemName)

	  	if item.count >= count then
		  	inventory.removeItem(itemName, count)
		  	xPlayer.addInventoryItem(itemName, count)
	  	else
		  	xPlayer.showNotification(_U('quantity_invalid'))
		  end

	  	xPlayer.showNotification(_U('have_withdrawn') .. count .. ' ' .. item.label)

  	end)

end)

RegisterServerEvent('esx_tuevdortmundjob:putStockItems')
AddEventHandler('esx_tuevdortmundjob:putStockItems', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

  	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tuevdortmund', function(inventory)

	  	local item = inventory.getItem(itemName)

		  if item.count >= 0 then
		  	xPlayer.removeInventoryItem(itemName, count)
		  	inventory.addItem(itemName, count)
		  else
		  	xPlayer.showNotification(_U('quantity_invalid'))
	  	end

		  xPlayer.showNotification(_U('added') .. count .. ' ' .. item.label)

  	end)

end)

ESX.RegisterServerCallback('esx_tuevdortmundjob:getOtherPlayerData', function(source, cb, target)

    if Config.EnableESXIdentity then

     local xPlayer = ESX.GetPlayerFromId(target)

     local identifier = GetPlayerIdentifiers(target)[1]

      local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
       ['@identifier'] = identifier
      })

     local user      = result[1]
     local firstname     = user['firstname']
     local lastname      = user['lastname']
     local sex           = user['sex']
     local dob           = user['dateofbirth']
     local height        = user['height'] .. " Inches"

     local data = {
      name        = GetPlayerName(target),
      job         = xPlayer.job,
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      weapons     = xPlayer.loadout,
      firstname   = firstname,
      lastname    = lastname,
      sex         = sex,
      dob         = dob,
      height      = height
     }

    TriggerEvent('esx_status:getStatus', source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end

    end)

    if Config.EnableLicenses then

      TriggerEvent('esx_license:getLicenses', source, function(licenses)
        data.licenses = licenses
        cb(data)
      end)

    else
      cb(data)
    end

  else

    local xPlayer = ESX.GetPlayerFromId(target)

    local data = {
      name       = GetPlayerName(target),
      job        = xPlayer.job,
      inventory  = xPlayer.inventory,
      accounts   = xPlayer.accounts,
      weapons    = xPlayer.loadout
    }

    TriggerEvent('esx_status:getStatus', _source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = status.getPercent()
      end

    end)

    TriggerEvent('esx_license:getLicenses', _source, function(licenses)
      data.licenses = licenses
    end)

    cb(data)

  end

end)




ESX.RegisterServerCallback('esx_tuevdortmundjob:getVehicleInfos', function(source, cb, plate)

	if Config.EnableESXIdentity then

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            dataHU = result[i].hu
            datamaengel = result[i].maengel
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local ownerName = result[1].firstname .. " " .. result[1].lastname

              local infos = {
                plate = plate,
                datamaengel = datamaengel,
                dataHU = dataHU,
                owner = ownerName
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  else

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            dataHU = result[i].hu
            datamaengel = result[i].maengel
            foundIdentifier = result[i].owner
            break
          end

          if datamaengel == nil then
            datamaengel = 'Keine Mängel gefunden'
            break
          end

         

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local infos = {
                plate = plate,
                datamaengel = datamaengel,
                dataHU = dataHU,
                owner = result[1].name
              }

              cb(infos)

            end
          )

        else

          local infos = {
            dataHU = dataHU,
            datamaengel = datamaengel,
          plate = plate
          }

          cb(infos)

        end

      end
    )

  end

end)

ESX.RegisterServerCallback('esx_tuevdortmundjob:getArmoryWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_tuevdortmund', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
		weapons = {}
		end

		cb(weapons)

	end)

end)

ESX.RegisterServerCallback('esx_tuevdortmundjob:addArmoryWeapon', function(source, cb, weaponName)
	
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeWeapon(weaponName)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_tuevdortmund', function(store)
		
		local weapons = store.get('weapons')

		if weapons == nil then
		weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
		if weapons[i].name == weaponName then
			weapons[i].count = weapons[i].count + 1
			foundWeapon = true
		end
		end

		if not foundWeapon then
		table.insert(weapons, {
			name  = weaponName,
			count = 1
		})
		end

		store.set('weapons', weapons)

		cb()

	end)

end)

ESX.RegisterServerCallback('esx_tuevdortmundjob:removeArmoryWeapon', function(source, cb, weaponName)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addWeapon(weaponName, 1000)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_tuevdortmund', function(store)

		local weapons = store.get('weapons')

		if weapons == nil then
		weapons = {}
		end

		local foundWeapon = false

		for i=1, #weapons, 1 do
		if weapons[i].name == weaponName then
			weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
			foundWeapon = true
		end
		end

		if not foundWeapon then
		table.insert(weapons, {
			name  = weaponName,
			count = 0
		})
		end

		store.set('weapons', weapons)

		cb()

	end)

end)


ESX.RegisterServerCallback('esx_tuevdortmundjob:buy', function(source, cb, amount)

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_tuevdortmund', function(account)

		if account.money >= amount then
		account.removeMoney(amount)
		cb(true)
		else
		cb(false)
		end
		
	end)
	
end)

ESX.RegisterServerCallback('esx_tuevdortmundjob:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_tuevdortmund', function(inventory)
		cb(inventory.items)
	end)
	
end)

ESX.RegisterServerCallback('esx_tuevdortmundjob:getPlayerInventory', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({
		items = items
	})

end)



ESX.RegisterServerCallback('esx_tuevdortmundjob:getFineList', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM tuev_types_tuev WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)

-- Liste alle Mängel auf
ESX.RegisterServerCallback('listmaengel', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM tuev_reports WHERE plate = @category', {
		['@category'] = 'NYR 110'
	}, function(mangel)
		cb(mangel)
	end)
end)


      RegisterServerEvent('esx_tuevdortmundjob:send')
      AddEventHandler('esx_tuevdortmundjob:send', function(label, amount, vehicle,plate)
      

        MySQL.Async.execute('INSERT INTO tuev_reports (reason, plate) VALUES (@identifier, @plate)', {
          ['@identifier'] = label, ['@plate'] = plate
        }, function(rowsChanged)
          xTarget.showNotification(_U('received_invoice'))
        end)
     
      end)


      ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
        local xPlayer = ESX.GetPlayerFromId(target)
      
        if xPlayer then
          MySQL.Async.fetchAll('SELECT amount, id, label FROM billing WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
          }, function(result)
            cb(result)
          end)
        else
          cb({})
        end
      end)

      --'Update TÜV' 
      RegisterServerEvent('esx_tuevupdatehu:Update')
      AddEventHandler('esx_tuevupdatehu:Update', function(plate)
        MySQL.ready(function ()
          MySQL.Sync.execute("UPDATE owned_vehicles set hu=@date WHERE plate=@identifier", {
            ['date']= os.date("%d.%m.%Y") ,['@identifier'] = plate})
      end)

        
     
      end)
      