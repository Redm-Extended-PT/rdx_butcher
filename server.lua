
RDX = nil
TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end)

RegisterServerEvent("cryptos_butcher:giveitem")
AddEventHandler("cryptos_butcher:giveitem", function(item, amount)
	local xPlayer = RDX.GetPlayerFromId(source)
            
                xPlayer.addInventoryItem(item, amount)
		
               
end)

RegisterServerEvent("cryptos_butcher:reward")
AddEventHandler("cryptos_butcher:reward", function(amount)
	local _amount = tonumber(string.format("%.2f", amount))
	local xPlayer = RDX.GetPlayerFromId(source)
    
	xPlayer.addMoney(_amount)
	
	
end)
