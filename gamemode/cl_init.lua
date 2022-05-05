GM.Version = "0.1"
GM.Name = "Black Mesa Roleplay"
GM.Author = "By Aerolite.ovh"

DeriveGamemode("sandbox")
util.PrecacheSound("earthquake.mp3")

/*---------------------------------------------------------------------------
Names
---------------------------------------------------------------------------*/
-- Make sure the client sees the RP name where they expect to see the name
local pmeta = FindMetaTable("Player")

pmeta.SteamName = pmeta.SteamName or pmeta.Name
function pmeta:Name()
	return GAMEMODE.Config.allowrpnames and self.DarkRPVars and self:getDarkRPVar("rpname")
		or self:SteamName()
end

pmeta.GetName = pmeta.Name
pmeta.Nick = pmeta.Name
-- End

function GM:DrawDeathNotice(x, y)
	if not GAMEMODE.Config.showdeaths then return end
	self.BaseClass:DrawDeathNotice(x, y)
end

local function DisplayNotify(msg)
	local txt = msg:ReadString()
	GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
	surface.PlaySound("buttons/lightswitch2.wav")

	-- Log to client console
	print(txt)
end
usermessage.Hook("_Notify", DisplayNotify)

local function LoadModules()
	local root = GM.FolderName.."/gamemode/modules/"

	local _, folders = file.Find(root.."*", "LUA")

	for _, folder in SortedPairs(folders, true) do
		if GM.Config.DisabledModules[folder] then continue end

		for _, File in SortedPairs(file.Find(root .. folder .."/sh_*.lua", "LUA"), true) do
			if File == "sh_interface.lua" then continue end
			include(root.. folder .. "/" ..File)
		end
		for _, File in SortedPairs(file.Find(root .. folder .."/cl_*.lua", "LUA"), true) do
			if File == "cl_interface.lua" then continue end
			include(root.. folder .. "/" ..File)
		end
	end
end

GM.Config = {} -- config table
BuiltSpawnIcons = {}

include("config.lua")
include("sh_interfaceloader.lua")
include("client/help.lua")

include("client/cl_chatlisteners.lua")
include("client/DRPDermaSkin.lua")
include("client/helpvgui.lua")
include("client/hud.lua")
include("client/showteamtabs.lua")
include("client/vgui.lua")
include("client/aerolite.lua")

include("shared/player_class.lua")
include("shared/animations.lua")
include("shared/commands.lua")
include("shared/entity.lua")
include("shared/MakeThings.lua")
include("shared/Workarounds.lua")
include("shared/soundfix.lua")

include("shared.lua")
include("addentities.lua")
include("ammotypes.lua")

include("fpp/sh_settings.lua")
include("fpp/client/FPP_Menu.lua")
include("fpp/client/FPP_HUD.lua")
include("fpp/client/FPP_Buddies.lua")
include("fpp/sh_CPPI.lua")

LoadModules()

DarkRP.finish()

surface.CreateFont("AckBarWriting", {
	size = 20,
	weight = 500,
	antialias = true,
	shadow = false,
	font = "akbar"})

-- Copy from FESP(made by FPtje Falco)
-- This is no stealing since I made FESP myself.
local vector = FindMetaTable("Vector")
function vector:RPIsInSight(v, ply)
	ply = ply or LocalPlayer()
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = self
	trace.filter = v
	trace.mask = -1
	local TheTrace = util.TraceLine(trace)
	if TheTrace.Hit then
		return false, TheTrace.HitPos
	else
		return true, TheTrace.HitPos
	end
end

function GM:HUDShouldDraw(name)
	if name == "CHudHealth" or
		name == "CHudBattery" or
		name == "CHudSuitPower" or
		(HelpToggled and name == "CHudChat") then
			return false
	else
		return true
	end
end

function GM:HUDDrawTargetID()
    return false
end

function GM:FindPlayer(info)
	if not info or info == "" then return nil end
	local pls = player.GetAll()

	for k = 1, #pls do -- Proven to be faster than pairs loop.
		local v = pls[k]
		if tonumber(info) == v:UserID() then
			return v
		end

		if info == v:SteamID() then
			return v
		end

		if string.find(string.lower(v:SteamName()), string.lower(tostring(info)), 1, true) ~= nil then
			return v
		end

		if string.find(string.lower(v:Name()), string.lower(tostring(info)), 1, true) ~= nil then
			return v
		end
	end
	return nil
end

local GUIToggled = false
local HelpToggled = false

/*local HelpVGUI
function GM:ShowHelp()
	if not HelpVGUI then
		HelpVGUI = vgui.Create("HelpVGUI")
	end

	HelpToggled = not HelpToggled

	HelpVGUI.HelpX = HelpVGUI.StartHelpX
	HelpVGUI:FillHelpInfo()
	HelpVGUI:SetVisible(HelpToggled)
	gui.EnableScreenClicker(HelpToggled)
end
*/
local mouseX, mouseY = ScrW() / 2, ScrH() / 2
function GM:ShowSpare1()

	if MouseModeActive == true then
		MouseModeActive = false
	else
		MouseModeActive = true
	end	

	GUIToggled = not GUIToggled

	if GUIToggled then
		gui.SetMousePos(mouseX, mouseY)
	else
		mouseX, mouseY = gui.MousePos()
	end
	gui.EnableScreenClicker(GUIToggled)
	
