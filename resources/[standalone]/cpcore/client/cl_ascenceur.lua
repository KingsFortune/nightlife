Citizen.CreateThread(function()
    while true do
        local waiting = 750
        local plyCoords2 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist2 = Vdist(plyCoords2.x, plyCoords2.y, plyCoords2.z, Config.coordonate.monter.x, Config.coordonate.monter.y, Config.coordonate.monter.z)
        local dist3 = Vdist(plyCoords2.x, plyCoords2.y, plyCoords2.z, Config.coordonate.descendre.x, Config.coordonate.descendre.y, Config.coordonate.descendre.z)
        local dist4 = Vdist(plyCoords2.x, plyCoords2.y, plyCoords2.z, Config.coordonate.neutre.x, Config.coordonate.neutre.y, Config.coordonate.neutre.z)

        if dist4 <= Config.Marker.DrawDistance then
            waiting = 0
            DrawMarker(Config.Marker.Type, Config.coordonate.neutre.x, Config.coordonate.neutre.y, Config.coordonate.neutre.z, -0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
        elseif dist2 <= Config.Marker.DrawDistance then
            waiting = 0
            DrawMarker(Config.Marker.Type, Config.coordonate.monter.x, Config.coordonate.monter.y, Config.coordonate.monter.z, -0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
        elseif dist3 <= Config.Marker.DrawDistance then
            waiting = 0
            DrawMarker(Config.Marker.Type, Config.coordonate.descendre.x, Config.coordonate.descendre.y, Config.coordonate.descendre.z, -0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
        end
        
        if dist4 <= Config.Marker.DrawInteract then
                waiting = 0
                RageUI.Text({ message = Config.langue.prendre, time_display = 1 })
            if IsControlJustPressed(1,51) then
                OpenAcssss()
            end   
        elseif dist2 <= Config.Marker.DrawInteract then
                waiting = 0
                RageUI.Text({ message = Config.langue.prendre, time_display = 1 })
            if IsControlJustPressed(1,51) then
                OpenAcssss()
            end  
        elseif dist3 <= Config.Marker.DrawInteract then
                waiting = 0
                RageUI.Text({ message = Config.langue.prendre, time_display = 1 })
            if IsControlJustPressed(1,51) then
                OpenAcssss()
            end 
        end
        Citizen.Wait(waiting)
    end
end)

function monter()
    local upcoords = vector3(Config.coordonate.monter.x, Config.coordonate.monter.y, Config.coordonate.monter.z)
    StartPlayerTeleport(PlayerId(), upcoords.x, upcoords.y, upcoords.z, 0.0, false, true, true)
    
    while IsPlayerTeleportActive() do
      Citizen.Wait(0)
    end
end


function descendre()
    local downcoords = vector3(Config.coordonate.descendre.x, Config.coordonate.descendre.y, Config.coordonate.descendre.z)
    StartPlayerTeleport(PlayerId(), downcoords.x, downcoords.y, downcoords.z, 0.0, false, true, true)
    
    while IsPlayerTeleportActive() do
      Citizen.Wait(0)
    end
end

function neutre()
    local neucoords = vector3(Config.coordonate.neutre.x, Config.coordonate.neutre.y, Config.coordonate.neutre.z)
    StartPlayerTeleport(PlayerId(), neucoords.x, neucoords.y, neucoords.z, 0.0, false, true, true)
    
    while IsPlayerTeleportActive() do
      Citizen.Wait(0)
    end
end

function OpenAcssss()
    local main_lux = RageUI.CreateMenu(Config.langue.name , Config.langue.asc)

    main_lux:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)


    RageUI.Visible(main_lux, not RageUI.Visible(main_lux))
    while main_lux do
        Citizen.Wait(0)

            RageUI.IsVisible(main_lux, true, true, true, function()

                RageUI.ButtonWithStyle(Config.langue.monter, nil, {RightLabel = Config.langue.monter_label}, true, function(Hovered, Active, Selected)
                    if Selected then
                        monter()
                        RageUI.CloseAll()
                    end
                end)

                RageUI.ButtonWithStyle(Config.langue.neutre, nil, {RightLabel = Config.langue.neutre_label}, true, function(Hovered, Active, Selected)
                    if Selected then
                        neutre()
                        RageUI.CloseAll()
                    end
                end)

                RageUI.ButtonWithStyle(Config.langue.descendre, nil, {RightLabel = Config.langue.descendre_label}, true, function(Hovered, Active, Selected)
                    if Selected then
                        descendre()
                        RageUI.CloseAll()
                    end
                end)

            end, function()
            end)

        if not RageUI.Visible(main_lux) then
            main_lux = RMenu:DeleteType(main_lux, true)
        end
    end
end