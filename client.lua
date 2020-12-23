ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)


ConfHs0              = {}
ConfHs0.DrawDistance = 100
ConfHs0.Size         = {x = 1.0, y = 1.0, z = 1.0}
ConfHs0.Color        = {r = 255, g = 255, b = 255}
ConfHs0.Type         = 36

local position = {
        {x = -1056.77,   y = -2650.44,  z = 13.83},        
}  

Citizen.CreateThread(function()
     for k in pairs(position) do
        local blip = AddBlipForCoord(position[k].x, position[k].y, position[k].z)
        SetBlipSprite(blip, 315)
        SetBlipColour(blip, 68)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Location")
        EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for k in pairs(position) do
            if (ConfHs0.Type ~= -1 and GetDistanceBetweenCoords(coords, position[k].x, position[k].y, position[k].z, true) < ConfHs0.DrawDistance) then
                DrawMarker(ConfHs0.Type, position[k].x, position[k].y, position[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ConfHs0.Size.x, ConfHs0.Size.y, ConfHs0.Size.z, ConfHs0.Color.r, ConfHs0.Color.g, ConfHs0.Color.b, 100, false, true, 2, false, false, false, false)
                letSleep = false
            end
        end

        if letSleep then
            Citizen.Wait(500)
        end
    end
end)

RMenu.Add('hs0_location', 'main', RageUI.CreateMenu("Location", "Louer vos meilleurs véhicules !"))


Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('hs0_location', 'main'), true, true, true, function()

            RageUI.Button("Blista", nil, {RightLabel = "~g~800$"},true, function(Hovered, Active, Selected)
            if (Selected) then   
                TriggerServerEvent('hs0_location:vehicule', 800)
                spawnCar("blista")
                RageUI.CloseAll()
            end
            end)

            RageUI.Button("Faggio", nil, {RightLabel = "~g~500$"},true, function(Hovered, Active, Selected)
            if (Selected) then   
                TriggerServerEvent('hs0_location:vehicule', 500)
                spawnCar("faggio")
                RageUI.CloseAll()
            end
            end)

                       RageUI.Button("Vélo", nil, {RightLabel = "~g~100$"},true, function(Hovered, Active, Selected)
            if (Selected) then   
                TriggerServerEvent('hs0_location:vehicule', 100)
                spawnCar("bmx")
                RageUI.CloseAll()
            end
            end)


        end, function()
        end)

        Citizen.Wait(0)
    end
end)



Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
    
            for k in pairs(position) do
    
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
    
                if dist <= 1.0 then
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder à la location")
                    if IsControlJustPressed(1,51) then
                        RageUI.Visible(RMenu:Get('hs0_location', 'main'), not RageUI.Visible(RMenu:Get('hs0_location', 'main')))
                    end   
                end
            end
        end
    end)

function spawnCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, -1046.91, -2650.52, 13.83, 157.651, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "HS0LOCAT"
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1) 
end