end

local function blackScreen(um)
	local toggle = um:ReadBool()
	if toggle then
		local black = Color(0, 0, 0)
		local w, h = ScrW(), ScrH()
		hook.Add("HUDPaintBackground", "BlackScreen", function()
			surface.SetDrawColor(black)
			surface.DrawRect(0, 0, w, h)
		end)
	else
		hook.Remove("HUDPaintBackground", "BlackScreen")
	end
end
usermessage.Hook("blackScreen", blackScreen)

local function BlackAndWhite(um)
	local toggle = um:ReadBool()
	if toggle then
		RunConsoleCommand("pp_colormod", "1")
		RunConsoleCommand("pp_colormod_color", "0")
	else
		RunConsoleCommand("pp_colormod", "0")
	end
end
usermessage.Hook("BlackAndWhite", BlackAndWhite)

function GM:PlayerStartVoice(ply)
	if ply == LocalPlayer() then
		ply.DRPIsTalking = true
		return -- Not the original rectangle for yourself! ugh!
	end
	self.BaseClass:PlayerStartVoice(ply)
end

function GM:PlayerEndVoice(ply)
	if ply == LocalPlayer() then
		ply.DRPIsTalking = false
		return
	end

	self.BaseClass:PlayerEndVoice(ply)
end

function GM:OnPlayerChat()
end

local FKeyBinds = {
	["gm_showhelp"] = "ShowHelp",
	["gm_showteam"] = "ShowTeam",
	["gm_showspare1"] = "ShowSpare1",
	["gm_showspare2"] = "ShowSpare2"
}

function GM:PlayerBindPress(ply, bind, pressed)
	self.BaseClass:PlayerBindPress(ply, bind, pressed)
	if ply == LocalPlayer() and IsValid(ply:GetActiveWeapon()) and string.find(string.lower(bind), "attack2") and ply:GetActiveWeapon():GetClass() == "weapon_bugbait" then
		LocalPlayer():ConCommand("_hobo_emitsound")
	end

	local bnd = string.match(string.lower(bind), "gm_[a-z]+[12]?")
	if bnd and FKeyBinds[bnd] and GAMEMODE[FKeyBinds[bnd]] then
		GAMEMODE[FKeyBinds[bnd]](GAMEMODE)
	end

	return
end

local function AddToChat(msg)
	local col1 = Color(msg:ReadShort(), msg:ReadShort(), msg:ReadShort())

	local prefixText = msg:ReadString()
	local ply = msg:ReadEntity()
	ply = IsValid(ply) and ply or LocalPlayer()

	if prefixText == "" or not prefixText then
		prefixText = ply:Nick()
		prefixText = prefixText ~= "" and prefixText or ply:SteamName()
	end

	local col2 = Color(msg:ReadShort(), msg:ReadShort(), msg:ReadShort())

	local text = msg:ReadString()
	local shouldShow
	if text and text ~= "" then
		if IsValid(ply) then
			shouldShow = hook.Call("OnPlayerChat", nil, ply, text, false, not ply:Alive(), prefixText, col1, col2)
		end

		if shouldShow ~= true then
			chat.AddText(col1, prefixText, col2, ": "..text)
		end
	else
		shouldShow = hook.Call("ChatText", nil, "0", prefixText, prefixText, "none")
		if shouldShow ~= true then
			chat.AddText(col1, prefixText)
		end
	end
	chat.PlaySound()
end
usermessage.Hook("DarkRP_Chat", AddToChat)

local function GetAvailableVehicles()
	print("Available vehicles for custom vehicles:")
	for k,v in pairs(DarkRP.getAvailableVehicles()) do
		print("\""..k.."\"")
	end
end
concommand.Add("rp_getvehicles", GetAvailableVehicles)

local function AdminLog(um)
	local colour = Color(um:ReadShort(), um:ReadShort(), um:ReadShort())
	local text = um:ReadString() .. "\n"
	MsgC(Color(255,0,0), "[BMRP] ")
	MsgC(colour, text)
end
usermessage.Hook("DRPLogMsg", AdminLog)

local function RetrieveDoorData(len)
	local door = net.ReadEntity()
	local doorData = net.ReadTable()
	if not door or not door.IsValid or not IsValid(door) or not doorData then return end

	if doorData.TeamOwn then
		local tdata = {}
		for k, v in pairs(string.Explode("\n", doorData.TeamOwn or "")) do
			if v and v != "" then
				tdata[tonumber(v)] = true
			end
		end
		doorData.TeamOwn = tdata
	else
		doorData.TeamOwn = nil
	end

	door.DoorData = doorData
end
net.Receive("DarkRP_DoorData", RetrieveDoorData)

