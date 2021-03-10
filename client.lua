RDX = nil

Citizen.CreateThread(function()
	while RDX == nil do
		TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end)
		Citizen.Wait(100)
	end
end)

local ButcherPrompt
local hasAlreadyEnteredMarker
local currentZone = nil

local PromptGorup = GetRandomIntInRange(0, 0xffffff)

function SetupButcherPrompt()
    Citizen.CreateThread(function()
        local str = 'Sell Hunt'
        ButcherPrompt = PromptRegisterBegin()
        PromptSetControlAction(ButcherPrompt, 0xE8342FF2)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(ButcherPrompt, str)
        PromptSetEnabled(ButcherPrompt, true)
        PromptSetVisible(ButcherPrompt, true)
        PromptSetHoldMode(ButcherPrompt, true)
        PromptSetGroup(ButcherPrompt, PromptGorup)
        PromptRegisterEnd(ButcherPrompt)
    end)
end

local blip = {}

if Config.Blips == true then
    Citizen.CreateThread(function()
        for _, info in pairs(Config.shops) do
            local number = #blip + 1
            blip[number] = N_0x554d9d53f696d002(1664425300, info.coords.x, info.coords.y, info.coords.z)
            SetBlipSprite(blip[number], -1665418949, 1)
            SetBlipScale(blip[number], 0.2)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip[number], 'Butcher')
        end  
    end)
end

Citizen.CreateThread(function()
    SetupButcherPrompt()
	while true do
		Wait(500)
		local isInMarker, tempZone = false
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for _,v in pairs(Config.shops) do 
            local distance = #(coords - v.coords)
            if distance < 2.5 then
                local holding = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
                if holding ~= false then
                    isInMarker  = true
                    tempZone = 'butcher'
                end
            end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			currentZone = tempZone
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			currentZone = nil
		end
	end
end)

function DeleteThis(holding)
    NetworkRequestControlOfEntity(holding)
    SetEntityAsMissionEntity(holding, true, true)
    Wait(100)
    DeleteEntity(holding)
    Wait(500)
    local entitycheck = Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())
    local holdingcheck = GetPedType(entitycheck)
    if holdingcheck == 0 then
        return true
    else
        return false
    end
end

function Selltobutcher()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    for k = 1, #Config.shops do 
        local distance = #(Config.shops[k]["coords"] - coords)
        if distance < 3.0 then
            local holding = Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
            local quality = Citizen.InvokeNative(0x31FEF6A20F00B963, holding)
            local model = GetEntityModel(holding)
            local type = GetPedType(holding)
            if holding ~= false then
                for i, row in pairs(Config.Animal) do
                    if type == 28 then
                        if model == Config.Animal[i]["model"] then
                            local reward = Config.shops[k]["gain"] * Config.Animal[i]["reward"]
                           

                            local deleted = DeleteThis(holding)
            
                            if deleted then
                                 TriggerServerEvent("cryptos_butcher:giveitem", Config.Animal[i]["item"], 1)
                                TriggerServerEvent("cryptos_butcher:reward", reward)
                                
                            else
                                --TriggerEvent("redemrp_notification:start", "DELETE ENTITY NATIVE IS SCUFFED - RELOG PLZ", 2, "success")
                            end

                        end
                    end
                    if quality ~= false then
                        if quality == Config.Animal[i]["poor"] then

                            local rewardresult = Config.shops[k]["gain"] * Config.Animal[i]["reward"]
                            local reward = rewardresult * 0.5
                          

                            local deleted = DeleteThis(holding)
            
                            if deleted then
                                TriggerServerEvent("cryptos_butcher:giveitem", Config.Animal[i]["item"], 1)
                                TriggerServerEvent("cryptos_butcher:reward", reward)
                               
                            else
                                --TriggerEvent("redemrp_notification:start", "DELETE ENTITY NATIVE IS SCUFFED - RELOG PLZ", 2, "success")
                            end

                        elseif quality == Config.Animal[i]["good"] then

                            local rewardresult = Config.shops[k]["gain"] * Config.Animal[i]["reward"]
                            local reward = rewardresult * 0.75
                           

                            local deleted = DeleteThis(holding)
            
                            if deleted then
                                TriggerServerEvent("cryptos_butcher:giveitem", Config.Animal[i]["item"], 1)
                                TriggerServerEvent("cryptos_butcher:reward", reward)
                                
                            else
                                --TriggerEvent("redemrp_notification:start", "DELETE ENTITY NATIVE IS SCUFFED - RELOG PLZ", 2, "success")
                            end

                        elseif quality == Config.Animal[i]["perfect"] then

                            local reward = Config.shops[k]["gain"] * Config.Animal[i]["reward"]
                         

                            local deleted = DeleteThis(holding)
            
                            if deleted then
                                TriggerServerEvent("cryptos_butcher:giveitem", Config.Animal[i]["item"], 1)
                                TriggerServerEvent("cryptos_butcher:reward", reward)
                            
                            else
                                --TriggerEvent("redemrp_notification:start", "DELETE ENTITY NATIVE IS SCUFFED - RELOG PLZ", 2, "success")
                            end

                        end
                    end
                end
            else
               -- TriggerEvent("redemrp_notification:start", "Not Holding Anything", 2, "error")
            end
        end
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        PromptSetEnabled(ButcherPrompt, false)
        PromptSetVisible(ButcherPrompt, false)
        for k,v in pairs(blip) do
            RemoveBlip(blip[k])
            DeleteEntity(butcher01)
             DeleteEntity(butcher02)
               DeleteEntity(butcher03)
                 DeleteEntity(butcher04)
                  DeleteEntity(butcher05)
                   DeleteEntity(butcher06)
        end
    end
