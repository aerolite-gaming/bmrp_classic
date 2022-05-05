CreateClientConVar("rp_playermodel", "", true, true)

local function MayorOptns()
	local MayCat = vgui.Create("DCollapsibleCategory")
	function MayCat:Paint()
		self:SetBGColor(team.GetColor(LocalPlayer():Team()))
	end
	MayCat:SetLabel("Administration Panel")
		local maypanel = vgui.Create("DListLayout")
		maypanel:SetSize(740,170)

			local Lockdown = maypanel:Add("DButton")
			Lockdown:SetText(DarkRP.getPhrase("initiate_lockdown"))
			Lockdown.DoClick = function()
				LocalPlayer():ConCommand("darkrp /lockdown")
			end


			local UnLockdown = maypanel:Add("DButton")
			UnLockdown:SetText(DarkRP.getPhrase("stop_lockdown"))
			UnLockdown.DoClick = function()
				LocalPlayer():ConCommand("darkrp /unlockdown")
			end

			local FireEmployee = maypanel:Add("DButton")
			FireEmployee:SetText("Fire Employee")
			FireEmployee.DoClick = function()
				local menu = DermaMenu()
				for _,ply in pairs(player.GetAll()) do
					if not ply:Alive() or ply == LocalPlayer() or ply:Team() == TEAM_CITIZEN then continue end
					menu:AddOption(ply:Nick(), function()
						Derma_StringRequest("Fire Employee", "Why would you like to fire "..ply:Nick().."?", nil,
							function(a)
								RunConsoleCommand("darkrp", "/fire", ply:SteamID(), a)
							end,
						function() end)
					end)
				end
				menu:Open()
			end

	MayCat:SetContents(maypanel)
	MayCat:SetSkin(GAMEMODE.Config.DarkRPSkin)
	return MayCat
end

local function CPOptns()
	local CPCat = vgui.Create("DCollapsibleCategory")
	function CPCat:Paint()
		self:SetBGColor(team.GetColor(LocalPlayer():Team()))
	end
	CPCat:SetLabel("Police options")
		local CPpanel = vgui.Create("DListLayout")
		CPpanel:SetSize(740,170)
			local SearchWarrant = CPpanel:Add("DButton")
			SearchWarrant:SetText(DarkRP.getPhrase("request_warrant"))
			SearchWarrant.DoClick = function()
				local menu = DermaMenu()
				for _,ply in pairs(player.GetAll()) do
					if not ply:getDarkRPVar("warrant") and ply ~= LocalPlayer() then
						menu:AddOption(ply:Nick(), function()
							Derma_StringRequest("Warrant", "Why would you warrant "..ply:Nick().."?", nil,
								function(a)
									RunConsoleCommand("darkrp", "/warrant", ply:SteamID(), a)
								end,
							function() end )
						end)
					end
				end
				menu:Open()
			end

			local Warrant = CPpanel:Add("DButton")
			Warrant:SetText(DarkRP.getPhrase("searchwarrantbutton"))
			Warrant.DoClick = function()
				local menu = DermaMenu()
				for _,ply in pairs(player.GetAll()) do
					if not ply:getDarkRPVar("wanted") and ply ~= LocalPlayer() then
						menu:AddOption(ply:Nick(), function()
							Derma_StringRequest("wanted", "Why would you make "..ply:Nick().." wanted?", nil,
								function(a)
									if not IsValid(ply) then return end
									RunConsoleCommand("darkrp", "/wanted", ply:SteamID(), a)
								end,
							function() end )
						end)
					end
				end
				menu:Open()
			end

			local UnWarrant = CPpanel:Add("DButton")
			UnWarrant:SetText(DarkRP.getPhrase("unwarrantbutton"))
			UnWarrant.DoClick = function()
				local menu = DermaMenu()
				for _,ply in pairs(player.GetAll()) do
					if ply:getDarkRPVar("wanted") and ply ~= LocalPlayer() then
						menu:AddOption(ply:Nick(), function() LocalPlayer():ConCommand("darkrp /unwanted \"" .. ply:SteamID() .. "\"") end)
					end
				end
				menu:Open()
			end

			if LocalPlayer():Team() == TEAM_CHIEF and GAMEMODE.Config.chiefjailpos or LocalPlayer():IsAdmin() then
				local SetJailPos = CPpanel:Add("DButton")
				SetJailPos:SetText(DarkRP.getPhrase("set_jailpos"))
				SetJailPos.DoClick = function() LocalPlayer():ConCommand("darkrp /jailpos") end

				local AddJailPos = CPpanel:Add("DButton")
				AddJailPos:SetText(DarkRP.getPhrase("add_jailpos"))
				AddJailPos.DoClick = function() LocalPlayer():ConCommand("darkrp /addjailpos") end
			end

			local ismayor -- Firstly look if there's a mayor
			local ischief -- Then if there's a chief
			for k,v in pairs(player.GetAll()) do
				if v:Team() == TEAM_MAYOR then
					ismayor = true
					break
				end
			end

			if not ismayor then
				for k,v in pairs(player.GetAll()) do
					if v:Team() == TEAM_CHIEF then
						ischief = true
						break
					end
				end
			end

			local Team = LocalPlayer():Team()
			if not ismayor and (Team == TEAM_CHIEF or (not ischief and Team == TEAM_POLICE)) then
				local GiveLicense = CPpanel:Add("DButton")
				GiveLicense:SetText(DarkRP.getPhrase("give_license_lookingat"))
				GiveLicense.DoClick = function()
					LocalPlayer():ConCommand("darkrp /givelicense")
				end
			end
	CPCat:SetContents(CPpanel)
	CPCat:SetSkin(GAMEMODE.Config.DarkRPSkin)
	return CPCat