local function UpdateDoorData(um)
	local door = um:ReadEntity()
	if not IsValid(door) then return end

	local var, value = um:ReadString(), um:ReadString()
	value = tonumber(value) or value

	if string.match(tostring(value), "Entity .([0-9]*)") then
		value = Entity(string.match(value, "Entity .([0-9]*)"))
	end

	if string.match(tostring(value), "Player .([0-9]*)") then
		value = Entity(string.match(value, "Player .([0-9]*)"))
	end

	if value == "true" or value == "false" then value = tobool(value) end

	if value == "nil" then value = nil end

	if var == "TeamOwn" then
		local decoded = {}
		for k, v in pairs(string.Explode("\n", value or "")) do
			if v and v != "" then
				decoded[tonumber(v)] = true
			end
		end
		if table.Count(decoded) == 0 then
			value = nil
		else
			value = decoded
		end
	end

	door.DoorData = door.DoorData or {}
	door.DoorData[var] = value
end
usermessage.Hook("DRP_UpdateDoorData", UpdateDoorData)

local function RetrievePlayerVar(entIndex, var, value, tries)
	local ply = Entity(entIndex)

	-- Usermessages _can_ arrive before the player is valid.
	-- In this case, chances are huge that this player will become valid.
	if not IsValid(ply) then
		if tries >= 5 then return end

		timer.Simple(0.5, function() RetrievePlayerVar(entIndex, var, value, tries + 1) end)
		return
	end

	ply.DarkRPVars = ply.DarkRPVars or {}

	local stringvalue = value
	value = tonumber(value) or value

	if string.match(stringvalue, "Entity .([0-9]*)") then
		value = Entity(string.match(stringvalue, "Entity .([0-9]*)"))
	end

	if string.match(stringvalue, "^Player .([0-9]+).") then
		value = player.GetAll()[tonumber(string.match(stringvalue, "^Player .([0-9]+)."))]
	end

	if stringvalue == "NULL" then
		value = NULL
	end

	if string.match(stringvalue, [[(-?[0-9]+.[0-9]+) (-?[0-9]+.[0-9]+) (-?[0-9]+.[0-9]+)]]) then
		local x,y,z = string.match(value, [[(-?[0-9]+.[0-9]+) (-?[0-9]+.[0-9]+) (-?[0-9]+.[0-9]+)]])
		value = Vector(x,y,z)
	end

	if stringvalue == "true" or stringvalue == "false" then value = tobool(value) end

	if stringvalue == "nil" then value = nil end

	hook.Call("DarkRPVarChanged", nil, ply, var, ply.DarkRPVars[var], value)
	ply.DarkRPVars[var] = value
end

function pmeta:getDarkRPVar(var)
	self.DarkRPVars = self.DarkRPVars or {}
	return self.DarkRPVars[var]
end

/*---------------------------------------------------------------------------
Retrieve a player var.
Read the usermessage and attempt to set the DarkRP var
---------------------------------------------------------------------------*/
local function doRetrieve(um)
	local entIndex = um:ReadShort()
	local var, value = um:ReadString(), um:ReadString()
	RetrievePlayerVar(entIndex, var, value, 0)
end
usermessage.Hook("DarkRP_PlayerVar", doRetrieve)

local function InitializeDarkRPVars(len)
	local vars = net.ReadTable()

	if not vars then return end
	for k,v in pairs(vars) do
		if not IsValid(k) then continue end
		k.DarkRPVars = k.DarkRPVars or {}

		-- Merge the tables
		for a, b in pairs(v) do
			k.DarkRPVars[a] = b
		end
	end
end
net.Receive("DarkRP_InitializeVars", InitializeDarkRPVars)

function GM:InitPostEntity()
	RunConsoleCommand("_sendDarkRPvars")
	timer.Create("DarkRPCheckifitcamethrough", 15, 0, function()
		for k,v in pairs(player.GetAll()) do
			if v.DarkRPVars and v:getDarkRPVar("rpname") then continue end

			RunConsoleCommand("_sendDarkRPvars")
			return
		end
	end)
	hook.Call("TeamChanged", GAMEMODE, 1, 1)
end

function GM:TeamChanged(before, after)
	self:RemoveHelpCategory(0)
	if RPExtraTeams[after] and RPExtraTeams[after].help then
		self:AddHelpCategory(0, RPExtraTeams[after].name .. " help")
		self:AddHelpLabels(0, RPExtraTeams[after].help)
	end
end

local function OnChangedTeam(um)
	hook.Call("TeamChanged", GAMEMODE, um:ReadShort(), um:ReadShort())
end
usermessage.Hook("OnChangedTeam", OnChangedTeam)

function GM:TextWrap(text, font, pxWidth)
	local total = 0

	surface.SetFont(font)
	text = text:gsub(".", function(char)
		if char == "\n" then
			total = 0
		end

		total = total + surface.GetTextSize(char)

		-- Wrap around when the max width is reached
		if total >= pxWidth then
			total = 0
			return "\n" .. char
		end

		return char
	end)

	return text
end