end)

-- Key Controls for butcher01
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
 
 playerCoords = GetEntityCoords(PlayerPedId())
 butcher01Coords = GetEntityCoords(butcher01)     
       FreezeEntityPosition(butcher01, true)
        if GetDistanceBetweenCoords(playerCoords,butcher01Coords, true) < 3 and DoesEntityExist(butcher01) and GetEntityHealth(butcher01)  >= 1 then
            local label  = CreateVarString(10, 'LITERAL_STRING', "Butcher")
             PromptSetActiveGroupThisFrame(PromptGorup, label)
             NTRP.NPCText("Butcher", 0.40, 0.40, 0.5, 0.85, 164, 0, 20, 1)
             NTRP.NPCText(Config.Text, 0.35, 0.35, 0.5, 0.88, 255, 255, 255, 0)
            if PromptHasHoldModeCompleted(ButcherPrompt) and Citizen.InvokeNative(0xD806CD2A4F2C2996, PlayerPedId())then
                Selltobutcher()
				currentZone = nil
			end
        else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
 
 playerCoords = GetEntityCoords(PlayerPedId())
 butcher02Coords = GetEntityCoords(butcher02)      
       FreezeEntityPosition(butcher02, true)
        if GetDistanceBetweenCoords(playerCoords,butcher02Coords, true) < 3 and DoesEntityExist(butcher02) and GetEntityHealth(butcher02)  >= 1 then
            local label  = CreateVarString(10, 'LITERAL_STRING', "Butcher")
            PromptSetActiveGroupThisFrame(PromptGorup, label)
             NTRP.NPCText("Butcher", 0.40, 0.40, 0.5, 0.85, 164, 0, 20, 1)
             NTRP.NPCText(Config.Text, 0.35, 0.35, 0.5, 0.88, 255, 255, 255, 0)
            if PromptHasHoldModeCompleted(ButcherPrompt) then
                Selltobutcher()
				currentZone = nil
			end
        else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

 playerCoords = GetEntityCoords(PlayerPedId())
 butcher03Coords = GetEntityCoords(butcher03)      
       FreezeEntityPosition(butcher03, true)	
        if GetDistanceBetweenCoords(playerCoords,butcher03Coords, true) < 3 and DoesEntityExist(butcher03) and GetEntityHealth(butcher03)  >= 1 then
            local label  = CreateVarString(10, 'LITERAL_STRING', "Butcher")
            PromptSetActiveGroupThisFrame(PromptGorup, label)
             NTRP.NPCText("Butcher", 0.40, 0.40, 0.5, 0.85, 164, 0, 20, 1)
             NTRP.NPCText(Config.Text, 0.35, 0.35, 0.5, 0.88, 255, 255, 255, 0)
            if PromptHasHoldModeCompleted(ButcherPrompt) then
                Selltobutcher()
				currentZone = nil
			end
        else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

 playerCoords = GetEntityCoords(PlayerPedId())
 butcher04Coords = GetEntityCoords(butcher04)      
        FreezeEntityPosition(butcher04, true)
        if GetDistanceBetweenCoords(playerCoords,butcher04Coords, true) < 3 and DoesEntityExist(butcher04) and GetEntityHealth(butcher04)  >= 1 then
            local label  = CreateVarString(10, 'LITERAL_STRING', "Butcher")
            PromptSetActiveGroupThisFrame(PromptGorup, label)
             NTRP.NPCText("Butcher", 0.40, 0.40, 0.5, 0.85, 164, 0, 20, 1)
             NTRP.NPCText(Config.Text, 0.35, 0.35, 0.5, 0.88, 255, 255, 255, 0)
            if PromptHasHoldModeCompleted(ButcherPrompt)  then
                Selltobutcher()
				currentZone = nil
			end
        else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

 playerCoords = GetEntityCoords(PlayerPedId())
 butcher05Coords = GetEntityCoords(butcher05)      
        FreezeEntityPosition(butcher05, true)
        if GetDistanceBetweenCoords(playerCoords,butcher05Coords, true) < 3 and DoesEntityExist(butcher05) and GetEntityHealth(butcher05)  >= 1 then
            local label  = CreateVarString(10, 'LITERAL_STRING', "Butcher")
            PromptSetActiveGroupThisFrame(PromptGorup, label)
            NTRP.NPCText("Butcher", 0.40, 0.40, 0.5, 0.85, 164, 0, 20, 1)
            NTRP.NPCText(Config.Text, 0.35, 0.35, 0.5, 0.88, 255, 255, 255, 0)
            if PromptHasHoldModeCompleted(ButcherPrompt)  then
                Selltobutcher()
				currentZone = nil
			end
        else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
 
 playerCoords = GetEntityCoords(PlayerPedId())
 butcher06Coords = GetEntityCoords(butcher06)        
        FreezeEntityPosition(butcher06, true)
        if GetDistanceBetweenCoords(playerCoords,butcher06Coords, true) < 3 and DoesEntityExist(butcher06) and GetEntityHealth(butcher06)  >= 1 then
            local label  = CreateVarString(10, 'LITERAL_STRING', "Butcher")
            PromptSetActiveGroupThisFrame(PromptGorup, label)
            NTRP.NPCText("Butcher", 0.40, 0.40, 0.5, 0.85, 164, 0, 20, 1)
            NTRP.NPCText(Config.Text, 0.35, 0.35, 0.5, 0.88, 255, 255, 255, 0)
            if PromptHasHoldModeCompleted(ButcherPrompt) then
                Selltobutcher()
				currentZone = nil
			end
        else
			Citizen.Wait(500)
		end
	end
end)