local time = 0

CreateThread(function()
		for i = 1, #Config.Locations do
        local v = Config.Locations[i]
		local blipradius = AddBlipForRadius(v.coords,v.blipradius)
		local blipscenter = AddBlipForCoord(v.coords)
		SetBlipSprite(blipscenter, v.sprite)
		SetBlipColour(blipradius, 59)
		SetBlipFade(blipradius, 100, 1)
		SetBlipAsShortRange(blipscenter, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString('Red Zone | Combat Enforced')
		EndTextCommandSetBlipName(blipscenter)
		coords = v.coords
		redzone = CircleZone:Create(v.coords, v.blipradius, {
			name = 'redzone',
			debugPoly = false,
		})
		redzone:onPlayerInOut(function(isPointInside)
			if isPointInside then
				inZone = 1
					lib.notify({
						description = 'You\'ve entered a red zone, a 30 second timer has started and you cannot leave until then.',
						type = 'error'
					})
				time = 30
			else
				inZone = 0
				lib.notify({
					description = 'You\'ve left a red zone',
					type = 'error'
				})
			end
		end)
	end
end)

CreateThread(function()
	while true do 
		Wait(10)
		while time > 0 do
			Wait(10)
			if inZone == 0 and time > 1 then
				SetEntityCoords(cache.ped,coords.x,coords.y,coords.z)
				time = 30
			end
			if inZone == 1 and time >= 0 then
				time -= 1
				lib.showTextUI(tostring(time), {
					position = "left-center",
					icon = 'gun',
					style = {
						borderRadius = 5,
						backgroundColor = '#FF0000',
						color = 'white'
					}
				})
				Wait(400)
				lib.hideTextUI()
				Wait(1000)
			end
		end
	end
end)


