GM.Version = "0.1"
GM.Name = "Black Mesa Roleplay"
GM.Author = "By Aerolite.ovh"

toggleooc = 1
vipchat = 1 
botkickervar = true

-- RP Name Overrides
local meta = FindMetaTable("Player")
meta.SteamName = meta.SteamName or meta.Name
function meta:Name()
	return GAMEMODE.Config.allowrpnames and self.DarkRPVars and self:getDarkRPVar("rpname")
		or self:SteamName()
end
meta.Nick = meta.Name
meta.GetName = meta.Name
-- End

DeriveGamemode("sandbox")

util.AddNetworkString("DarkRP_InitializeVars")
util.AddNetworkString("DarkRP_DoorData")
util.AddNetworkString("DarkRP_keypadData")
AddCSLuaFile("sh_interfaceloader.lua")

-- Falco's prop protection
local BlockedModelsExist = sql.QueryValue("SELECT COUNT(*) FROM FPP_BLOCKEDMODELS1;") ~= false
if not BlockedModelsExist then
	sql.Query("CREATE TABLE IF NOT EXISTS FPP_BLOCKEDMODELS1(model VARCHAR(140) NOT NULL PRIMARY KEY);")
	include("fpp/FPP_DefaultBlockedModels.lua") -- Load the default blocked models
end
AddCSLuaFile("fpp/sh_CPPI.lua")
AddCSLuaFile("fpp/sh_settings.lua")
AddCSLuaFile("fpp/client/FPP_Menu.lua")
AddCSLuaFile("fpp/client/FPP_HUD.lua")
AddCSLuaFile("fpp/client/FPP_Buddies.lua")
AddCSLuaFile("shared/fadmin_darkrp.lua")

include("fpp/sh_settings.lua")
include("fpp/sh_CPPI.lua")
include("fpp/server/FPP_Settings.lua")
include("fpp/server/FPP_Core.lua")
include("fpp/server/FPP_Antispam.lua")