-- Please only ADD to the credits
-- Removing people from the credits will make at least one person very angry.
local creds =
[[LightRP:
Rick darkalonio

DarkRP:
Rickster
Picwizdan
Sibre
PhilXYZ
[GNC] Matt
Chromebolt A.K.A. unib5 (STEAM_0:1:19045957)
Falco A.K.A. FPtje (STEAM_0:0:8944068)
Eusion (STEAM_0:0:20450406)
Drakehawke (STEAM_0:0:22342869)]]

local function credits(um)
	chat.AddText(Color(255,0,0,255), "CREDITS FOR DARKRP", Color(0,0,255,255), creds)
end
usermessage.Hook("DarkRP_Credits", credits)

-- DarkRP plugin for FAdmin. It's this simple to make a plugin. If FAdmin isn't installed, this code won't bother anyone
include(GM.FolderName.."/gamemode/shared/fadmin_darkrp.lua")

local function formatNumber(n)
	if not n then return "" end
	if n >= 1e14 then return tostring(n) end
    n = tostring(n)
    local sep = sep or ","
    local dp = string.find(n, "%.") or #n+1
	for i=dp-4, 1, -3 do
		n = n:sub(1, i) .. sep .. n:sub(i+1)
    end
    return n
end

if not FAdmin or not FAdmin.StartHooks then return end
FAdmin.StartHooks["DarkRP"] = function()
	-- DarkRP information:
	FAdmin.ScoreBoard.Player:AddInformation("Steam name", function(ply) return ply:SteamName() end, true)
	FAdmin.ScoreBoard.Player:AddInformation("Money", function(ply) if LocalPlayer():IsAdmin() and ply.DarkRPVars and ply:getDarkRPVar("money") then return GAMEMODE.Config.currency..formatNumber(ply:getDarkRPVar("money")) end end)
	FAdmin.ScoreBoard.Player:AddInformation("XP", function(ply) return ply:getDarkRPVar("xp") end)
	FAdmin.ScoreBoard.Player:AddInformation("Wanted", function(ply) if ply.DarkRPVars and ply:getDarkRPVar("wanted") then return tostring(ply:getDarkRPVar("wantedReason") or "N/A") end end)
	FAdmin.ScoreBoard.Player:AddInformation("Community link", function(ply) return FAdmin.SteamToProfile(ply) end)
	FAdmin.ScoreBoard.Player:AddInformation("Rank", function(ply)
		if FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "SeeAdmins") then
			return ply:GetNWString("usergroup")
		end
	end)

	-- Warrant
	FAdmin.ScoreBoard.Player:AddActionButton("Warrant", "FAdmin/icons/Message",	Color(0, 0, 200, 255),
		function(ply) return LocalPlayer():IsCP() end,
		function(ply, button)
			Derma_StringRequest("Warrant reason", "Enter the reason for the warrant", "", function(Reason)
				RunConsoleCommand("darkrp", "/warrant", ply:SteamID(), Reason)
			end)
		end)

	--wanted
	FAdmin.ScoreBoard.Player:AddActionButton(function(ply)
			return ((ply:getDarkRPVar("wanted") and "Unw") or "W") .. "anted"
		end,
		function(ply) return "FAdmin/icons/jail", ply:getDarkRPVar("wanted") and "FAdmin/icons/disable" end,
		Color(0, 0, 200, 255),
		function(ply) return LocalPlayer():IsCP() end,
		function(ply, button)
			if not ply:getDarkRPVar("wanted")  then
				Derma_StringRequest("wanted reason", "Enter the reason to arrest this player", "", function(Reason)
					RunConsoleCommand("darkrp", "/wanted", ply:SteamID(), Reason)
				end)
			else
				RunConsoleCommand("darkrp", "/unwanted", ply:UserID())
			end
		end)

	--Teamban
	local function teamban(ply, button)
		local menu = DermaMenu()
		local Title = vgui.Create("DLabel")
		Title:SetText("  Jobs:n")
		Title:SetFont("UiBold")
		Title:SizeToContents()
		Title:SetTextColor(color_black)
		local command = "rp_teamban"

		menu:AddPanel(Title)
		for k,v in SortedPairsByMemberValue(RPExtraTeams, "name") do
			local submenu = menu:AddSubMenu(v.name)
			submenu:AddOption("2 minutes", function() RunConsoleCommand(command, ply:UserID(), k, 120) end)
			submenu:AddOption("Half an hour", function() RunConsoleCommand(command, ply:UserID(), k, 1800) end)
			submenu:AddOption("An hour", function() RunConsoleCommand(command, ply:UserID(), k, 3600) end)
			submenu:AddOption("Until restart", function() RunConsoleCommand(command, ply:UserID(), k, 0) end)
		end
		menu:Open()
	end
	FAdmin.ScoreBoard.Player:AddActionButton("Ban from job", "FAdmin/icons/changeteam", Color(200, 0, 0, 255),
	function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "rp_commands", ply) end, teamban)

	local function teamunban(ply, button)
		local menu = DermaMenu()
		local Title = vgui.Create("DLabel")
		Title:SetText("  Jobs:\n")
		Title:SetFont("UiBold")
		Title:SizeToContents()
		Title:SetTextColor(color_black)
		local command = "rp_teamunban"

		menu:AddPanel(Title)
		for k,v in SortedPairsByMemberValue(RPExtraTeams, "name") do
			menu:AddOption(v.name, function() RunConsoleCommand(command, ply:UserID(), k) end)
		end
		menu:Open()
	end
	FAdmin.ScoreBoard.Player:AddActionButton("Unban from job", function() return "FAdmin/icons/changeteam", "FAdmin/icons/disable" end, Color(200, 0, 0, 255),
	function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "rp_commands", ply) end, teamunban)
