--Cloak & Godmode upon Noclip > ConVar
CreateClientConVar("cl_cloakgod_noclip", 0, true, true)

--Spawn as Worldprop
CreateClientConVar("cl_spawnasworld", 0, false, true)


function AeroliteStaffSettings(Panel)
	if not LocalPlayer():IsAdmin() then
		Panel:AddControl("Header", { Description = "Access Denied. You are not a Staff Member." })
	else
		Panel:AddControl("CheckBox", {Label = "Automatically Cloak and Godmode upon Noclip", Command = "cl_cloakgod_noclip"})
		Panel:AddControl("CheckBox", {Label = "Spawn Props as Worldprops", Command = "cl_spawnasworld"})
	end
end

local function CreateAeroliteMenu()
	spawnmenu.AddToolMenuOption("Utilities", "Aerolite", "Aerolite Staff Settings", "Staff Settings", "", "", AeroliteStaffSettings)
end
hook.Add("PopulateToolMenu", "CreateAeroliteMenuHook", CreateAeroliteMenu)