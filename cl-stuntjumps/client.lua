ESX = nil	
local jumpsSetup = false
local jumpsSetupBlips = true
local jumpsSetupBlipsTable = {}
local jumpsSetupBlipsTable2 = {}
local mindis = 300
StatGetBool(GetHashKey("MP1_DEFAULT_STATS_SET"), jumpsSetup, -1);

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(sharedObject) ESX = sharedObject end)
		Citizen.Wait(50)
	end
	while ESX.IsPlayerLoaded() == false do
		Citizen.Wait(5)
	end
	PlayerData = ESX.GetPlayerData()
	--JumpSet.TobGrobbe_1
	local data = json.parse(JumpSet.TobGrobbe_1)
	if type(data) == 'table' then
		--print("TobGrobbe_1: ", ESX.DumpTable(data))
		local jumpid = 0
		for k, v in pairs(data) do
			if k == "angledStuntJumps" then
				print("=================angledStuntJumps=================")
				for k, jump in pairs(v) do
					--print(tostring(k) .. "   " .. tostring(v))
					--print(ESX.DumpTable(v))
					if not jumpsSetup then
						table.insert(jumpsSetupBlipsTable, vector3(jump["jumpPos"]["start"]["X"],jump["jumpPos"]["start"]["Y"],jump["jumpPos"]["start"]["Z"]))
						table.insert(jumpsSetupBlipsTable2, vector3(jump["landingPos"]["end"]["X"],jump["landingPos"]["end"]["Y"],jump["landingPos"]["end"]["Z"]))
						DeleteStuntJump(jumpid)
						AddStuntJumpAngled(
							jump["jumpPos"]["start"]["X"],
							jump["jumpPos"]["start"]["Y"],
							jump["jumpPos"]["start"]["Z"],
							jump["jumpPos"]["end"]["X"],
							jump["jumpPos"]["end"]["Y"],
							jump["jumpPos"]["end"]["Z"],
							jump["jumpPos"]["radius"],
							jump["landingPos"]["start"]["X"],
							jump["landingPos"]["start"]["Y"],
							jump["landingPos"]["start"]["Z"],
							jump["landingPos"]["end"]["X"],
							jump["landingPos"]["end"]["Y"],
							jump["landingPos"]["end"]["Z"],
							jump["landingPos"]["radius"],
							jump["camPos"]["X"],
							jump["camPos"]["Y"],
							jump["camPos"]["Z"],
							150,
							0,
							0
						)
						jumpid = jumpid + 1
					end
				end
			elseif k == "normalStuntJumps" then
				print("=================normalStuntJumps=================")
				for k, jump in pairs(v) do
					if not jumpsSetup then
						table.insert(jumpsSetupBlipsTable, vector3(jump["jumpPos"]["start"]["X"],jump["jumpPos"]["start"]["Y"],jump["jumpPos"]["start"]["Z"]))
						table.insert(jumpsSetupBlipsTable2, vector3(jump["landingPos"]["end"]["X"],jump["landingPos"]["end"]["Y"],jump["landingPos"]["end"]["Z"]))
						DeleteStuntJump(jumpid)
						AddStuntJump(
							jump["jumpPos"]["start"]["X"],
							jump["jumpPos"]["start"]["Y"],
							jump["jumpPos"]["start"]["Z"],
							jump["jumpPos"]["end"]["X"],
							jump["jumpPos"]["end"]["Y"],
							jump["jumpPos"]["end"]["Z"],
							jump["landingPos"]["start"]["X"],
							jump["landingPos"]["start"]["Y"],
							jump["landingPos"]["start"]["Z"],
							jump["landingPos"]["end"]["X"],
							jump["landingPos"]["end"]["Y"],
							jump["landingPos"]["end"]["Z"],
							jump["camPos"]["X"],
							jump["camPos"]["Y"],
							jump["camPos"]["Z"],
							150,
							0,
							0
						)
						jumpid = jumpid + 1
					end
				end
			end
		end
	end
end)

function CreateBlip(coords, id)
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, 490)
	SetBlipScale(blip, 0.9)
	SetBlipColour(blip, 1)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Stunt jump(" .. id .. ")")
	EndTextCommandSetBlipName(blip)
	return blip
end
function CreateBlipLanding(coords, id)
	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, 8)
	SetBlipScale(blip, 0.9)
	SetBlipColour(blip, 15)
	SetBlipDisplay(blip, 4)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Stunt jump end(" .. id .. ")")
	EndTextCommandSetBlipName(blip)
	return blip
end

Citizen.CreateThread(function()
	local currentBlip = 0
	local currentLandBlip = 0
	while true do
		Citizen.Wait(3000)
		local coords = GetEntityCoords(PlayerPedId())
		local closest = 100000000000
		local closestCoords
		local selectid = 0
		for k,v in pairs(jumpsSetupBlipsTable) do
			local dstcheck = GetDistanceBetweenCoords(coords, v)
			if dstcheck < closest then
				closest = dstcheck
				closestCoords = v
				selectid = k
			end
		end
		if DoesBlipExist(currentBlip) then
			RemoveBlip(currentBlip)
		end
		if DoesBlipExist(currentLandBlip) then
			RemoveBlip(currentLandBlip)
		end
		--print(ESX.DumpTable(jumpsSetupBlipsTable2))
		--print(selectid)
		if mindis >= closest then
			currentBlip = CreateBlip(closestCoords, selectid)
			currentLandBlip = CreateBlipLanding(jumpsSetupBlipsTable2[selectid], selectid)
		end
	end
end)
StatSetBool(GetHashKey("MP1_DEFAULT_STATS_SET"), true, true) 
AddEventHandler("onResourceStop", function(resource)
	if resource == GetCurrentResourceName() then
		StatSetBool(GetHashKey("MP1_DEFAULT_STATS_SET"), false, true) 
	end
end)