end


local function CitOptns()
	local CitCat = vgui.Create("DCollapsibleCategory")
	function CitCat:Paint()
		self:SetBGColor(team.GetColor(LocalPlayer():Team()))
	end
	CitCat:SetLabel(" Citizen options")
		local Citpanel = vgui.Create("DListLayout")
		Citpanel:SetSize(740,110)

		local joblabel = Citpanel:Add("DLabel")
		joblabel:SetText(DarkRP.getPhrase("set_custom_job"))

		local jobentry = Citpanel:Add("DTextEntry")
		jobentry:SetAllowNonAsciiCharacters(true)
		jobentry:SetValue(LocalPlayer():getDarkRPVar("job") or "")
		jobentry.OnEnter = function()
			RunConsoleCommand("DarkRP", "/job", tostring(jobentry:GetValue()))
		end

	CitCat:SetContents(Citpanel)
	CitCat:SetSkin(GAMEMODE.Config.DarkRPSkin)
	return CitCat
end

function GM:MoneyTab()
	local FirstTabPanel = vgui.Create("DPanelList")
	FirstTabPanel:EnableVerticalScrollbar( true )
		function FirstTabPanel:Update()
			self:Clear(true)
			local MoneyCat = vgui.Create("DCollapsibleCategory")
			MoneyCat:SetLabel("Money")
				local MoneyPanel = vgui.Create("DListLayout")
				MoneyPanel:SetSize(740,60)

				local GiveMoneyButton = MoneyPanel:Add("DButton")
				GiveMoneyButton:SetText(DarkRP.getPhrase("give_money"))
				GiveMoneyButton.DoClick = function()
					Derma_StringRequest("Amount of money", "How much money do you want to give?", "", function(a) LocalPlayer():ConCommand("darkrp /give " .. tostring(a)) end)
				end

				local SpawnMoneyButton = MoneyPanel:Add("DButton")
				SpawnMoneyButton:SetText(DarkRP.getPhrase("drop_money"))
				SpawnMoneyButton.DoClick = function()
					Derma_StringRequest("Amount of money", "How much money do you want to drop?", "", function(a) LocalPlayer():ConCommand("darkrp /dropmoney " .. tostring(a)) end)
				end

			MoneyCat:SetContents(MoneyPanel)
			MoneyCat:SetSkin(GAMEMODE.Config.DarkRPSkin)


			local Commands = vgui.Create("DCollapsibleCategory")
			Commands:SetLabel("Actions")
				local ActionsPanel = vgui.Create("DListLayout")
				ActionsPanel:SetSize(740,210)
					local rpnamelabel = ActionsPanel:Add("DLabel")
					rpnamelabel:SetText(DarkRP.getPhrase("change_name"))

					local rpnameTextbox = ActionsPanel:Add("DTextEntry")
					--/rpname does not support non-ASCII characters
					rpnameTextbox:SetText(LocalPlayer():Nick())
					rpnameTextbox.OnEnter = function() RunConsoleCommand("darkrp", "/rpname", tostring(rpnameTextbox:GetValue())) end
					
					local Drop = ActionsPanel:Add("DButton")
					Drop:SetText(DarkRP.getPhrase("drop_weapon"))
					Drop.DoClick = function() LocalPlayer():ConCommand("darkrp /drop") end
					if GAMEMODE.Config.enablebuyhealth then
						local health = MoneyPanel:Add("DButton")
						health:SetText(DarkRP.getPhrase("buy_health", tostring(GAMEMODE.Config.healthcost)))
						health.DoClick = function() LocalPlayer():ConCommand("darkrp /Buyhealth") end
					end

				local UnOwnAllDoors = ActionsPanel:Add("DButton")
						UnOwnAllDoors:SetText("Sell all of your doors")
						UnOwnAllDoors.DoClick = function() LocalPlayer():ConCommand("darkrp /unownalldoors") end
			Commands:SetContents(ActionsPanel)
		FirstTabPanel:AddItem(MoneyCat)
		Commands:SetSkin(GAMEMODE.Config.DarkRPSkin)
		FirstTabPanel:AddItem(Commands)

		if LocalPlayer():Team() == TEAM_MAYOR then
			FirstTabPanel:AddItem(MayorOptns())
		elseif LocalPlayer():Team() == TEAM_CITIZEN then
			FirstTabPanel:AddItem(CitOptns())
		elseif LocalPlayer():IsCP() then
			FirstTabPanel:AddItem(CPOptns())
		elseif LocalPlayer():Team() == TEAM_MOB then
			FirstTabPanel:AddItem(MobOptns())
		end
	end
	FirstTabPanel:Update()
	return FirstTabPanel
end

surface.CreateFont("JobButton", {
	font = "Roboto Regular",
	size = 30,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true
})