end




function Spawntimer(ply)
--if LocalPlayer():Alive() == false then
spawntime = 30
	
	timer.Create( "SendSpawnTime", 1, 0, function()
	if spawntime == 0 then timer.Stop("SendSpawnTime")  else
		spawntime = spawntime -1

	end
	end)
end
concommand.Add( "SpawnTimer", Spawntimer )
--end


/* Question 1 */
function Question1( ply )
local Question1 = vgui.Create( "DFrame" )
Question1:CenterVertical( )
Question1:CenterHorizontal()
Question1:SetSize( 300, 180 )
Question1:Center()
Question1:SetTitle( "Aerolite Server Quiz" )
Question1:SetVisible( true )
Question1:SetDraggable( false )
Question1:ShowCloseButton( false )
Question1:MakePopup()


local Question1Button3 = vgui.Create( "DButton", Question1)
Question1Button3:SetParent( Question1 ) -- Set parent to our "DermaPanel"
Question1Button3:SetText( "Start Quiz" )
Question1Button3:SetPos( 90, 110 )
Question1Button3:SetSize( 120, 20 )
Question1Button3.DoClick = function( ply )
	Question1:SetVisible( false )
	LocalPlayer():ConCommand("Question2")
end

local Question1Label1 = vgui.Create("DLabel", Question1)
Question1Label1:SetText("To play on our servers we require you to go through a quiz\nwhich will prove to us you are capable of basic roleplay.\n\nYou can read a thread on our forum to gather the\nanswers to some of these questions.")
Question1Label1:SizeToContents() // make the control the same size as the text.
Question1Label1:SetPos( 5, 25 )

local Question1Label2 = vgui.Create("DLabel", Question1)
Question1Label2:SetText("You cannot play until you answer these questions!")
Question1Label2:SizeToContents() // make the control the same size as the text.s
Question1Label2:SetPos( 30, 145 )

end
concommand.Add( "Question1", Question1 )

/* Question 2 */
function Question2( ply )
local Question2 = vgui.Create( "DFrame" )
Question2:CenterVertical( )
Question2:CenterHorizontal()
Question2:SetSize( 300, 180 )
Question2:Center()
Question2:SetTitle( "Aerolite Server Quiz" )
Question2:SetVisible( true )
Question2:SetDraggable( false )
Question2:ShowCloseButton( false )
Question2:MakePopup()


local Question2Button3 = vgui.Create( "DButton", Question2)
Question2Button3:SetParent( Question2 ) -- Set parent to our "DermaPanel"
Question2Button3:SetText( "Out Of Character" )
Question2Button3:SetPos( 90, 70 )
Question2Button3:SetSize( 120, 20 )
Question2Button3.DoClick = function( ply )
	Question2:SetVisible( false )
	LocalPlayer():ConCommand("Question3")
end

local Question2Button4 = vgui.Create( "DButton", Question2)
Question2Button4:SetParent( Question2 ) 
Question2Button4:SetText( "Out of Combine" )
Question2Button4:SetPos( 90, 95 )
Question2Button4:SetSize( 120, 20 )
Question2Button4.DoClick = function( ply )
	Question2:SetVisible( false )
	LocalPlayer():ConCommand("disconnect")
end

local Question2Button5 = vgui.Create( "DButton", Question2)
Question2Button5:SetParent( Question2 ) 
Question2Button5:SetText( "Out of Characters" )
Question2Button5:SetPos( 90, 120 )
Question2Button5:SetSize( 120, 20 )
Question2Button5.DoClick = function( ply )
	Question2:SetVisible( false )
	LocalPlayer():ConCommand("disconnect")
end

local Question2Label1 = vgui.Create("DLabel", Question2)
Question2Label1:SetText("What does OOC stand for in roleplay?")
Question2Label1:SizeToContents() // make the control the same size as the text.
Question2Label1:SetPos( 60, 30 )

end
concommand.Add( "Question2", Question2 )

/* Question 3 */
function Question3( ply )
local Question3 = vgui.Create( "DFrame" )
Question3:CenterVertical( )
Question3:CenterHorizontal()
Question3:SetSize( 300, 180 )
Question3:Center()
Question3:SetTitle( "Aerolite Server Quiz" )
Question3:SetVisible( true )
Question3:SetDraggable( false )
Question3:ShowCloseButton( false )
Question3:MakePopup()


