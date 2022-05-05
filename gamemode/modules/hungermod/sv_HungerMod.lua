local HM = { }
local FoodItems = { }
local MedItems = { }

local function AddFoodItem(name, mdl, amount, price)
	FoodItems[name] = { model = mdl, amount = amount, price = price }
end

local function AddMedItem(name, mdl, amount, price)
	MedItems[name] = { model = mdl, amount = amount, price = price }
end

function HM.PlayerSpawn(ply)
	ply:SetSelfDarkRPVar("Energy", 100)
	ply:SetRunSpeed( 240 )
end
hook.Add("PlayerSpawn", "HM.PlayerSpawn", HM.PlayerSpawn)

function HM.Think()
	if not GAMEMODE.Config.hungerspeed then return end

	for k, v in pairs(player.GetAll()) do
		if v:Alive() and (not v.LastHungerUpdate or CurTime() - v.LastHungerUpdate > 10) then
			v:HungerUpdate()
		end
	end
end
hook.Add("Think", "HM.Think", HM.Think)

function HM.PlayerInitialSpawn(ply)
	ply:NewHungerData()
end
hook.Add("PlayerInitialSpawn", "HM.PlayerInitialSpawn", HM.PlayerInitialSpawn)

for k, v in pairs(player.GetAll()) do
	v:NewHungerData()
end

AddFoodItem("banana", "models/props/cs_italy/bananna.mdl", 15, 5)
AddFoodItem("bananabunch", "models/props/cs_italy/bananna_bunch.mdl", 25, 10)
AddFoodItem("melon", "models/props_junk/watermelon01.mdl", 20, 11)
AddFoodItem("glassbottle", "models/props_junk/GlassBottle01a.mdl", 10, 15)
AddFoodItem("popcan", "models/props_junk/PopCan01a.mdl", 5, 5)
AddFoodItem("plasticbottle", "models/props_junk/garbage_plasticbottle003a.mdl", 7, 6)
AddFoodItem("milk", "models/props_junk/garbage_milkcarton002a.mdl", 8, 7)
AddFoodItem("bottle1", "models/props_junk/garbage_glassbottle001a.mdl", 8, 10)
AddFoodItem("bottle2", "models/props_junk/garbage_glassbottle002a.mdl", 8, 10)
AddFoodItem("bottle3", "models/props_junk/garbage_glassbottle003a.mdl", 8, 10)
AddFoodItem("orange", "models/props/cs_italy/orange.mdl", 15, 5)
AddFoodItem("mre", "models/warz/consumables/bag_mre.mdl", 100, 40)
AddMedItem("antibiotics", "models/warz/consumables/medicine.mdl", 50, 25)
AddMedItem("painkillers", "models/warz/consumables/painkillers.mdl", 25, 15)
AddMedItem("bandage", "models/warz/items/bandage.mdl", 15, 10)
AddMedItem("medkit", "models/warz/items/medkit.mdl", 70, 100)