AddCSLuaFile("addentities.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("ammotypes.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("config.lua")

AddCSLuaFile("client/cl_chatlisteners.lua")
AddCSLuaFile("client/DRPDermaSkin.lua")
AddCSLuaFile("client/help.lua")
AddCSLuaFile("client/helpvgui.lua")
AddCSLuaFile("client/hud.lua")
AddCSLuaFile("client/showteamtabs.lua")
AddCSLuaFile("client/vgui.lua")
AddCSLuaFile("client/aerolite.lua")

AddCSLuaFile("shared/player_class.lua")
AddCSLuaFile("shared/animations.lua")
AddCSLuaFile("shared/commands.lua")
AddCSLuaFile("shared/entity.lua")
AddCSLuaFile("shared/MakeThings.lua")
AddCSLuaFile("shared/Workarounds.lua")
AddCSLuaFile("shared/soundfix.lua")

function AddDir(dir)
	local _, flist = file.Find(dir.."/*", "GAME")
	if flist == nil then return end
	
	for _, fdir in pairs(flist) do
		if fdir != ".svn" then 
			AddDir(dir.."/"..fdir)
		end
	end
	
	for k,v in pairs(file.Find(dir.."/*", "GAME")) do
		resource.AddFile(dir.."/"..v)
	end
end

-- Earthquake Mod addon
resource.AddFile("sound/earthquake.mp3")
resource.AddFile("sound/death03.ogg")
resource.AddFile("sound/Eat.mp3")
resource.AddFile("sound/Drink.mp3")
resource.AddFile("sound/usemed.wav")
resource.AddFile("sound/usepills.wav")

util.PrecacheSound("sound/Drink.mp3")
util.PrecacheSound("sound/Eat.mp3")
util.PrecacheSound("sound/usemed.wav")
util.PrecacheSound("sound/usepills.wav")
util.PrecacheSound("earthquake.mp3")
util.PrecacheSound("sound/death03.ogg")

resource.AddFile("materials/aerolite/aerolite.png")
resource.AddFile("materials/gui/silkicons/heart.vmt")
resource.AddFile("materials/gui/silkicons/heart.vtf")
resource.AddFile("materials/gui/silkicons/group.vmt")
resource.AddFile("materials/gui/silkicons/group.vtf")
resource.AddFile("materials/gui/silkicons/money.vmt")
resource.AddFile("materials/gui/silkicons/money.vtf")
resource.AddFile("materials/gui/silkicons/shield.vmt")
resource.AddFile("materials/gui/silkicons/shield.vtf")
resource.AddFile("materials/gui/silkicons/money_add.vmt")
resource.AddFile("materials/gui/silkicons/money_add.vtf")
resource.AddFile("materials/gui/silkicons/user.vmt")
resource.AddFile("materials/gui/silkicons/user.vtf")
resource.AddFile("materials/aerolite/burgericon.vmt")
resource.AddFile("materials/aerolite/burgericon.vtf")
resource.AddFile("materials/aerolite/strawberryicon.vmt")
resource.AddFile("materials/aerolite/strawberryicon.vtf")

resource.AddFile("materials/models/aperturehz/aphaztechs/Mask.vmt")

-- War Z
resource.AddFile("models/warz/consumables/medicine.mdl")
resource.AddFile("models/warz/consumables/painkillers.mdl")
resource.AddFile("models/warz/consumables/bag_mre.mdl")
resource.AddFile("models/warz/items/bandage.mdl")
resource.AddFile("models/warz/items/medkit.mdl")
resource.AddFile("materials/models/warz/consumables/consumables_01.vmt")
resource.AddFile("materials/models/warz/consumables/consumables_02.vmt")
resource.AddFile("materials/models/warz/consumables/consumables_01_norm.vtf")
resource.AddFile("materials/models/warz/consumables/consumables_02_norm.vtf")
resource.AddFile("materials/models/warz/items/bandage1.vmt")
resource.AddFile("materials/models/warz/items/bandage2.vmt")
resource.AddFile("materials/models/warz/items/medkit.vmt")
resource.AddFile("materials/models/warz/items/medkit_norm.vtf")
resource.AddFile("materials/models/warz/items/bandage_norm.vtf")

-- Texture Fix
resource.AddFile("materials/environment maps/envmap001a.vmt")


-- Models
-- BMRP Lab Equipment
resource.AddFile( "models/player/aphaztechs.mdl" )
resource.AddFile( "models/player/aphaztechs.vvd" )
resource.AddFile( "models/player/ApHazTechs.phy" )
resource.AddFile( "models/player/ApHazTechs.sw.vtx" )
resource.AddFile( "models/player/ApHazTechs.dx90.vtx" )
resource.AddFile( "models/player/ApHazTechs.dx80.vtx" )
resource.AddFile( "models/player/shephard.mdl" )    
resource.AddFile( "materials/DarkRP/bmrp1.png" )    
resource.AddFile( "settings/spawnlist/lab.txt" )
resource.AddFile( "settings/spawnlist/031-black mesa roleplay.txt" )
resource.AddFile( "materials/models/player/PLAYER_Chrome1.vmt" )

-- Barney and Scientist Sounds Work
resource.AddFile( "sound/scientist/simulation.wav" )    
resource.AddFile( "sound/scientist/nogrant.wav" )    
resource.AddFile( "sound/scientist/cough.wav" )
resource.AddFile( "sound/scientist/seencup.wav" )
resource.AddFile( "sound/scientist/lambdalab.wav" )
resource.AddFile( "sound/scientist/hideglasses.wav" )
resource.AddFile( "sound/scientist/bloodsample.wav" )
resource.AddFile( "sound/scientist/hello.wav" )
resource.AddFile( "sound/scientist/beverage.wav" )
resource.AddFile( "sound/scientist/areyouthink.wav" )
resource.AddFile( "sound/scientist/weartie.wav" )
resource.AddFile( "sound/scientist/whatyoudoing.wav" )
resource.AddFile( "sound/scientist/yes.wav" )
resource.AddFile( "sound/scientist/yes2.wav" )
resource.AddFile( "sound/scientist/yes3.wav" )
resource.AddFile( "sound/scientist/yees.wav" )
resource.AddFile( "sound/scientist/greetings.wav" )
resource.AddFile( "sound/scientist/donuteater.wav" )
resource.AddFile( "sound/scientist/thatsodd.wav" )
resource.AddFile( "sound/scientist/shutdownchart.wav" )
resource.AddFile( "sound/scientist/runtest.wav" )
resource.AddFile( "sound/scientist/scream07.wav" )
resource.AddFile( "sound/scientist/noo.wav" )
resource.AddFile( "sound/scientist/nooo.wav" )
resource.AddFile( "sound/scientist/reportflux.wav" )
resource.AddFile( "sound/scientist/perhaps.wav" )
resource.AddFile( "sound/scientist/newhevsuit.wav" )
resource.AddFile( "sound/scientist/neverseen.wav" )
resource.AddFile( "sound/scientist/c1a0_sci_stall.wav" )
resource.AddFile( "sound/scientist/sneeze.wav" )
resource.AddFile( "sound/scientist/letsgo.wav" )
resource.AddFile( "sound/scientist/sci_pain9.wav" )
resource.AddFile( "sound/scientist/istay.wav" )
resource.AddFile( "sound/barney/badfeeling.wav" )
resource.AddFile( "sound/barney/bigmess.wav" )
resource.AddFile( "sound/barney/c1a0_ba_hevyes.wav" )
resource.AddFile( "sound/barney/dontaskme.wav" )
resource.AddFile( "sound/barney/nosir.wav" )
resource.AddFile( "sound/barney/targetpractice.wav" )
resource.AddFile( "sound/barney/yessir.wav" )
resource.AddFile( "sound/barney/standguard.wav" )
resource.AddFile( "sound/barney/howyoudoing.wav" )
resource.AddFile( "sound/barney/yup.wav" )
resource.AddFile( "sound/barney/youhearthat.wav" )
resource.AddFile( "sound/barney/yougotit.wav" )
resource.AddFile( "sound/barney/youeverseen.wav" )
resource.AddFile( "sound/barney/youbet.wav" )
resource.AddFile( "sound/barney/workingonstuff.wav" )
resource.AddFile( "sound/barney/whatsgoingon.wav" )
resource.AddFile( "sound/barney/whatisthat.wav" )
resource.AddFile( "sound/barney/whatgood.wav" )
resource.AddFile( "sound/barney/wayout.wav" )
resource.AddFile( "sound/barney/waitin.wav" )
resource.AddFile( "sound/barney/thinking.wav" )
resource.AddFile( "sound/barney/teamup2.wav" )
resource.AddFile( "sound/barney/survive.wav" )
resource.AddFile( "sound/barney/stophere.wav" )
resource.AddFile( "sound/barney/youtalkmuch.wav" )
resource.AddFile( "sound/barney/imdead.wav" )
resource.AddFile( "sound/barney/aintscared.wav" )
resource.AddFile( "sound/barney/c1a2_ba_top.wav" )

resource.AddFile( "sound/scientist/sci_somewhere.wav" )
resource.AddFile( "sound/scientist/limitsok.wav" )

resource.AddFile( "materials/models/props_unique/atm.vmt" )
resource.AddFile( "materials/models/props_unique/atm.vtf" )
resource.AddFile( "materials/models/props_unique/atm_ref.vtf" )
resource.AddFile( "models/props_unique/atm01.mdl" )

resource.AddWorkshop( "104479034" )
resource.AddWorkshop( "312325100" )
resource.AddWorkshop( "319441975" )
resource.AddWorkshop( "173482196" )
resource.AddWorkshop( "105841291" )

-- hgrunt
resource.AddFile( "materials/models/hgrunt/goggle_chrome.vmt" )
resource.AddFile( "materials/models/hgrunt/goggle_chrome_normal.vtf" )
resource.AddFile( "materials/models/hgrunt/mask_chrome.vmt" )
resource.AddFile( "materials/models/hgrunt/pc_soldier_armor_normal.vtf" )
resource.AddFile( "materials/models/hgrunt/mask_chrome_mask.vtf" )
resource.AddFile( "materials/models/hgrunt/mask_chrome_normal.vtf" )
resource.AddFile( "materials/models/hgrunt/pc_soldier_armor.vmt" )
resource.AddFile( "materials/models/hgrunt/pc_soldier_bags.vmt" )
resource.AddFile( "materials/models/hgrunt/pc_soldier_bags_normal.vtf" )
resource.AddFile( "materials/models/hgrunt/pc_soldier_boot.vmt" )
resource.AddFile( "materials/models/hgrunt/pc_soldier_boot_normal.vtf" )
resource.AddFile( "materials/models/hgrunt/pc_soldier_fatigues.vmt" )
resource.AddFile( "materials/models/hgrunt/pc_soldier_fatigues_normal.vtf" )
resource.AddFile( "materials/models/hgrunt/pc_soldier_helmet.vmt" )
resource.AddFile( "materials/models/hgrunt/pc_soldier_helmet_normal.vtf" )
resource.AddFile( "materials/models/hgrunt/pc_soldier_mask.vmt" )
resource.AddFile( "materials/models/hgrunt/pc_soldier_mask_face.vmt" )
resource.AddFile( "materials/models/hgrunt/pc_soldier_mask_face_normal.vtf" )
resource.AddFile( "materials/models/hgrunt/pc_soldier_mask_normal.vtf" )
resource.AddFile( "materials/models/hgrunt/pc_soldier_skin_wht.vmt" )
resource.AddFile( "materials/models/hgrunt/pc_soldier_skin_wht_normal.vtf" )
resource.AddFile( "materials/models/hgrunt/soldier_helmet.vmt" )
resource.AddFile( "materials/models/hgrunt/soldier_helmet_normal.vtf" )

-- Add Dirs
AddDir("materials/gui/silkicons")
AddDir("models/labware")
AddDir("materials/models/aperturehz/aphaztechs")
AddDir("materials/models/labware")
AddDir("materials/models/labware")
AddDir("sound/opforce_grunt")
--AddDir("materials/models/cs_friend/humans/urban_male")
--AddDir("models/player/group04")
-- HEV
AddDir("models/player/sgg")
AddDir("materials/models/sgg/hev")

-- Player Models http://www.garrysmod.org/downloads/?a=view&id=63682
--AddDir("materials/models/hgrunt")
--AddDir("materials/models/barney")
AddDir("materials/blackmesaglas/glasses-1")
AddDir("materials/models/blackmesa/humans/urban_male")
AddDir("materials/models/gal")
AddDir("materials/models/gordon1")
AddDir("materials/models/hl1magnus")
AddDir("materials/models/humans/bmscience")
AddDir("materials/models/humans/male/blkmesa")
AddDir("materials/models/humans/male/group_hl1")
AddDir("materials/models/humans/male/urban03")
AddDir("materials/models/science")
AddDir("models/player/hdpp")
AddDir("materials/models/bm_security")
AddDir("models/security")
AddDir("models/player/hdpp/security")
AddDir("materials/jessev92/player/common")
AddDir("materials/jessev92/player/l4d/m9hunter")
AddDir("models/jessev92/player/l4d")


DB = DB or {}
GM.Config = GM.Config or {}
GM.NoLicense = GM.NoLicense or {}

-- sv_alltalk must be 0
-- Note, everyone will STILL hear everyone UNLESS rp_voiceradius is 1!!!
-- This will fix the rp_voiceradius not working
game.ConsoleCommand("sv_alltalk 0\n")

include("_MySQL.lua")
include("config.lua")
include("licenseweapons.lua")

include("sh_interfaceloader.lua")

include("server/chat.lua")
include("server/admincc.lua")

include("shared/player_class.lua")
include("shared/animations.lua")
include("shared/commands.lua")
include("shared/entity.lua")

include("shared/MakeThings.lua")
include("shared/Workarounds.lua")

include("shared.lua")
include("addentities.lua")
include("ammotypes.lua")

include("server/database.lua")
MySQLite.initialize()
include("server/data.lua")
include("server/gamemode_functions.lua")
include("server/main.lua")
include("server/player.lua")
include("server/questions.lua")
include("server/util.lua")
include("server/votes.lua")
include("server/atmspawn.lua")
include("server/bmschedule.lua")

include("shared/fadmin_darkrp.lua")

/*---------------------------------------------------------------------------
Loading modules
---------------------------------------------------------------------------*/
local fol = GM.FolderName.."/gamemode/modules/"
local files, folders = file.Find(fol .. "*", "LUA")
for k,v in pairs(files) do
	if GM.Config.DisabledModules[k] then continue end

	include(fol .. v)
end

for _, folder in SortedPairs(folders, true) do
	if folder ~= "." and folder ~= ".." and not GM.Config.DisabledModules[folder] then
		for _, File in SortedPairs(file.Find(fol .. folder .."/sh_*.lua", "LUA"), true) do
			if File == "sh_interface.lua" then continue end

			AddCSLuaFile(fol..folder .. "/" ..File)
			include(fol.. folder .. "/" ..File)
		end

		for _, File in SortedPairs(file.Find(fol .. folder .."/sv_*.lua", "LUA"), true) do
			if File == "sv_interface.lua" then continue end
			include(fol.. folder .. "/" ..File)
		end

		for _, File in SortedPairs(file.Find(fol .. folder .."/cl_*.lua", "LUA"), true) do
			if File == "cl_interface.lua" then continue end
			AddCSLuaFile(fol.. folder .. "/" ..File)
		end
	end
end

DarkRP.finish()

local function GetAvailableVehicles(ply)
	if IsValid(ply) and not ply:IsAdmin() then return end
	ServerLog("Available vehicles for custom vehicles:" .. "\n")
	print("Available vehicles for custom vehicles:")
	for k,v in pairs(DarkRP.getAvailableVehicles()) do
		ServerLog("\""..k.."\"" .. "\n")
		print("\""..k.."\"")
	end
end
concommand.Add("rp_getvehicles_sv", GetAvailableVehicles)

/*---------------------------------------------------------------------------
DarkRP blocked entities
---------------------------------------------------------------------------*/
local blockTypes = {"Physgun1", "Spawning1", "Toolgun1"}
FPP.AddDefaultBlocked(blockTypes, "chatindicator")
FPP.AddDefaultBlocked(blockTypes, "darkrp_cheque")
FPP.AddDefaultBlocked(blockTypes, "darkp_console")
FPP.AddDefaultBlocked(blockTypes, "drug")
FPP.AddDefaultBlocked(blockTypes, "drug_lab")
FPP.AddDefaultBlocked(blockTypes, "fadmin_jail")
FPP.AddDefaultBlocked(blockTypes, "food")
FPP.AddDefaultBlocked(blockTypes, "gunlab")
FPP.AddDefaultBlocked(blockTypes, "letter")
FPP.AddDefaultBlocked(blockTypes, "meteor")
FPP.AddDefaultBlocked(blockTypes, "spawned_food")
FPP.AddDefaultBlocked(blockTypes, "spawned_money")
FPP.AddDefaultBlocked(blockTypes, "spawned_shipment")
FPP.AddDefaultBlocked(blockTypes, "spawned_weapon")
FPP.AddDefaultBlocked("Spawning1", "darkrp_laws")


function OverrideDeathSound()
	return true
end
hook.Add("PlayerDeathSound", "OverrideDeathSound", OverrideDeathSound)

function PlayerDeath(ply, weapon, killer)

	ply:SendLua("surface.PlaySound('death03.ogg')")
	ply:SendLua("local killer = killedby")
	if killer:IsPlayer() then
	killedby = killer:Nick()
	end
	
	if not killer:IsPlayer() or killer == ply then
	killedby = tostring(killer)
		
		if string.find(string.lower(killedby), "trigger_hurt") then
			killedby = "the world"
		end
		
		if string.find(string.lower(killedby), "worldspawn") then
			killedby = "the world"
		end
		
		if string.find(string.lower(killedby), "npc") then
			killedby = "an NPC"
		end
		
		if string.find(string.lower(killedby), "vehicle") then
			killedby = "a vehicle"
		end
		
		if string.find(string.lower(killedby), "explosion") then
			killedby = "an explosion"
		end
		
	end
	
	
	if killer == ply then
	killedby = "yourself"
	end

	umsg.Start( "KilledBy", ply )
    	umsg.String( killedby )
	umsg.End()
	
	ply:ConCommand( "SpawnTimer" )

end
hook.Add("PlayerDeath", "Player Dies", PlayerDeath)

function SendSTime()

	local shour = tonumber(os.date("%H"));
	local sminute = tonumber(os.date("%M"));
	
	if sminute < 10 then sminute = "0" .. sminute end
	if shour < 10 then shour = "0" .. shour end
	stime = shour .. ":" .. sminute
	
	
	umsg.Start( "STime", ply )
    umsg.String( stime )
	umsg.End()
	
end	
timer.Create( "Send Server Time", 10, 0, SendSTime)

function XenDie()
	local entities = ents.FindInBox( Vector(-3951.572998, -11466.885742, 347.655273), Vector(-5822.107422, -5733.926758, -965.334229) );
	for k, v in pairs(entities) do
		if ( IsValid(v) and v:IsPlayer() and v:Alive() and v:GetPData("suitedup") ~= "1" and v:GetPData("disguised") ~= "0" and v.pk_pill_ent == nil ) then
			if ( (v.nextXenDamage or 0) < CurTime() ) then
				v:TakeDamage(50);
				v:EmitSound("player/pl_drown1.wav", 80, 100)
				v.nextXenDamage = CurTime() + 1;
			end;
		end;
	end;
end;
timer.Create( "XenDieTimer", 0.1, 0, XenDie)

function PlayerHit( ent,dmginfo)
    if ent:IsPlayer() and dmginfo:GetDamageType() == DMG_CRUSH then
		if dmginfo:GetInflictor():GetName() ~= "eledoorstop" and dmginfo:GetInflictor():GetName() ~= "eledoors24" and dmginfo:GetInflictor():GetName() ~= "eledoorsbottom" then
			dmginfo:ScaleDamage( 0.0 )
		else
			dmginfo:ScaleDamage( 1.0 )
		end	
	end
	if ent:IsPlayer() and dmginfo:IsBulletDamage() then
		dmginfo:ScaleDamage( 2.0 )
	end
end
hook.Add( "EntityTakeDamage", "PlayerHit", PlayerHit )

function HungerZero( ply )
	if ply:IsAdmin() then
		ply:SetSelfDarkRPVar("Energy", 0 )
	end
end
concommand.Add("HungerZero", HungerZero)

function SetHunger(ply, cmd, args) --SetHunder <PlayerName> <amount>
	if not ply:HasPriv("rp_commands") then
		return false
	end
	if not tonumber(args[2]) then ply:PrintMessage(HUD_PRINTCONSOLE, "Invalid arguments") return end
	local amount = math.floor(tonumber(args[2]))
	local targets = FAdmin.FindPlayer(args[1])
	if not targets or #targets == 1 and not IsValid(targets[1]) then
		FAdmin.Messages.SendMessage(ply, 1, "Player not found")
		return
	else
		targets[1]:SetDarkRPVar("Energy", amount )
		FAdmin.Messages.SendMessage(ply, 1, "Set Hunger Successful")
		DB.Log(ply:SteamName().." ("..ply:SteamID()..") set " .. targets[1]:GetName() .."'s ("..targets[1]:SteamID()..") Hunger to " .. args[2] .. "%", nil, Color(30, 30, 30))
	end
end
concommand.Add("rp_sethunger", SetHunger)
AddChatCommand("/sethunger", SetHunger)

function SetXP(ply, cmd, args) --SetXP <PlayerName> <amount>
	if not ply:HasPriv("rp_commands") then
		return false
	end
	if not tonumber(args[2]) then ply:PrintMessage(HUD_PRINTCONSOLE, "Invalid arguments") return end
	local amount = math.floor(tonumber(args[2]))
	local targets = FAdmin.FindPlayer(args[1])
	if not targets or #targets == 1 and not IsValid(targets[1]) then
		FAdmin.Messages.SendMessage(ply, 1, "Player not found")
		return
	else
		targets[1]:SetDarkRPVar("xp", amount )
		FAdmin.Messages.SendMessage(ply, 1, "Set XP Successful")
		NewXP = targets[1]:getDarkRPVar("xp")
		DB.StoreXP(targets[1], NewXP)
		DB.Log(ply:SteamName().." ("..ply:SteamID()..") set " .. targets[1]:GetName() .."'s ("..targets[1]:SteamID()..") XP to " .. args[2], nil, Color(30, 30, 30))
	end
end
concommand.Add("rp_setxp", SetXP)

function AddXP(ply, cmd, args) --AddXP <PlayerName> <amount>
	if not ply:HasPriv("rp_commands") then
		return false
	end
	if not tonumber(args[2]) then ply:PrintMessage(HUD_PRINTCONSOLE, "Invalid arguments") return end
	local targets = FAdmin.FindPlayer(args[1])
	if not targets or #targets == 1 and not IsValid(targets[1]) then
		FAdmin.Messages.SendMessage(ply, 1, "Player not found")
		return
	else
		local amount = math.floor(tonumber(args[2])) + targets[1]:getDarkRPVar("xp")
		targets[1]:SetDarkRPVar("xp", amount )
		FAdmin.Messages.SendMessage(ply, 1, "Set XP Successful")
		NewXP = targets[1]:getDarkRPVar("xp")
		DB.StoreXP(targets[1], NewXP)
		DB.Log(ply:SteamName().." ("..ply:SteamID()..") gave " .. targets[1]:GetName() .." ("..targets[1]:SteamID()..") " .. args[2] .. "XP", nil, Color(30, 30, 30))
	end
end
concommand.Add("rp_addxp", AddXP)

function SeeXP(ply, cmd, args) --SeeXP <PlayerName> <amount>
	if not ply:HasPriv("rp_commands") then
		return false
	end

	local targets = FAdmin.FindPlayer(args[1])
	if not targets or #targets == 1 and not IsValid(targets[1]) then
		FAdmin.Messages.SendMessage(ply, 1, "Player not found")
		return
	else
		local value = targets[1]:getDarkRPVar("xp")
		FAdmin.Messages.SendMessage(ply, 1, value)
	end
end
concommand.Add("rp_seexp", SeeXP)
AddChatCommand("/seexp", SeeXP)

function LockOutReset( ply )
	if ply:IsAdmin() then
		ply:SetPData("atmlockout", 0 )
	end
end
concommand.Add("LockOutReset", LockOutReset)

function HungerFull( ply )
	if ply:IsAdmin() then
		ply:SetSelfDarkRPVar("Energy", 100 )
		DB.Log(ply:SteamName().." ("..ply:SteamID()..") restored their hunger", nil, Color(30, 30, 30))
	end
end
concommand.Add("HungerFull", HungerFull)

function FinishedQuiz( ply )
	ply:SetPData("FinishedQuiz", "1" )	
end
concommand.Add("FinishedQuiz", FinishedQuiz)

function GetPoints( ply )
	if ply:IsAdmin() then
		ply:SetSelfDarkRPVar("xp", 50)
		XP = ply:getDarkRPVar("xp")
		DB.StoreXP(ply, XP)
	end
end
concommand.Add("GetPoints", GetPoints)

-- Filtered Words

FilteredWords={} 
FilteredWords[1]="dickhead"
FilteredWords[2]="fuck"
FilteredWords[3]="cunt"
FilteredWords[4]="nigger"
FilteredWords[4]="nigga"
FilteredWords[4]="fag"
FilteredWords[5]="dick"
FilteredWords[6]="arse"
FilteredWords[7]="retard"
FilteredWords[8]="bitch"
FilteredWords[9]="faggot"
FilteredWords[10]="wanker"
FilteredWords[11]="slag"
FilteredWords[12]="bastard"
FilteredWords[13]="wankstain"
FilteredWords[14]="arsehole"
FilteredWords[15]="blowjob"

-- Reserved Slot Users Load

timer.Create( "LoadVIP", 60, 0, function()
			
	UserGroups = {}
	if UserGroups ~= nil then table.Empty(UserGroups) end
	
	MySQLite.query([[SELECT steamid FROM FAdmin_PlayerGroup WHERE groupname = 'vip' OR groupname ='moderator' OR groupname = 'admin' OR groupname = 'superadmin';]], function(data)
	
	for k,v in pairs(data) do
		for k,v in pairs(v) do
			table.insert(UserGroups,v)
		end
	end

	print("Reserved Slots Loaded")
	
	return UserGroups
	
	end)
	
end)

-- Reserved Slots & Ban Message System

local CustomBanMessage = [[It appears you received a ban!
		
		Administrator: {AdminName} ({AdminSteamID})
		Reason: {Reason}
		Length: {Length}

		You can create an Unban Request at our forums!
		(http://aerolite.ovh/forums/)
]]

hook.Add( "CheckPassword", "CheckPass", function(SteamID, ipAddress, svPassword, clPassword, name)
	if (svPassword != "" and svPassword != clPassword) then return false end

	local maxnumber = tonumber(GetConVarString("sv_visiblemaxplayers"))
	local amountofplayers = table.Count(player.GetAll())

	local sID = util.SteamIDFrom64(SteamID)

	if (type(SourceBans.BANS) != "table") then return false, "SourceBan Database has not been loaded yet. Reconnect in a few seconds please." end
	
	local banned = nil
	for k, v in pairs(SourceBans.BANS) do
		if (v.steamid == sID) then
			if (v.timestamp > os.time() or v.length == 0) then
				banned = k 
			else
				game.ConsoleCommand("removeid ".. SteamID .. "\n")
				hook.Call("SourceBans_UnBan", nil, k, nil, true)
			end
		end
	end

	if banned != nil then 
		local CustomBanMessage = string.gsub(CustomBanMessage, "{AdminName}",SourceBans.BANS[banned].adminname or "Unknown")
		CustomBanMessage = string.gsub(CustomBanMessage, "{AdminSteamID}", SourceBans.BANS[banned].adminsteam or "Unknown")
		CustomBanMessage = string.gsub(CustomBanMessage, "{Reason}", SourceBans.BANS[banned].reason or "")
		if SourceBans.BANS[banned].length == 0 then
			CustomBanMessage = string.gsub(CustomBanMessage, "{Length}", "Permanent")
		else
			CustomBanMessage = string.gsub(CustomBanMessage, "{Length}", SourceBans.BANS[banned].length / 60  .. " Minutes" or "ERROR")
		end

		return false, CustomBanMessage
	end


	if string.lower(clPassword) == "hidden" then
		util.SetPData(util.SteamIDFrom64(SteamID), "hiddenJoin", true)
		print(name.." ("..util.SteamIDFrom64(SteamID)..")".." joined in the hidden mode!")
	else
		util.SetPData(util.SteamIDFrom64(SteamID), "hiddenJoin", false)
	end

	if amountofplayers >= maxnumber then
		if UserGroups ~= nil then
			if table.HasValue(UserGroups, util.SteamIDFrom64(SteamID)) then
				print(util.SteamIDFrom64(SteamID) .. " just used a reserved slot")
			else
				print(util.SteamIDFrom64(SteamID) .. " does not appear to be in the slots table")
				return false, "This slot is reserved for VIP users."
			end
		else
			print("Reserved list is currently blank. Has it been 60 seconds since the server started?")
		end	
	else
		print("Server isn't at max. Allowing in.")
	end
	return true
end)

local function CheckHiddenJoin(ply)
	if util.GetPData(ply:SteamID(), "hiddenJoin", false) then
		timer.Simple(1, function() 
			if FAdmin.Access.PlayerHasPrivilege(ply, "HideFromScoreboard") then ply:FAdmin_SetGlobal("FAdmin_hidescoreboard", true) end
		end)
		util.SetPData(ply:SteamID(), "hiddenJoin", false)
	end
end
hook.Add("PlayerInitialSpawn", "PlayerHiddenJoinCheck", CheckHiddenJoin)

-- Donate & Website Chat Command

local function DonateCommand( ply, text)
	if (text == "/donate") then 
		ply:SendLua([[gui.OpenURL("http://www.aerolite.ovh/donate/")]])
	end

	if (text == "/vip") then 
		ply:SendLua([[gui.OpenURL("http://www.aerolite.ovh/vip")]])
	end

	if (text == "/website") then 
		ply:SendLua([[gui.OpenURL("http://www.aerolite.ovh")]])
	end
end
hook.Add( "PlayerSay", "Donate Page Command", DonateCommand )
AddChatCommand("/donate", DonateCommand)
AddChatCommand("/vip", DonateCommand)
AddChatCommand("/website", DonateCommand)

-- Blacklisted Prop Fix

function BlackListSpawnedProp(ply, model, ent)
	if string.match(model, ".+%/../") and IsValid(ent) then
		ent:Remove()
		ply:PrintMessage( HUD_PRINTTALK, '[FPP] Prop is on the blacklist or uses wrong slash direction' )
	end
end
hook.Add("PlayerSpawnedProp", "playerSpawnedProp", BlackListSpawnedProp)

-- VIP Tool Restrictions

function VIPtools(ply, _, toolmode)
	DB.Log(ply:Name().." ("..ply:SteamName()..")" .." ("..ply:SteamID()..") used the " .. toolmode .. " tool", nil, Color(255, 255, 255))
	if toolmode == "wire_expression2" or toolmode == "wire_gpu" or toolmode == "wire_spu" or toolmode== "wire_user" or toolmode=="wire_textreceiver" or toolmode=="starfall_screen" or toolmode=="starfall_processor" then
		if ply:IsAdmin() or ply:IsUserGroup("vip") or ply:IsUserGroup("trusted") then 
			return true 
		else
			ply:ChatPrint(toolmode .." is restricted for VIP users only.")
			return false
		end
	end
end
 
hook.Add("CanTool", "VIPtools", VIPtools)