local Question3Button3 = vgui.Create( "DButton", Question3)
Question3Button3:SetParent( Question3 ) -- Set parent to our "DermaPanel"
Question3Button3:SetText( "Area 51" )
Question3Button3:SetPos( 90, 70 )
Question3Button3:SetSize( 120, 20 )
Question3Button3.DoClick = function( ply )
	Question3:SetVisible( false )
	LocalPlayer():ConCommand("disconnect")	
end

local Question3Button4 = vgui.Create( "DButton", Question3)
Question3Button4:SetParent( Question3 ) 
Question3Button4:SetText( "New Mexico" )
Question3Button4:SetPos( 90, 95 )
Question3Button4:SetSize( 120, 20 )
Question3Button4.DoClick = function( ply )
	Question3:SetVisible( false )
	LocalPlayer():ConCommand("Question4")
end

local Question3Button5 = vgui.Create( "DButton", Question3)
Question3Button5:SetParent( Question3 ) 
Question3Button5:SetText( "New York" )
Question3Button5:SetPos( 90, 120 )
Question3Button5:SetSize( 120, 20 )
Question3Button5.DoClick = function( ply )
	Question3:SetVisible( false )
	LocalPlayer():ConCommand("disconnect")
end

local Question3Label1 = vgui.Create("DLabel", Question3)
Question3Label1:SetText("Where is the Black Mesa Research Facility set?")
Question3Label1:SizeToContents() // make the control the same size as the text.
Question3Label1:SetPos( 35, 30 )

end
concommand.Add( "Question3", Question3 )

/* Question 4 */
function Question4( ply )
local Question4 = vgui.Create( "DFrame" )
Question4:CenterVertical( )
Question4:CenterHorizontal()
Question4:SetSize( 300, 180 )
Question4:Center()
Question4:SetTitle( "Aerolite Server Quiz" )
Question4:SetVisible( true )
Question4:SetDraggable( false )
Question4:ShowCloseButton( false )
Question4:MakePopup()


local Question4Button3 = vgui.Create( "DButton", Question4)
Question4Button3:SetParent( Question4 ) -- Set parent to our "DermaPanel"
Question4Button3:SetText( "7:51AM" )
Question4Button3:SetPos( 90, 70 )
Question4Button3:SetSize( 120, 20 )
Question4Button3.DoClick = function( ply )
	Question4:SetVisible( false )
	LocalPlayer():ConCommand("disconnect")	
end

local Question4Button4 = vgui.Create( "DButton", Question4)
Question4Button4:SetParent( Question4 ) 
Question4Button4:SetText( "8:47AM" )
Question4Button4:SetPos( 90, 95 )
Question4Button4:SetSize( 120, 20 )
Question4Button4.DoClick = function( ply )
	Question4:SetVisible( false )
	LocalPlayer():ConCommand("Question5")
end

local Question4Button5 = vgui.Create( "DButton", Question4)
Question4Button5:SetParent( Question4 ) 
Question4Button5:SetText( "8:49AM" )
Question4Button5:SetPos( 90, 120 )
Question4Button5:SetSize( 120, 20 )
Question4Button5.DoClick = function( ply )
	Question4:SetVisible( false )
	LocalPlayer():ConCommand("disconnect")
end

local Question4Label1 = vgui.Create("DLabel", Question4)
Question4Label1:SetText("Gordon Freeman set off from the dormitories in\n Black Mesa at what time in the morning?")
Question4Label1:SizeToContents() // make the control the same size as the text.
Question4Label1:SetPos( 35, 30 )

end
concommand.Add( "Question4", Question4 )


/* Question 5 */
function Question5( ply )
local Question5 = vgui.Create( "DFrame" )
Question5:CenterVertical( )
Question5:CenterHorizontal()
Question5:SetSize( 300, 180 )
Question5:Center()
Question5:SetTitle( "Aerolite Server Quiz" )
Question5:SetVisible( true )
Question5:SetDraggable( false )
Question5:ShowCloseButton( false )
Question5:MakePopup()

local Question5Button3 = vgui.Create( "DButton", Question5)
Question5Button3:SetParent( Question5 ) -- Set parent to our "DermaPanel"
Question5Button3:SetText( "Marcus Eikenberry" )
Question5Button3:SetPos( 90, 70 )
Question5Button3:SetSize( 120, 20 )
Question5Button3.DoClick = function( ply )
	Question5:SetVisible( false )
	LocalPlayer():ConCommand("disconnect")	
end

local Question5Button4 = vgui.Create( "DButton", Question5)
Question5Button4:SetParent( Question5 ) 
Question5Button4:SetText( "James Doakes" )
Question5Button4:SetPos( 90, 95 )
Question5Button4:SetSize( 120, 20 )
Question5Button4.DoClick = function( ply )
	Question5:SetVisible( false )
	LocalPlayer():ConCommand("disconnect")
end

local Question5Button5 = vgui.Create( "DButton", Question5)
Question5Button5:SetParent( Question5 ) 
Question5Button5:SetText( "Wallace Breen" )
Question5Button5:SetPos( 90, 120 )
Question5Button5:SetSize( 120, 20 )
Question5Button5.DoClick = function( ply )
	Question5:SetVisible( false )
	LocalPlayer():ConCommand("Question6")
end