function GM:JobsTab()
	local JobsPanel = vgui.Create("DPanel")
	JobsPanel:SetBackgroundColor(Color(0, 0, 0, 100))

	local JobsList = vgui.Create("DIconLayout", JobsPanel)
	JobsList:SetSize(400, 200)
	JobsList:SetPos(10, 10)
	JobsList:SetSpaceY(5)
	JobsList:SetSpaceX(5)

	for k, v in SortedPairsByMemberValue(RPExtraTeams, "name") do
		local ListItem = JobsList:Add("DPanel")
		ListItem:SetSize(60, 60)

		ListItem.model = vgui.Create( "ModelImage", ListItem)
		ListItem.model:SetSize(72, 72)
		ListItem.model:SetPos(2, 2)
		ListItem.model:SetModel(istable(v.model) and v.model[1] or v.model)

		local ListItemFront = vgui.Create("DButton", ListItem)
		ListItemFront:SetSize(60, 60)
		ListItemFront:SetText("")
		ListItemFront:SetTooltip(v.name)

		ListItemFront.Paint = function(panel, w, h)
			if (v.customCheck and not v.customCheck(LocalPlayer())) then
				surface.SetDrawColor(selectedPanel == ListItemFront and Color(210, 0, 0, 160) or panel.Hovered and Color(210, 0, 0, 160) or Color(180, 0, 0, 160))
				surface.DrawRect(0, 0, w, h)
				surface.SetMaterial(Material("materials/icon16/lock.png"))
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.DrawTexturedRect(20, 20, 24, 24)
			end
		end

		ListItem.Paint = function(panel, w, h)
			if (not v.customCheck or v.customCheck and v.customCheck(LocalPlayer())) then
				if (v == RPExtraTeams[LocalPlayer():Team()]) then
					surface.SetDrawColor(selectedPanel == ListItemFront and Color(0, 0, 190, 160) or ListItemFront.Hovered and Color(0, 0, 190, 160) or Color(0, 0, 140, 160))
					surface.DrawRect(0, 0, w, h)					
				else
					surface.SetDrawColor(selectedPanel == ListItemFront and Color(0, 160, 0, 160) or ListItemFront.Hovered and Color(0, 160, 0, 160) or Color(0, 100, 0, 160))
					surface.DrawRect(0, 0, w, h)
				end
			end
		end

		ListItemFront.DoClick = function()
			JobDescription:SetText("Name: " .. v.name .. "\n\nDescription: " .. v.description)
			selectedJob = v
			selectedPanel = ListItemFront
		end
	end

	selectedJob = RPExtraTeams[1]

	local Divider = vgui.Create("DPanel", JobsPanel)
	Divider:SetPos(404, 8)
	Divider:SetSize(10, 490)
	Divider.Paint = function(panel, w, h)
		surface.SetDrawColor(40, 40, 40, 140)
		surface.DrawRect(0, 0, w, h)
	end

	local LevelPanel = vgui.Create("DPanel", JobsPanel)
	LevelPanel:SetPos(424.5, 416)
	LevelPanel:SetSize(309, 26)
	LevelPanel.Paint = function(panel, w, h)
		if (tonumber(selectedJob.XPNeeded) > 0 and LocalPlayer():getDarkRPVar("xp") <= tonumber(selectedJob.XPNeeded)) then
			surface.SetDrawColor(40, 40, 40, 200)
			surface.DrawRect(0, 0, w, h)

			local drawXP = 3.03 * (LocalPlayer():getDarkRPVar("xp")/(selectedJob.XPNeeded/100))
			surface.SetDrawColor(6, 170, 80, 170)
			surface.DrawRect(3, 2, drawXP, 22)

			draw.DrawText(LocalPlayer():getDarkRPVar("xp").."/"..selectedJob.XPNeeded.." XP", "F4Title", 151, 4, Color(255, 255, 255, 255), 1)
		end
	end

	JobDescription = vgui.Create("DTextEntry", JobsPanel)
	JobDescription:SetPos(424, 10)
	JobDescription:SetSize(310, 300)
	JobDescription:SetMultiline(true)
	JobDescription:SetEditable(false)
	JobDescription:SetDrawBackground(false)
	JobDescription:SetTextColor(Color(255, 255, 255, 255))
	JobDescription:SetText("Name: " .. RPExtraTeams[1].name .. "\n\nDescription: " .. RPExtraTeams[1].description)
	JobDescription:SizeToContents()



	JobButton = vgui.Create("DButton", JobsPanel)
	JobButton:SetPos(424, 448)
	JobButton:SetSize(310, 50)
	JobButton:SetText("Choose Job ")
	JobButton:SetFont("JobButton")

	JobButton.UpdateColours = function(skin)
		JobButton:SetTextColor(JobButton.Hovered and Color(255, 255, 255, 100) or Color(255, 255, 255, 255))
	end

	JobButton.Paint = function(panel, w, h)
		if(selectedJob.customCheck and not selectedJob.customCheck(LocalPlayer()) or selectedJob == RPExtraTeams[LocalPlayer():Team()]) then
			surface.SetDrawColor(100, 0, 0, 200)
		else
			surface.SetDrawColor(0, 100, 0, 200)
		end
		
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(50, 50, 50, 200)
		surface.DrawOutlinedRect(0, 0, w, h)	
	end

	JobButton.DoClick = function()
		if (selectedJob != RPExtraTeams[LocalPlayer():Team()]) then
			if (type(selectedJob.model) == "table" and #selectedJob.model > 0) then
				JobsPanel:GetParent():GetParent():Close()

				local JobModelMenu = vgui.Create("DFrame")
				JobModelMenu:SetTitle("Choose a Model")
				JobModelMenu:SetVisible(true)
				JobModelMenu:MakePopup()

				local levels = 1
				local IconsPerLevel = math.floor(ScrW()/64)

				while #selectedJob.model * (64/levels) > ScrW() do
					levels = levels + 1
				end
				JobModelMenu:SetSize(math.Min(#selectedJob.model * 64, IconsPerLevel*64), math.Min(90+(64*(levels-1)), ScrH()))
				JobModelMenu:Center()

				local CurLevel = 1
				for k,v in pairs(selectedJob.model) do
					local icon = vgui.Create("SpawnIcon", JobModelMenu)
					if (k-IconsPerLevel*(CurLevel-1)) > IconsPerLevel then
						CurLevel = CurLevel + 1
					end
					icon:SetPos((k-1-(CurLevel-1)*IconsPerLevel) * 64, 25+(64*(CurLevel-1)))
					icon:SetModel(v)
					icon:SetSize(64, 64)
					icon:SetToolTip()
					icon.DoClick = function()
						RunConsoleCommand("rp_playermodel", v)
						RunConsoleCommand("_rp_ChosenModel", v)
						JobModelMenu:Close()
						LocalPlayer():ConCommand("darkrp /" .. selectedJob.command)
					end
				end
			else
				LocalPlayer():ConCommand("darkrp /" .. selectedJob.command)
				JobsPanel:GetParent():GetParent():Close()
			end
		end
	end

	return JobsPanel
end

function GM:EntitiesTab()
	local EntitiesPanel = vgui.Create("DPanelList")
	EntitiesPanel:EnableVerticalScrollbar( true )
		function EntitiesPanel:Update()
			self:Clear(true)
			
			if LocalPlayer():Team() == TEAM_HECU or LocalPlayer():Team() == TEAM_HECUCOMMANDER or LocalPlayer():Team() == TEAM_SECURITYADMIN then
				local AmmCat = vgui.Create("DCollapsibleCategory")
				AmmCat:SetLabel("Ammo")
					local AmmPanel = vgui.Create("DPanelList")
					AmmPanel:SetSize(470, 100)
					AmmPanel:SetAutoSize(true)
					AmmPanel:SetSpacing(1)
					AmmPanel:EnableHorizontal(true)
					AmmPanel:EnableVerticalScrollbar(true)
						local function AddAmmoIcon(Model, description, command)
							local icon = vgui.Create("SpawnIcon")
							icon:InvalidateLayout( true )
							icon:SetModel(Model)
							icon:SetSize(64, 64)
							icon:SetToolTip(description)
							icon.DoClick = function() LocalPlayer():ConCommand("darkrp "..command) end
							AmmPanel:AddItem(icon)
						end

						local ammnum = 0
						for k,v in pairs(GAMEMODE.AmmoTypes) do
							if not v.customCheck or v.customCheck(LocalPlayer()) then
								AddAmmoIcon(v.model, DarkRP.getPhrase("buy_a", v.name, GAMEMODE.Config.currency .. v.price), "/buyammo " .. v.ammoType)
								ammnum = ammnum + 1
							end
						end

				if ammnum ~= 0 then
					AmmCat:SetContents(AmmPanel)
					AmmCat:SetSkin(GAMEMODE.Config.DarkRPSkin)
					self:AddItem(AmmCat)
				else
					AmmPanel:Remove()
					AmmCat:Remove()
				end

				local WepCat = vgui.Create("DCollapsibleCategory")
				WepCat:SetLabel("Weapons")
					local WepPanel = vgui.Create("DPanelList")
					WepPanel:SetSize(470, 100)
					WepPanel:SetAutoSize(true)
					WepPanel:SetSpacing(1)
					WepPanel:EnableHorizontal(true)
					WepPanel:EnableVerticalScrollbar(true)
						local function AddIcon(Model, description, command)
							local icon = vgui.Create("SpawnIcon")
							icon:InvalidateLayout( true )
							icon:SetModel(Model)
							icon:SetSize(64, 64)
							icon:SetToolTip(description)
							icon.DoClick = function() LocalPlayer():ConCommand("darkrp "..command) end
							WepPanel:AddItem(icon)
						end
	
						local wepnum = 0
						for k,v in pairs(CustomShipments) do
							if not GAMEMODE:CustomObjFitsMap(v) then continue end
							if (v.seperate and (not GAMEMODE.Config.restrictbuypistol or
								(GAMEMODE.Config.restrictbuypistol and (not v.allowed[1] or table.HasValue(v.allowed, LocalPlayer():Team())))))
								and (not v.customCheck or v.customCheck and v.customCheck(LocalPlayer())) then
								AddIcon(v.model, DarkRP.getPhrase("buy_a", "a "..v.name, GAMEMODE.Config.currency..(v.pricesep or "")), "/buy "..v.name)
								wepnum = wepnum + 1
							end
						end

					if wepnum ~= 0 then
						WepCat:SetContents(WepPanel)
						WepCat:SetSkin(GAMEMODE.Config.DarkRPSkin)
						self:AddItem(WepCat)
					else
						WepPanel:Remove()
						WepCat:Remove()
					end
			end
			local ShipCat = vgui.Create("DCollapsibleCategory")
			ShipCat:SetLabel("Shipments")
				local ShipPanel = vgui.Create("DPanelList")
				ShipPanel:SetSize(470, 200)
				ShipPanel:SetAutoSize(true)
				ShipPanel:SetSpacing(1)
				ShipPanel:EnableHorizontal(true)
				ShipPanel:EnableVerticalScrollbar(true)
					local function AddShipIcon(Model, description, command)
						local icon = vgui.Create("SpawnIcon")
						icon:InvalidateLayout( true )
						icon:SetModel(Model)
						icon:SetSize(64, 64)
						icon:SetToolTip(description)
						icon.DoClick = function() LocalPlayer():ConCommand("darkrp "..command) end
						ShipPanel:AddItem(icon)
					end

					local shipnum = 0
					for k,v in pairs(CustomShipments) do
						if not GAMEMODE:CustomObjFitsMap(v) then continue end
						if not v.noship and table.HasValue(v.allowed, LocalPlayer():Team())
							and (not v.customCheck or (v.customCheck and v.customCheck(LocalPlayer()))) then
							AddShipIcon(v.model, DarkRP.getPhrase("buy_a", "a "..v.name .." shipment", GAMEMODE.Config.currency .. tostring(v.price)), "/buyshipment "..v.name)
							shipnum = shipnum + 1
						end
					end
				if shipnum ~= 0 then
					ShipCat:SetContents(ShipPanel)
					ShipCat:SetSkin(GAMEMODE.Config.DarkRPSkin)
					self:AddItem(ShipCat)
				else
					ShipPanel:Remove()
					ShipCat:Remove()
				end

			local EntCat = vgui.Create("DCollapsibleCategory")
			EntCat:SetLabel("Entities")
				local EntPanel = vgui.Create("DPanelList")
				EntPanel:SetSize(470, 200)
				EntPanel:SetAutoSize(true)
				EntPanel:SetSpacing(1)
				EntPanel:EnableHorizontal(true)
				EntPanel:EnableVerticalScrollbar(true)
					local function AddEntIcon(Model, description, command)
						local icon = vgui.Create("SpawnIcon")
						icon:InvalidateLayout( true )
						icon:SetModel(Model)
						icon:SetSize(64, 64)
						icon:SetToolTip(description)
						icon.DoClick = function() LocalPlayer():ConCommand("darkrp "..command) end
						EntPanel:AddItem(icon)
					end
					local entnum = 0
					for k,v in pairs(DarkRPEntities) do
						if not v.allowed or (type(v.allowed) == "table" and table.HasValue(v.allowed, LocalPlayer():Team()))
							and (not v.customCheck or (v.customCheck and v.customCheck(LocalPlayer()))) then
							local cmdname = string.gsub(v.ent, " ", "_")

							AddEntIcon(v.model, "Buy a " .. v.name .." " .. GAMEMODE.Config.currency .. v.price, v.cmd)
							entnum = entnum + 1
						end
					end

					if FoodItems and (GAMEMODE.Config.foodspawn or LocalPlayer():Team() == TEAM_COOK) and LocalPlayer():Team() == TEAM_COOK then
						for k,v in pairs(FoodItems) do
							if v.model ~= "models/warz/consumables/bag_mre.mdl" then
								AddEntIcon(v.model, DarkRP.getPhrase("buy_a", "a "..k, "$" ..v.amount), "/buyfood "..k)
								entnum = entnum + 1
							end	
						end
						
					else
						if LocalPlayer():Team() == TEAM_HECUCOMMANDER then
							for k,v in pairs(FoodItems) do
								if v.model == "models/warz/consumables/bag_mre.mdl" then
									AddEntIcon(v.model, DarkRP.getPhrase("buy_a", "a "..k, "$" ..v.amount), "/buyfood "..k)
									entnum = entnum + 1
								end	
							end						
						end
					end		
					
					if MedItems and (GAMEMODE.Config.foodspawn or LocalPlayer():Team() == TEAM_MEDIC or LocalPlayer():Team() == TEAM_HECUMEDIC) then
						for k,v in pairs(MedItems) do
							AddEntIcon(v.model, DarkRP.getPhrase("buy_a", "a "..k, "$" ..v.amount), "/buymed "..k)
							entnum = entnum + 1
						end
					end
					
				if entnum ~= 0 then
					EntCat:SetContents(EntPanel)
					EntCat:SetSkin(GAMEMODE.Config.DarkRPSkin)
					self:AddItem(EntCat)
				else
					EntPanel:Remove()
					EntCat:Remove()
				end


			if #CustomVehicles <= 0 then return end
			local VehicleCat = vgui.Create("DCollapsibleCategory")
			VehicleCat:SetLabel("Vehicles")
				local VehiclePanel = vgui.Create("DPanelList")
				VehiclePanel:SetSize(470, 200)
				VehiclePanel:SetAutoSize(true)
				VehiclePanel:SetSpacing(1)
				VehiclePanel:EnableHorizontal(true)
				VehiclePanel:EnableVerticalScrollbar(true)
				local function AddVehicleIcon(Model, skin, description, command)
					local icon = vgui.Create("SpawnIcon")
					icon:InvalidateLayout( true )
					icon:SetModel(Model)
					icon:SetSkin(skin)
					icon:SetSize(64, 64)
					icon:SetToolTip(description)
					icon.DoClick = function() LocalPlayer():ConCommand("darkrp "..command) end
					VehiclePanel:AddItem(icon)
				end

				local founds = 0
				for k,v in pairs(CustomVehicles) do
					if (not v.allowed or table.HasValue(v.allowed, LocalPlayer():Team())) and (not v.customCheck or v.customCheck(LocalPlayer())) then
						local Skin = (DarkRP.getAvailableVehicles()[v.name] and DarkRP.getAvailableVehicles()[v.name].KeyValues and DarkRP.getAvailableVehicles()[v.name].KeyValues.Skin) or "0"
						AddVehicleIcon(v.model or "models/buggy.mdl", Skin, "Buy a "..v.name.." for "..GAMEMODE.Config.currency..v.price, "/buyvehicle "..v.name)
						founds = founds + 1
					end
				end
			if founds ~= 0 then
				VehicleCat:SetContents(VehiclePanel)
				VehicleCat:SetSkin(GAMEMODE.Config.DarkRPSkin)
				self:AddItem(VehicleCat)
			else
				VehiclePanel:Remove()
				VehicleCat:Remove()
			end
		end
	EntitiesPanel:SetSkin(GAMEMODE.Config.DarkRPSkin)
	EntitiesPanel:Update()
	return EntitiesPanel
end

function GM:RPHUDTab()
	local HUDTABpanel = vgui.Create("DIconLayout")
	HUDTABpanel:SetSize(750, 550)
	function HUDTABpanel:Update()
		self:Clear(true)

		backgrndcat = HUDTABpanel:Add("DCollapsibleCategory")
		backgrndcat:SetSize(230, 130)
		function backgrndcat.Header:OnMousePressed() end
		backgrndcat:SetLabel("HUD background")
			local backgrndpanel = vgui.Create("DListLayout")
				local backgrnd = backgrndpanel:Add("CtrlColor")
				backgrnd:SetConVarR("background1")
				backgrnd:SetConVarG("background2")
				backgrnd:SetConVarB("background3")
				backgrnd:SetConVarA("background4")

			local resetbackgrnd = backgrndpanel:Add("DButton")
			resetbackgrnd:SetText("Reset")
			resetbackgrnd:SetSize(230, 20)
			resetbackgrnd.DoClick = function()
				LocalPlayer():ConCommand("background1 0")
				LocalPlayer():ConCommand("background2 0")
				LocalPlayer():ConCommand("background3 0")
				LocalPlayer():ConCommand("background4 100")
			end
		backgrndcat:SetContents(backgrndpanel)
		backgrndcat:SetSkin(GAMEMODE.Config.DarkRPSkin)

		hforegrndcat = HUDTABpanel:Add("DCollapsibleCategory")
		hforegrndcat:SetSize(230, 130)
		function hforegrndcat.Header:OnMousePressed() end
		hforegrndcat:SetLabel("Health bar foreground")
			local hforegrndpanel = vgui.Create("DListLayout")
			hforegrndpanel:SetTall(130)
				local hforegrnd = hforegrndpanel:Add("CtrlColor")
				hforegrnd:SetConVarR("Healthforeground1")
				hforegrnd:SetConVarG("Healthforeground2")
				hforegrnd:SetConVarB("Healthforeground3")
				hforegrnd:SetConVarA("Healthforeground4")

			local resethforegrnd = hforegrndpanel:Add("DButton")
			resethforegrnd:SetText("Reset")
			resethforegrnd:SetSize(230, 20)
			resethforegrnd.DoClick = function()
				LocalPlayer():ConCommand("Healthforeground1 140")
				LocalPlayer():ConCommand("Healthforeground2 0")
				LocalPlayer():ConCommand("Healthforeground3 0")
				LocalPlayer():ConCommand("Healthforeground4 180")
			end
		hforegrndcat:SetContents(hforegrndpanel)
		hforegrndcat:SetSkin(GAMEMODE.Config.DarkRPSkin)


		hbackgrndcat = HUDTABpanel:Add("DCollapsibleCategory")
		hbackgrndcat:SetSize(230, 130)
		function hbackgrndcat.Header:OnMousePressed() end
		hbackgrndcat:SetLabel("Health bar Background")
			local hbackgrndpanel = vgui.Create("DListLayout")
			hbackgrndpanel:SetTall(130)
				local hbackgrnd = hbackgrndpanel:Add("CtrlColor")
				hbackgrnd:SetConVarR("Healthbackground1")
				hbackgrnd:SetConVarG("Healthbackground2")
				hbackgrnd:SetConVarB("Healthbackground3")
				hbackgrnd:SetConVarA("Healthbackground4")

			local resethbackgrnd = hbackgrndpanel:Add("DButton")
			resethbackgrnd:SetText("Reset")
			resethbackgrnd:SetSize(230, 20)
			resethbackgrnd.DoClick = function()
				LocalPlayer():ConCommand("Healthbackground1 0")
				LocalPlayer():ConCommand("Healthbackground2 0")
				LocalPlayer():ConCommand("Healthbackground3 0")
				LocalPlayer():ConCommand("Healthbackground4 200")
			end
		hbackgrndcat:SetContents(hbackgrndpanel)
		hbackgrndcat:SetSkin(GAMEMODE.Config.DarkRPSkin)

		hTextcat = HUDTABpanel:Add("DCollapsibleCategory")
		hTextcat:SetSize(230, 130)
		function hTextcat.Header:OnMousePressed() end
		hTextcat:SetLabel("Health bar text")
			local hTextpanel = vgui.Create("DListLayout")
			hTextpanel:SetTall(130)
				local hText = hTextpanel:Add("CtrlColor")
				hText:SetConVarR("HealthText1")
				hText:SetConVarG("HealthText2")
				hText:SetConVarB("HealthText3")
				hText:SetConVarA("HealthText4")

			local resethText = hTextpanel:Add("DButton")
			resethText:SetText("Reset")
			resethText:SetSize(230, 20)
			resethText.DoClick = function()
				LocalPlayer():ConCommand("HealthText1 255")
				LocalPlayer():ConCommand("HealthText2 255")
				LocalPlayer():ConCommand("HealthText3 255")
				LocalPlayer():ConCommand("HealthText4 200")
			end
		hTextcat:SetContents(hTextpanel)
		hTextcat:SetSkin(GAMEMODE.Config.DarkRPSkin)

		jobs1cat = HUDTABpanel:Add("DCollapsibleCategory")
		jobs1cat:SetSize(230, 130)
		function jobs1cat.Header:OnMousePressed() end
		jobs1cat:SetLabel("Jobs/wallet foreground")
			local jobs1panel = vgui.Create("DListLayout")
			jobs1panel:SetTall(130)
				local jobs1 = jobs1panel:Add("CtrlColor")
				jobs1:SetConVarR("Job21")
				jobs1:SetConVarG("Job22")
				jobs1:SetConVarB("Job23")
				jobs1:SetConVarA("Job24")

			local resetjobs1 = jobs1panel:Add("DButton")
			resetjobs1:SetText("Reset")
			resetjobs1:SetSize(230, 20)
			resetjobs1.DoClick = function()
				LocalPlayer():ConCommand("Job21 0")
				LocalPlayer():ConCommand("Job22 0")
				LocalPlayer():ConCommand("Job23 0")
				LocalPlayer():ConCommand("Job24 255")
			end
		jobs1cat:SetContents(jobs1panel)
		jobs1cat:SetSkin(GAMEMODE.Config.DarkRPSkin)

		jobs2cat = HUDTABpanel:Add("DCollapsibleCategory")
		jobs2cat:SetSize(230, 130)
		function jobs2cat.Header:OnMousePressed() end
		jobs2cat:SetLabel("Jobs/wallet background")
			local jobs2panel = vgui.Create("DListLayout")
			jobs2panel:SetSize(230, 130)
				local jobs2 = jobs2panel:Add("CtrlColor")
				jobs2:SetConVarR("Job11")
				jobs2:SetConVarG("Job12")
				jobs2:SetConVarB("Job13")
				jobs2:SetConVarA("Job14")

			local resetjobs2 = jobs2panel:Add("DButton")
			resetjobs2:SetText("Reset")
			resetjobs2:SetSize(230, 20)
			resetjobs2.DoClick = function()
				LocalPlayer():ConCommand("Job11 0")
				LocalPlayer():ConCommand("Job12 0")
				LocalPlayer():ConCommand("Job13 150")
				LocalPlayer():ConCommand("Job14 200")
			end
		jobs2cat:SetContents(jobs2panel)
		jobs2cat:SetSkin(GAMEMODE.Config.DarkRPSkin)

		salary1cat = HUDTABpanel:Add("DCollapsibleCategory")
		salary1cat:SetSize(230, 130)
		function salary1cat.Header:OnMousePressed() end
		salary1cat:SetLabel("Salary foreground")
			local salary1panel = vgui.Create("DListLayout")
			salary1panel:SetSize(230, 130)
				local salary1 = salary1panel:Add("CtrlColor")
				salary1:SetConVarR("salary21")
				salary1:SetConVarG("salary22")
				salary1:SetConVarB("salary23")
				salary1:SetConVarA("salary24")

			local resetsalary1 = salary1panel:Add("DButton")
			resetsalary1:SetText("Reset")
			resetsalary1:SetSize(230, 20)
			resetsalary1.DoClick = function()
				LocalPlayer():ConCommand("salary21 0")
				LocalPlayer():ConCommand("salary22 0")
				LocalPlayer():ConCommand("salary23 0")
				LocalPlayer():ConCommand("salary24 255")
			end
		salary1cat:SetContents(salary1panel)
		salary1cat:SetSkin(GAMEMODE.Config.DarkRPSkin)

		salary2cat = HUDTABpanel:Add("DCollapsibleCategory")
		salary2cat:SetSize(230, 130)
		function salary2cat.Header:OnMousePressed() end
		salary2cat:SetLabel("Salary background")
			local salary2panel = vgui.Create("DListLayout")
			salary2panel:SetSize(230, 130)
				local salary2 = salary2panel:Add("CtrlColor")
				salary2:SetConVarR("salary11")
				salary2:SetConVarG("salary12")
				salary2:SetConVarB("salary13")
				salary2:SetConVarA("salary14")

			local resetsalary2 = salary2panel:Add("DButton")
			resetsalary2:SetText("Reset")
			resetsalary2:SetSize(230, 20)
			resetsalary2.DoClick = function()
				LocalPlayer():ConCommand("salary11 0")
				LocalPlayer():ConCommand("salary12 150")
				LocalPlayer():ConCommand("salary13 0")
				LocalPlayer():ConCommand("salary14 200")
			end
		salary2cat:SetContents(salary2panel)
		salary2cat:SetSkin(GAMEMODE.Config.DarkRPSkin)

		local HudWidthCat = HUDTABpanel:Add("DCollapsibleCategory")
		HudWidthCat:SetSize(230, 130)
		function HudWidthCat.Header:OnMousePressed() end
		HudWidthCat:SetLabel("HUD width")
		local HudWidthpanel = vgui.Create("DListLayout")
			HudWidthpanel:SetSize(230, 130)
				local HudWidth = HudWidthpanel:Add("DNumSlider")
				HudWidth:SetMinMax(0, ScrW() - 30)
				HudWidth:SetDecimals(0)
				HudWidth:SetConVar("HudW")

			local resetHudWidth = HudWidthpanel:Add("DButton")
			resetHudWidth:SetText("Reset")
			resetHudWidth:SetSize(230, 20)
			resetHudWidth.DoClick = function()
				LocalPlayer():ConCommand("HudW 240")
			end
		HudWidthCat:SetContents(HudWidthpanel)
		HudWidthCat:SetSkin(GAMEMODE.Config.DarkRPSkin)

		local HudHeightCat = HUDTABpanel:Add("DCollapsibleCategory")
		HudHeightCat:SetSize(230, 130)
		function HudHeightCat.Header:OnMousePressed() end
		HudHeightCat:SetLabel("HUD Height")
		local HudHeightpanel = vgui.Create("DListLayout")
			HudHeightpanel:SetSize(230, 130)
				local HudHeight = HudHeightpanel:Add("DNumSlider")
				HudHeight:SetMinMax(1, ScrW() - 20)
				HudHeight:SetDecimals(0)
				HudHeight:SetConVar("HudH")

			local resetHudHeight = HudHeightpanel:Add("DButton")
			resetHudHeight:SetText("Reset")
			resetHudHeight:SetSize(230, 20)
			resetHudHeight.DoClick = function()
				LocalPlayer():ConCommand("HudH 110")
			end
		HudHeightCat:SetContents(HudHeightpanel)
		HudHeightCat:SetSkin(GAMEMODE.Config.DarkRPSkin)
	end
	HUDTABpanel:SetSkin(GAMEMODE.Config.DarkRPSkin)
	return HUDTABpanel
end

function GM:InformationTab()
	local InformationTab = vgui.Create("DPanelList")
	InformationTab:EnableVerticalScrollbar( true )
	function InformationTab:Update()
		self:Clear(true)
	end
	
	local heading = vgui.Create("DLabel", InformationTab)
	heading:SetText("Welcome to Aerolite's Garry's Mod Roleplay Server")
	heading:SetFont("Trebuchet24")
	heading:SizeToContents()		
	
	
	local text = vgui.Create("DLabel", InformationTab)
	text:SetText("\n\nBlack Mesa Roleplay is a Garry's Mod gamemode based on the first Half-Life. Spawn into a Black Mesa Roleplay map made by Aerolite and roleplay in\npre-cascade Black Mesa. Be part of the Science Team, Security Team, HECU Team or become a Cook, IT Technician, Bioworker, Administrator and more.")
	text:SizeToContents()	

	local heading3 = vgui.Create("DLabel", InformationTab)
	heading3:SetText("\n\n\nXP")
	heading3:SetFont("Trebuchet24")
	heading3:SizeToContents()	
	
	local text3 = vgui.Create("DLabel", InformationTab)
	text3:SetText("\n\n\n\n\n\n\n\nRegular players gain 5XP every 10 minutes. If you have donated then you will receive 10XP every 10 minutes. This will allow you to unlock more roles.")
	text3:SizeToContents()
	
	
	local heading2 = vgui.Create("DLabel", InformationTab)
	heading2:SetText("\n\n\n\n\n\nChat Commands")
	heading2:SetFont("Trebuchet24")
	heading2:SizeToContents()	
	
	local text = vgui.Create("DLabel", InformationTab)
	text:SetText("\n\n\n\n\n\n\n\n\n\n\n\n\n// - Type in OOC Chat\n/w - Whisper\n/y - Yell\n.// - Type in Local OOC Chat\n/// - Request help from an admin\n/suitup - Suit up as Scientist or Security.\n/call - Call a player.\n/sms - Send a text message to a player.\n/givesim - Give a player a SIM Card.\n/showid - Show your ID to a player.\n/job - Set a customised job role.\n/name - Change your in-game roleplay name.\n/announce - Announce something to the facility\n/c(all)s(ecurity) <msg> - Call a Security Officer\n/setprice - Use it while looking at a Microwave to change the Price")
	text:SizeToContents()

	InformationTab:Update()
	return InformationTab
end

function GM:RulesTab()
	local RulesTab = vgui.Create("DPanelList")
	RulesTab:EnableVerticalScrollbar( true )
	function RulesTab:Update()
		self:Clear(true)
	end
	
	local heading = vgui.Create("DLabel", RulesTab)
	heading:SetText("Aerolite's Server Rules")
	heading:SetFont("Trebuchet24")
		heading:SizeToContents()		
	
	
	local text = vgui.Create("DLabel", RulesTab)
	text:SetText("\n\n1. No inappropriate language is allowed on the server whether it be in the text chat or voice.\n2. Do not be disrespectful or hateful to other players and members of staff.\n3. Advertising on our server is strictly prohibited unless it is for use in a roleplay situation.\n4. Do not attempt to prop kill, prop block or prop climb.\n5. Do not randomly deathmatch players; every kill must have a reason.\n6. Please report bugs and exploits to an admin and do not attempt to abuse them.\n7. Bunnyhopping and use of the physgun when not building is not allowed.\n8. New Life Rule; If your character dies then you must start a new life with no previous memories.\n9. Do not attempt to lag or crash the server.\n10. This is an English server so please use English only in both text chat and voice chat.\n11. Please respect an admin\'s decision. If you have a problem with it then raise a complaint at AeroliteGaming.com.\n12. Do not metagame - Using out of character information in character.\n")
	text:SizeToContents()		

	
	local text2 = vgui.Create("DLabel", RulesTab)
	text2:SetText("\n\n\n\n\n\n\n\n\n\n\n\n\n\n13. Please set appropriate roleplay names and do not use popular game/tv/movie names.\n14. Do not enforce rules upon other players instead give them helpful guidance on how to improve.\n15. Not all rules are listed here as many are common sense. These rules may be updated at any time without notice.\n\n Failure to abide by these rules will result in a permanent ban. To be unbanned you must make an unban request at Aerolite.ovh.\n\nThanks and have fun!")
	text2:SizeToContents()
	
	RulesTab:Update()
	return RulesTab
end

local DefaultWeapons = {
{name = "GravGun",class = "weapon_physcannon"},
{name = "Physgun",class = "weapon_physgun"},
{name = "Crowbar",class = "weapon_crowbar"},
{name = "Stunstick",class = "weapon_stunstick"},
{name = "Pistol",class = "weapon_pistol"},
{name = "357",	class = "weapon_357"},
{name = "SMG", class = "weapon_smg1"},
{name = "Shotgun", class = "weapon_shotgun"},
{name = "Crossbow", class = "weapon_crossbow"},
{name = "AR2", class = "weapon_ar2"},
{name = "BugBait",	class = "weapon_bugbait"},
{name = "RPG", class = "weapon_rpg"}
}