local function BuyFood(ply, args)
	if args == "" then
		GAMEMODE:Notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
		return ""
	end

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

	local tr = util.TraceLine(trace)

	if not RPExtraTeams[ply:Team()] or not RPExtraTeams[ply:Team()].cook then
		GAMEMODE:Notify(ply, 1, 4, DarkRP.getPhrase("unable", "/buyfood", "cooks"))
		return ""
	end

	for k,v in pairs(FoodItems) do

		if string.lower(args) == k then
			--local cost = GAMEMODE.Config.foodcost
			local cost = v.price
			
			if ply.LastJob and 120 - (CurTime() - ply.LastJob) >= 0 and ply:GetPData("disguised") ~= "0" then
				GAMEMODE:Notify(ply, 1, 4, string.format("Can't spawn items until you've had your job for at least 2 minutes."))
				return ""
			end		
			
			if ply:GetNetworkedVar("FoodTimeout") ~= 1 then
				if ply:CanAfford(cost) then
					ply:AddMoney(-cost)
				else
					GAMEMODE:Notify(ply, 1, 4, DarkRP.getPhrase("cant_afford", ""))
					return ""
				end
			end		
			
			if(ply:GetNetworkedVar("FoodTimeout") ~= 1)  then 
			else
				GAMEMODE:Notify(ply, 1, 4, "Wait 3 seconds between buying items!")
				return ""
			end	
			ply:SetNetworkedVar( "FoodTimeout", 1 )
			timer.Simple(3, function() 
			ply:SetNetworkedVar( "FoodTimeout", 0 )
			end)
			
			if ply:Team() == TEAM_HECUCOMMANDER then
				if v.model == "models/warz/consumables/bag_mre.mdl" then
				else
					GAMEMODE:Notify(ply, 1, 4, "You may not buy this item as HECU Commander.")
					return false
				end
			else
				if v.model == "models/warz/consumables/bag_mre.mdl" then
					GAMEMODE:Notify(ply, 1, 4, "You may not buy this item as Cook.")
					return false
				end	
			end
			
			GAMEMODE:Notify(ply, 0, 4, DarkRP.getPhrase("you_bought_x", k, tostring(cost)))
			local SpawnedFood = ents.Create("spawned_food")
			SpawnedFood:Setowning_ent(ply)
			SpawnedFood.ShareGravgun = true
			SpawnedFood:SetPos(tr.HitPos)
			SpawnedFood.onlyremover = true
			SpawnedFood.SID = ply.SID
			SpawnedFood:SetModel(v.model)
			SpawnedFood.FoodEnergy = v.amount
			SpawnedFood:Spawn()
			return ""
		end
	end
	GAMEMODE:Notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
	return ""
end
AddChatCommand("/buyfood", BuyFood)


local function BuyMed(ply, args)
	if args == "" then
		GAMEMODE:Notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
		return ""
	end

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

	local tr = util.TraceLine(trace)

	if not RPExtraTeams[ply:Team()] then
		GAMEMODE:Notify(ply, 1, 4, "Only Medics can buy Meds!")
		return ""
	end

	if not RPExtraTeams[ply:Team()].medic then
		if ply:Team() != TEAM_HECUMEDIC then
			GAMEMODE:Notify(ply, 1, 4, "Only Medics can buy Meds!")
			return ""
		end
	end

	for k,v in pairs(MedItems) do

		if string.lower(args) == k then
			--local cost = GAMEMODE.Config.foodcost
			local cost = v.price
			
			if ply.LastJob and 120 - (CurTime() - ply.LastJob) >= 0 and ply:GetPData("disguised") ~= "0" then
				GAMEMODE:Notify(ply, 1, 4, string.format("Can't spawn items until you've had your job for at least 2 minutes."))
				return ""
			end
			
			if ply:GetNetworkedVar("FoodTimeout") ~= 1 then
				if ply:CanAfford(cost) then
					ply:AddMoney(-cost)
				else
					GAMEMODE:Notify(ply, 1, 4, DarkRP.getPhrase("cant_afford", ""))
					return ""
				end
			end	
			
			if(ply:GetNetworkedVar("FoodTimeout") ~= 1)  then 
			else
				GAMEMODE:Notify(ply, 1, 4, "Wait 3 seconds between buying items!")
				return ""
			end	
			ply:SetNetworkedVar( "FoodTimeout", 1 )
			timer.Simple(3, function() 
			ply:SetNetworkedVar( "FoodTimeout", 0 )
			end)
			
			
			GAMEMODE:Notify(ply, 0, 4, DarkRP.getPhrase("you_bought_x", k, tostring(cost)))
			local SpawnedFood = ents.Create("spawned_food")
			SpawnedFood:Setowning_ent(ply)
			SpawnedFood.ShareGravgun = true
			SpawnedFood:SetPos(tr.HitPos)
			SpawnedFood.onlyremover = true
			SpawnedFood.SID = ply.SID
			SpawnedFood:SetModel(v.model)
			SpawnedFood.FoodEnergy = v.amount
			SpawnedFood:Spawn()
			return ""
		end
	end
	GAMEMODE:Notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
	return ""
end
AddChatCommand("/buymed", BuyMed)