local Question5Label1 = vgui.Create("DLabel", Question5)
Question5Label1:SetText("What was the name of the Black Mesa Administrator\n in Half-Life 1 and Earth Administrator in Half-Life 2?")
Question5Label1:SizeToContents() // make the control the same size as the text.
Question5Label1:SetPos( 25, 30 )

end
concommand.Add( "Question5", Question5 )


/* Question 6 */
function Question6( ply )
local Question6 = vgui.Create( "DFrame" )
Question6:CenterVertical( )
Question6:CenterHorizontal()
Question6:SetSize( 300, 180 )
Question6:Center()
Question6:SetTitle( "Aerolite Server Quiz" )
Question6:SetVisible( true )
Question6:SetDraggable( false )
Question6:ShowCloseButton( false )
Question6:MakePopup()

local Question6Button3 = vgui.Create( "DButton", Question6)
Question6Button3:SetParent( Question6 ) -- Set parent to our "DermaPanel"
Question6Button3:SetText( "Notch" )
Question6Button3:SetPos( 90, 70 )
Question6Button3:SetSize( 120, 20 )
Question6Button3.DoClick = function( ply )
	Question6:SetVisible( false )
	LocalPlayer():ConCommand("disconnect")	
end

local Question6Button4 = vgui.Create( "DButton", Question6)
Question6Button4:SetParent( Question6 ) 
Question6Button4:SetText( "Garry Newman" )
Question6Button4:SetPos( 90, 95 )
Question6Button4:SetSize( 120, 20 )
Question6Button4.DoClick = function( ply )
	Question6:SetVisible( false )
	LocalPlayer():ConCommand("disconnect")
end

local Question6Button5 = vgui.Create( "DButton", Question6)
Question6Button5:SetParent( Question6 ) 
Question6Button5:SetText( "Facepunch Studios" )
Question6Button5:SetPos( 90, 120 )
Question6Button5:SetSize( 120, 20 )
Question6Button5.DoClick = function( ply )
	Question6:SetVisible( false )
	LocalPlayer():ConCommand("Question7")
end

local Question6Label1 = vgui.Create("DLabel", Question6)
Question6Label1:SetText("Garry's Mod is a game made by which company based\n in England in the United Kingdom?")
Question6Label1:SizeToContents() // make the control the same size as the text.
Question6Label1:SetPos( 25, 30 )

end
concommand.Add( "Question6", Question6 )


/* Question 7 */
function Question7( ply )
local Question7 = vgui.Create( "DFrame" )
Question7:CenterVertical( )
Question7:CenterHorizontal()
Question7:SetSize( 300, 180 )
Question7:Center()
Question7:SetTitle( "Aerolite Server Quiz" )
Question7:SetVisible( true )
Question7:SetDraggable( false )
Question7:ShowCloseButton( false )
Question7:MakePopup()

local Question7Button3 = vgui.Create( "DButton", Question7)
Question7Button3:SetParent( Question7 ) -- Set parent to our "DermaPanel"
Question7Button3:SetText( "1996" )
Question7Button3:SetPos( 90, 70 )
Question7Button3:SetSize( 120, 20 )
Question7Button3.DoClick = function( ply )
	Question7:SetVisible( false )
	LocalPlayer():ConCommand("Question8")	
end

local Question7Button4 = vgui.Create( "DButton", Question7)
Question7Button4:SetParent( Question7 ) 
Question7Button4:SetText( "1997" )
Question7Button4:SetPos( 90, 95 )
Question7Button4:SetSize( 120, 20 )
Question7Button4.DoClick = function( ply )
	Question7:SetVisible( false )
	LocalPlayer():ConCommand("disconnect")
end

local Question7Button5 = vgui.Create( "DButton", Question7)
Question7Button5:SetParent( Question7 ) 
Question7Button5:SetText( "1998" )
Question7Button5:SetPos( 90, 120 )
Question7Button5:SetSize( 120, 20 )
Question7Button5.DoClick = function( ply )
	Question7:SetVisible( false )
	LocalPlayer():ConCommand("disconnect")
end

local Question7Label1 = vgui.Create("DLabel", Question7)
Question7Label1:SetText("The game company 'Valve' was founded in which year?")
Question7Label1:SizeToContents() // make the control the same size as the text.
Question7Label1:SetPos( 25, 30 )

end
concommand.Add( "Question7", Question7 )


/* Question 8 */
function Question8( ply )
local Question8 = vgui.Create( "DFrame" )
Question8:CenterVertical( )
Question8:CenterHorizontal()
Question8:SetSize( 350, 160 )
Question8:Center()
Question8:SetTitle( "Aerolite Server Quiz" )
Question8:SetVisible( true )
Question8:SetDraggable( false )
Question8:ShowCloseButton( false )
Question8:MakePopup()

local Question8Button5 = vgui.Create( "DButton", Question8)
Question8Button5:SetParent( Question8 ) 
Question8Button5:SetText( "Continue" )
Question8Button5:SetPos( 120, 120 )
Question8Button5:SetSize( 120, 20 )
Question8Button5.DoClick = function( ply )
	Question8:SetVisible( false )
	LocalPlayer():ConCommand("Question9")
	--RunConsoleCommand("disconnect")
