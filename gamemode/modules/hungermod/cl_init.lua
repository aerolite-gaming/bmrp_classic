-- copied from serverside
FoodItems = { }
MedItems = { }

local function AddFoodItem(name, mdl, amount, price)
	FoodItems[name] = { model = mdl, amount = amount }
end

local function AddMedItem(name, mdl, amount, price)
	MedItems[name] = { model = mdl, amount = amount }
end

AddFoodItem("banana", "models/props/cs_italy/bananna.mdl", 5)
AddFoodItem("bananabunch", "models/props/cs_italy/bananna_bunch.mdl", 10)
AddFoodItem("melon", "models/props_junk/watermelon01.mdl", 11)
AddFoodItem("glassbottle", "models/props_junk/GlassBottle01a.mdl", 15)
AddFoodItem("popcan", "models/props_junk/PopCan01a.mdl", 5)
AddFoodItem("plasticbottle", "models/props_junk/garbage_plasticbottle003a.mdl", 6)
AddFoodItem("milk", "models/props_junk/garbage_milkcarton002a.mdl", 7)
AddFoodItem("bottle1", "models/props_junk/garbage_glassbottle001a.mdl", 10)
AddFoodItem("bottle2", "models/props_junk/garbage_glassbottle002a.mdl",10)
AddFoodItem("bottle3", "models/props_junk/garbage_glassbottle003a.mdl", 10)
AddFoodItem("orange", "models/props/cs_italy/orange.mdl", 5)
AddFoodItem("mre", "models/warz/consumables/bag_mre.mdl", 40)
AddMedItem("antibiotics", "models/warz/consumables/medicine.mdl", 25)
AddMedItem("painkillers", "models/warz/consumables/painkillers.mdl", 15)
AddMedItem("bandage", "models/warz/items/bandage.mdl", 10)
AddMedItem("medkit", "models/warz/items/medkit.mdl", 100)

local HM = { }

FoodAteAlpha = -1
FoodAteY = 0

surface.CreateFont("HungerPlus", {
	size = 70,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "ChatFont"})

function HM.HUDPaint()
	local energy = LocalPlayer():getDarkRPVar("Energy") or 0

	local x = 5
	local y = ScrH() - 18
	--draw.RoundedBox(4, 25, ScrH() - 21, 250, 18, Color(0, 0, 0, 230))

	--draw.RoundedBox(4, x - 1, y - 1, GetConVarNumber("HudW") - 8, 9, Color(0, 0, 0, 255))

	if energy > 0 then
		--draw.RoundedBox(4, x, y, (GetConVarNumber("HudW") - 9) * (math.Clamp(energy, 0, 100) / 100), 7, Color(30, 30, 120, 255))
		--draw.DrawText(math.ceil(energy) .. "%", "UiBold", GetConVarNumber("HudW") / 2, y, Color(255, 255, 255, 255), 1)
	else
		--Msg("You are starving.")
		--draw.DrawText(DarkRP.getPhrase("starving"), "ChatFont", GetConVarNumber("HudW") / 2, y - 4, Color(200, 0, 0, 255), 1)
	end

	if FoodAteAlpha > -1 then
		local mul = 1
		if FoodAteY <= ScrH() - 100 then
			mul = -.5
		end

		draw.DrawText("++", "HungerPlus", 308, FoodAteY + 1, Color(0, 0, 0, FoodAteAlpha), 0)
		draw.DrawText("++", "HungerPlus", 307, FoodAteY, Color(20, 100, 20, FoodAteAlpha), 0)

		FoodAteAlpha = math.Clamp(FoodAteAlpha + 1000 * FrameTime() * mul, -1, 255)
		FoodAteY = FoodAteY - 150 * FrameTime()
	end
end
hook.Add("HUDPaint", "HM.HUDPaint", HM.HUDPaint)

local function AteFoodIcon(msg)
	FoodAteAlpha = 1
	FoodAteY = ScrH() - 8
end
usermessage.Hook("AteFoodIcon", AteFoodIcon)