end

local Question8Label1 = vgui.Create("DLabel", Question8)
Question8Label1:SetText("Thank you for completing the quiz. This server is still a work\nin progress. Press F4 after setting your roleplay name and view the\ninformation, rules, jobs and marketplace.\n\nYou will gain 5XP or 10XP if you're a donator every 30 minutes and\nyou will unlock new jobs for each 30 minute session you spend on\nthe server.")
Question8Label1:SizeToContents() // make the control the same size as the text.
Question8Label1:SetPos( 15, 30 )

end
concommand.Add( "Question8", Question8 )

/* Question 9 */
function Question9( ply )
local Question9 = vgui.Create( "DFrame" )
Question9:CenterVertical( )
Question9:CenterHorizontal()
Question9:SetSize( 350, 160 )
Question9:Center()
Question9:SetTitle( "Setting a roleplay name" )
Question9:SetVisible( true )
Question9:SetDraggable( false )
Question9:ShowCloseButton( false )
Question9:MakePopup()

local DermaTextBox = vgui.Create( "DTextEntry", Question9 )
DermaTextBox:SetPos( 60, 70 )                     // Set position
DermaTextBox:SetTall( 20 )                        // Set height - 20px is default text height
DermaTextBox:SetWide( 100 )                       // Set width
DermaTextBox:SetText( "First Name" )
DermaTextBox:SetEnterAllowed( true )                // Allow people to press enter on the box
DermaTextBox.OnGetFocus = function(PanelVar) -- Passes a single argument, the text entry object.
		DermaTextBox:SetText("")
end

local DermaTextBox2 = vgui.Create( "DTextEntry", Question9 )
DermaTextBox2:SetPos( 185, 70 )                     // Set position
DermaTextBox2:SetTall( 20 )                        // Set height - 20px is default text height
DermaTextBox2:SetWide( 100 )                       // Set width
DermaTextBox2:SetText( "Last Name" )
DermaTextBox2:SetEnterAllowed( true )                // Allow people to press enter on the box
DermaTextBox2.OnGetFocus = function(PanelVar) -- Passes a single argument, the text entry object.
		DermaTextBox2:SetText("")
end


local Question9Button5 = vgui.Create( "DButton", Question9)
Question9Button5:SetParent( Question9 ) 
Question9Button5:SetText( "Play" )
Question9Button5:SetPos( 110, 110 )
Question9Button5:SetSize( 120, 20 )
Question9Button5.DoClick = function( ply )

	local allowed = {'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
	'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l',
	'z', 'x', 'c', 'v', 'b', 'n', 'm', ' '}

	if DermaTextBox:GetValue() == "" or DermaTextBox2:GetValue() == "" or DermaTextBox:GetValue() == "First Name" or DermaTextBox2:GetValue() == "Last Name" then
	
	else
		local enteredname = DermaTextBox:GetValue() .. DermaTextBox2:GetValue()
		for k in string.gmatch(enteredname, ".") do
			if not table.HasValue(allowed, string.lower(k)) then
				Question9Label2:SetVisible( true )
			else
				LocalPlayer():ConCommand("FinishedQuiz")
				LocalPlayer():ConCommand("say /rpname " .. DermaTextBox:GetValue() .. " " .. DermaTextBox2:GetValue() )    // Send a message including the value of the b
				Question9:SetVisible( false )
			end	
		end	
	end
end




local Question9Label1 = vgui.Create("DLabel", Question9)
Question9Label1:SetText("Please name your character to begin playing.")
Question9Label1:SizeToContents() // make the control the same size as the text.
Question9Label1:SetPos( 15, 30 )

Question9Label2 = vgui.Create("DLabel", Question9)
Question9Label2:SetText("Name contains invalid characters")
Question9Label2:SizeToContents() // make the control the same size as the text.
Question9Label2:SetPos( 95, 50 )
Question9Label2:SetTextColor( Color(255, 0, 0, 255) )
Question9Label2:SetVisible( false )
end
concommand.Add( "Question9", Question9 )


function DrawSpawnIcon()
CharacterIcon = vgui.Create( "SpawnIcon") -- SpawnIcon
CharacterIcon:SetPos( 35, ScrH() - 127 )
CharacterIcon:SetModel( LocalPlayer():GetModel() ) 
CharacterIcon:RebuildSpawnIcon() 
end
concommand.Add("DrawPlayerIcon", DrawSpawnIcon)

function RemoveSpawnIcon()
CharacterIcon:SetVisible(false)
end
concommand.Add("RemoveSpawnIcon", RemoveSpawnIcon)

function RedrawIcon()
	if LocalPlayer():GetModel() ~= currentmodel then
			RunConsoleCommand("RemoveSpawnIcon")
			RunConsoleCommand("DrawPlayerIcon")
		    currentmodel = LocalPlayer():GetModel()
	end		
end
concommand.Add("Redraw", RedrawIcon)
hook.Add("Think", "Redraw", RedrawIcon)
