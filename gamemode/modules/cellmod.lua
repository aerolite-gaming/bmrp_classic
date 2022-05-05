/*                                      | * FILE: CellMod.lua
                  ______                |
                  |    |                | * AUTHOR: Blt950
                  |    |                | * AUTHOR WEBSIDE: http://blt950.com
                  |    |                |
        ________________                | * PRODUCT LICENSED: http://creativecommons.org/licenses/by-nd/3.0/
        |  __________  |                | By using this product, you agree to follow the license limitations.
        | |  CellMod | |                | Got any questions, contact author.
        | |   v1.2   | |                |
        | |          | |                | * FACEPUNCH THREAD: http://www.facepunch.com/threads/1131388
        | |__________| |                |
        |              |                |
        |  1   2   3   |                |
        |  4   5   6   |                |
        |  7   8   9   |                |
        |  *   0   #   |                |
        ________________                |
                                    	|
										|
________________________________________|____________________________________________________________________________________
*/

local CM = { }

if CLIENT then include("cellmod/cl_init.lua") end
include("cellmod/shared.lua")
AddCSLuaFile( "cellmod/shared.lua" )
AddCSLuaFile( "cellmod/cl_init.lua" )


/* -------------------------------------------- */
/* -------------------------------------------------- */
/* -------------------- INCLUDES -------------------- */
/* -------------------------------------------------- */
/* -------------------------------------------- */

local function AddDir(dir) // recursively adds everything in a directory to be downloaded by client
	local List, ListFolders = file.Find(dir.."/*", "GAME")

	for _, fdir in pairs(ListFolders) do
		if fdir != ".svn" then // don't spam people with useless .svn folders
			AddDir(dir.."/"..fdir)
		end
	end
 
	for k,v in pairs(List) do
		resource.AddFile(dir.."/"..v)
	end
end
AddDir("materials/gui/cellmod")


resource.AddFile("sound/cellmod/cell_ringtone.wav")
util.PrecacheSound("cellmod/cell_ringtone.wav")
resource.AddFile("sound/cellmod/text_message.wav")
util.PrecacheSound("cellmod/text_message.wav")
resource.AddFile("sound/cellmod/dialring.wav")
util.PrecacheSound("cellmod/dialring.wav")

/* -------------------------------------------- */
/* -------------------------------------------------- */
/* -------- INITIAL STUFF and GM FUNCTIONS ---------- */
/* -------------------------------------------------- */
/* -------------------------------------------- */

hook.Add("PlayerInitialSpawn", "CM.PlayerInitialSpawn", function (ply)
	ply.CellVars = {}
	
	ply.CellVars["company"] = nil
	ply.CellVars["acceptsim"] = nil
	ply.CellVars["config"] = false
	ply.CellVars["caller"] = nil
	ply.CellVars["operator"] = "nil"
	ply.CellVars["imcalling"] = 0
	ply.CellVars["minutes"] = 0
	
	ply:SetOperator("nil")
	ply:SetSelfDarkRPVar("CMsignal", 0)
	ply:SetNWInt("cm_called", 0) -- Made this NW since DarkRPvars and usermessages didnt like this, and just made everything harder.

end)

hook.Add("PlayerSpawn", "CM.PlayerSpawn", function(ply)
	ply:SetNWInt("cm_called", 0)
	ply.CellVars["caller"] = nil
end)

hook.Add("PlayerDeath", "CM.PlayerDeath", function(ply, weapon, killer)

	if ply:GetNWInt("cm_called") > 0 then
	
		local caller = ply.CellVars["caller"]
		
		SendColoredText(ply, Color(255,100,0), "Your conversation terminated because of your death.")
		SendColoredText(caller, Color(255,100,0), ply:Nick().." gets very silent on the other end. (Died)")
		
		caller.CellVars["inconvo"] = false
		ply.CellVars["inconvo"] = false
		caller:SetNWInt("cm_called", 0)
		ply:SetNWInt("cm_called", 0)
		caller.CellVars["caller"] = nil
		ply.CellVars["caller"] = nil
		ply.CellVars["minutes"] = 0
		ply.CellVars["imcalling"] = 0
	end
end)

function CM.ChangedTeam() -- Somehow the default detect team functions didnt want to co-operate :( So I made this crappy workaround.
	for k,user in pairs(player.GetAll()) do
		if user:Team() == TEAM_MOPERATOR and user.CellVars["config"] == false then
			user.CellVars["config"] = true
			user:ConCommand("cm_companyconfigwindow")
		elseif user:Team() != TEAM_MOPERATOR and user.CellVars["company"] == user.CellVars["operator"] and user.CellVars["company"] != nil and user.CellVars["operator"] != "nil" then
			for k, v in pairs(player.GetAll()) do
				if v.CellVars["operator"] == user.CellVars["company"] then
					SendColoredText(v, Color(255,100,0), "_MESSAGE TO CLIENTS_")
					SendColoredText(v, Color(255,100,0), "Your cellphone operator "..user.CellVars["company"].." has been dissolved.")
					SendColoredText(v, Color(255,100,0), "Your current simcard will still work untill you change.")
				end
			end
			user:SetOperator("nil")
			user.CellVars["company"] = nil
		elseif user:Team() != TEAM_MOPERATOR then
			user.CellVars["config"] = false
		end
	end
end

/* -------------------------------------------- */
/* -------------------------------------------------- */
/* --------------------- CM.THINK ------------------- */
/* -------------------------------------------------- */
/* -------------------------------------------- */

local cm_NextTick = CurTime()
local cm_TickDelay = 3

hook.Add("Think", "CM.Think", function () -- Thanks to Kopimi, for this. To fix my loop-ception :V
	if CurTime() >= cm_NextTick then
		CM.ChangedTeam()
		CM.LostMySignal()
		CM.SignalCore()
		
		cm_NextTick = CurTime() + cm_TickDelay
	end
end)

/* -------------------------------------------- */
/* -------------------------------------------------- */
/* ----------------- USERMESSAGES ------------------- */
/* -------------------------------------------------- */
/* -------------------------------------------- */

function SendColoredText(ply, color, text)
	umsg.Start( "CM.SendColoredText", ply )
		umsg.Short( color.r )
        umsg.Short( color.g )
        umsg.Short( color.b )
        umsg.String( text )
	umsg.End()
end


local meta = FindMetaTable("Player")
function meta:SetOperator(var)
	if not IsValid(self) then return end
	umsg.Start("CM.SetOperator", self)
		umsg.String(var)
	umsg.End()
	self.CellVars["operator"] = var
end

/* -------------------------------------------- */
/* -------------------------------------------------- */
/* ------------- CALL COUNTER and RINGING ----------- */
/* -------------------------------------------------- */
/* -------------------------------------------- */

timer.Create( "CallTimer", 60, 0, function()
	for k,v in pairs(player.GetAll()) do
		if v:GetNWInt("cm_called") == 2 and v.CellVars["imcalling"] == 1 then
			v.CellVars["minutes"] = v.CellVars["minutes"] + 1
		end
	end
end)

timer.Create( "CallingSound", 4.5, 0, function ()

	for k,v in pairs(player.GetAll()) do
		if v:GetNWInt("cm_called") == 1 then
			target:EmitSound("cellmod/cell_ringtone.wav", 75, 100)
		end
	end
end)

/* -------------------------------------------- */
/* -------------------------------------------------- */
/* ----------------- CONSOLE COMMANDS --------------- */
/* -------------------------------------------------- */
/* -------------------------------------------- */
MobileOperators = { }

concommand.Add("cm_companyconfig",function(ply,command,args)
	if args[1] and args[2] and args[3] and args[4] then
		MobileOperators[args[1]] = { Cowner = args[2], Cprice = args[3], Tprice = args[4] }
	end
	ply:SetOperator(args[1])
	ply.CellVars["company"] = args[1]
end)

/* -------------------------------------------- */
/* -------------------------------------------------- */
/* ---------------- SMALL FUNCTIONS ----------------- */
/* -------------------------------------------------- */
/* -------------------------------------------- */

function MatchUserID(u1, u2)
	if u1 == u2 then
		return true
	else
		return false
	end
end

/* -------------------------------------------- */
/* -------------------------------------------------- */
/* ------------------- SIGNAL CORE ------------------- */
/* -------------------------------------------------- */
/* -------------------------------------------- */
function CM.SignalCore()
	for k,user in pairs(player.GetAll()) do
		if user.CellVars["operator"] != "nil" then
			user.CellVars["props"] = 0
			for k, v in pairs(ents.FindInSphere(user:GetPos(), 690)) do
				if v:IsValid() and v:GetClass() == "prop_physics" then
					user.CellVars["props"] = user.CellVars["props"] + 1
				end
			end
			local props = user.CellVars["props"]
			if props <= 8 then
				user:SetSelfDarkRPVar("CMsignal", 4)
			elseif props > 8 and props < 16 then
				user:SetSelfDarkRPVar("CMsignal", 3)
			elseif props >= 16 and props < 30 then
				user:SetSelfDarkRPVar("CMsignal", 2)
			elseif props >= 30 then
				user:SetSelfDarkRPVar("CMsignal", 1)
			end
			
			if string.lower(game.GetMap()) == "rp_downtown_v2" then
				for k, v in pairs(ents.FindInBox(Vector(-3063.0388, -4579.2559, -267.4008), Vector(2834.4006, 2072.6616, -1426.6747))) do
					 if v:IsValid() and v:IsPlayer() then
							v:SetSelfDarkRPVar("CMsignal", 1)
					 end
				end
				
				
				NSTable = {} 
				NSTable[1] = {Vector(-2205.0100, -3979.4731, -695.2813), Vector(-1656.8842, 407.1369, -1087.9382)} 
				NSTable[2] = {Vector(-658.0267, 1640.3733, -359.1799), Vector(436.2725, 813.8255, -532.2081)}
				NSTable[3] = {Vector(-336.8489, 138.4724, 27.5832), Vector(-600.2181, -585.2011, -391.8198)}
				NSTable[4] = {Vector(-1387.3826, -1216.0873, -592.5269), Vector(-1905.5970, -1769.2404, -759.4248)}

				
				for i,j in pairs(NSTable) do
					for k, v in pairs(ents.FindInBox(NSTable[i][1], NSTable[i][2])) do
						 if v:IsValid() and v:IsPlayer() then
								v:SetSelfDarkRPVar("CMsignal", 0)
						 end
					end
				end
			end
		else
			user:SetSelfDarkRPVar("CMsignal", 0)
		end
	end
end

function CM.LostMySignal()
	for k,user in pairs(player.GetAll()) do
		if user.CellVars["operator"] != "nil" then
			if user:GetNWInt("cm_called") > 0 and user.DarkRPVars.CMsignal == 0 then
				local caller = user.CellVars["caller"] 
				
				SendColoredText(user, Color(255,100,0), "Your conversation terminated because you lost signal.")
				SendColoredText(caller, Color(255,100,0), "The conversation abruptly terminates. (Other person lost signal)")
				
				
				local owner
				local CP, CO
				if caller.CellVars["minutes"] > 0 or caller.CellVars["minutes"] > 0 then
				
					if caller.CellVars["imcalling"] == 1 then
						for k,v in pairs(MobileOperators) do
							if caller.CellVars["operator"] == k then
								CP = v.Cprice
								CO = v.Cowner
							end
						end
						for k,v in pairs(player.GetAll()) do
							if v.CellVars["company"] != nil then
								if MatchUserID(tonumber(v:UserID()),tonumber(CO)) then
									owner = v
								end
							end
						end
						if owner != caller then
							caller:AddMoney(-CP*caller.CellVars["minutes"])
							GAMEMODE:Notify(caller, 0, 6, string.format("Paid $"..CP*caller.CellVars["minutes"].." for the "..caller.CellVars["minutes"].." minute(s) long call."))
							
							if IsValid(owner) and owner.CellVars["operator"] == owner.CellVars["company"] then
								GAMEMODE:Notify(owner, 4, 4, string.format("Somone used your service: +$"..CP*caller.CellVars["minutes"]))
								owner:AddMoney(CP*caller.CellVars["minutes"])
							end
						end
						elseif user.CellVars["imcalling"] == 1 then
						
						for k,v in pairs(MobileOperators) do
							if user.CellVars["operator"] == k then
								CP = v.Cprice
								CO = v.Cowner
							end
						end
						for k,v in pairs(player.GetAll()) do
							if v.CellVars["company"] != nil then
								if MatchUserID(tonumber(v:UserID()),tonumber(CO)) then
									owner = v
								end
							end
						end
						if owner != user then
							user:AddMoney(-CP*user.CellVars["minutes"])
							GAMEMODE:Notify(user, 0, 6, string.format("Paid $"..CP*user.CellVars["minutes"].." for the "..user.CellVars["minutes"].." minute(s) long call."))
							
							if IsValid(owner) and owner.CellVars["operator"] == owner.CellVars["company"] then
								GAMEMODE:Notify(owner, 4, 4, string.format("Somone used your service: +$"..CP*user.CellVars["minutes"]))
								owner:AddMoney(CP*user.CellVars["minutes"])
							end
						end
					end
				end
				
				
				caller.CellVars["inconvo"] = false
				user.CellVars["inconvo"] = false
				caller:SetNWInt("cm_called", 0)
				user:SetNWInt("cm_called", 0)
				caller.CellVars["caller"] = nil
				user.CellVars["caller"] = nil
				caller.CellVars["imcalling"] = 0
				user.CellVars["imcalling"] = 0
				caller.CellVars["minutes"] = 0
				user.CellVars["minutes"] = 0
				
				
			end
		end
	end
end

/* -------------------------------------------- */
/* -------------------------------------------------- */
/* -------------------- COMMANDS -------------------- */
/* -------------------------------------------------- */
/* -------------------------------------------- */

AddChatCommand("/givesim", function(ply, args)
	if args == "" then 
		GAMEMODE:Notify(ply, 1, 6, string.format("You need to type /givesim <playname>"))
		return "" 
	end
	if ply:Team() != TEAM_MOPERATOR then
		GAMEMODE:Notify(ply, 1, 6, string.format(LANGUAGE.must_be_x, "Mobile Operator", "/givesim"))
		return ""
	end	

	target = GAMEMODE:FindPlayer(args)

	local eyetrace = ply:GetEyeTrace()
	if not eyetrace.Entity:IsValid() or not eyetrace.Entity:IsPlayer() then
		if eyetrace.Entity != target then
			GAMEMODE:Notify(ply, 1, 10, "You must look at the player you want to give the SIMcard to!")
			return ""
		end
	end
	
	if target then
		if ply.CellVars["company"] == nil then
			GAMEMODE:Notify(ply, 1, 10, "There was an error in your company configuration.")
			return ""
		end
		
		if target.CellVars["company"] != nil then
			GAMEMODE:Notify(ply, 1, 10, "The player you are trying to give a SIMcard to, owns their own company.")
			return ""
		end
		
		local CP, TP
		
		for k,v in pairs(MobileOperators) do
			if ply.CellVars["company"] == k then
				CP = v.Cprice
				TP = v.Tprice
			end
		end

		SendColoredText(target, Color(255,175,0), ply:Nick().." is trying to give you a simcard for the company: "..ply.CellVars["company"]..".")
		SendColoredText(target, Color(255,175,0), "Prices; $"..CP.." each talk minute | $"..TP.." each text message")
		SendColoredText(target, Color(255,175,0), "Type /acceptsim to accept the simcard.")
		target.CellVars["acceptsim"] = ply.CellVars["company"]
		SendColoredText(ply, Color(255,175,0), "You have sent a simcard request to "..target:Nick()..".")
		
		
	else
		GAMEMODE:Notify(ply, 1, 4, string.format(LANGUAGE.could_not_find, "player: "..tostring(name)))
	end
	return ""
end )

AddChatCommand("/acceptsim", function(ply, args)
	if ply.CellVars["acceptsim"] != nil then
		ply:SetOperator(ply.CellVars["acceptsim"])
		local operator = ply.CellVars["operator"]
		SendColoredText(ply, Color(255,175,0), "You have accepted the simcard. Your provider: "..operator..".")
		return ""
	end
end)

function MakeACall(ply, args)
	if args == "" then return "" end
	target = GAMEMODE:FindPlayer(args)
	
	if ply.CellVars["operator"] == "nil" then
		GAMEMODE:Notify(ply, 1, 6, string.format("You need a cellphone operator to call."))
		return ""
	end
	if ply.DarkRPVars.CMsignal == 0 then
		SendColoredText(ply, Color(255,100,0), "You need network signal to be available to call.")
		return ""
	end
	
	if target then
		if target.CellVars["operator"] == "nil" then
			SendColoredText(ply, Color(255,100,0), "The person you are trying to reach, does not have a cellphone.")
			return ""
		end
		if target:GetNWInt("cm_called") > 0 then
			SendColoredText(ply, Color(255,100,0), "You get a busy tone...")
			return ""
		end
		if target.DarkRPVars.CMsignal == 0 then
			SendColoredText(ply, Color(255,100,0), "The person you are trying to reach, is not available for the moment. Please try again later.")
			return ""
		end
		target:SetNWInt("cm_called", 1)
		ply:SetNWInt("cm_called", 3)
		target.CellVars["caller"] = ply
		ply.CellVars["caller"] = target
		SendColoredText(target, Color(100,255,0), "Incomming call: "..ply:Nick().." (/pickup to answer the call)")
		GAMEMODE:TalkToRange(target, target:Nick().."'s phone starts ringing.", "", 250)
		SendColoredText(ply, Color(100,255,0), "Calling... (Waiting for "..target:Nick().." to pickup)")
		
	else
		GAMEMODE:Notify(ply, 1, 4, string.format(LANGUAGE.could_not_find, "player: "..tostring(args)))
	end
	return ""
end

local function CallCellMod(ply, args)
	if args == "" then
		GAMEMODE:Notify(ply, 1, 4, DarkRP.getPhrase("invalid_x", "argument", ""))
		return ""
	end

	MakeACall(ply, args)
	return ""
end
AddChatCommand("/call", CallCellMod, 1.5)

AddChatCommand("/pickup", function(ply, args)
	caller = ply.CellVars["caller"]
	
	if ply.CellVars["operator"] == "nil" then
		GAMEMODE:Notify(ply, 1, 6, string.format("You need a cellphone operator to answer a call."))
		return ""
	end
	
	if ply:GetNWInt("cm_called") == 0 then
		GAMEMODE:Notify(ply, 1, 6, string.format("Your phone is not ringing."))
	else
		GAMEMODE:TalkToRange(target, target:Nick().." answers their phone.", "", 250)
		
		SendColoredText(ply, Color(255,100,0), "You picked up the call. Use /t <text> to talk to the phone.")
		SendColoredText(caller, Color(255,100,0), ply:Nick().." picked up the call. Use /t <text> to talk to the phone")
		
		ply.CellVars["inconvo"] = true
		caller.CellVars["inconvo"] = true
		ply:SetNWInt("cm_called", 2)
		caller:SetNWInt("cm_called", 2)
		
		caller.CellVars["minutes"] = 1 //At least count him/her like 1 minute, when called started.
		caller.CellVars["imcalling"] = 1
	end
	return ""
end)


AddChatCommand("/t", function(ply, args)
	if args == "" then return "" end
	if ply.CellVars["operator"] == "nil" then
		GAMEMODE:Notify(ply, 1, 6, string.format("You need a cellphone operator to do this."))
		return ""
	end

	local target = ply.CellVars["caller"]
	
	if ply.CellVars["inconvo"] != true then
		GAMEMODE:Notify(ply, 1, 6, string.format("You don't have an active call to do this."))
		return ""
	end
	
	local col = team.GetColor(ply:Team())
	GAMEMODE:TalkToPerson(target, col, "(Call) "..ply:Nick(),Color(255,255,255,255), args, ply)
	GAMEMODE:TalkToRange(ply, "(Call) "..ply:Nick().. ": " .. args, "", 150)
	return ""
end)

AddChatCommand("/hangup",function(ply, args)
	if ply.CellVars["operator"] == "nil" then
		GAMEMODE:Notify(ply, 1, 6, string.format("You need a cellphone operator to do this."))
		return ""
	end
	
	if ply:GetNWInt("cm_called") == 0 then
		GAMEMODE:Notify(ply, 1, 6, string.format("You don't have an active call to do this."))
		return ""
	end
	
	local caller = ply.CellVars["caller"] 
	
	SendColoredText(ply, Color(255,100,0), "You hanged up.")
	SendColoredText(caller, Color(255,100,0), ply:Nick().." hangs up.")
	
	GAMEMODE:TalkToRange(ply, ply:Nick().." hangs up the phone.", "", 250)

	local owner
	local CP, CO
	if caller.CellVars["minutes"] > 0 or ply.CellVars["minutes"] > 0 then
	
		if caller.CellVars["imcalling"] == 1 then
			for k,v in pairs(MobileOperators) do
				if caller.CellVars["operator"] == k then
					CP = v.Cprice
					CO = v.Cowner
				end
			end
			for k,v in pairs(player.GetAll()) do
				if v.CellVars["company"] != nil then
					if MatchUserID(tonumber(v:UserID()),tonumber(CO)) then
						owner = v
					end
				end
			end
			if owner != caller then
				caller:AddMoney(-CP*caller.CellVars["minutes"])
				GAMEMODE:Notify(caller, 0, 6, string.format("Paid $"..CP*caller.CellVars["minutes"].." for the "..caller.CellVars["minutes"].." minute(s) long call."))

				if IsValid(owner) and owner.CellVars["operator"] == owner.CellVars["company"] then
					GAMEMODE:Notify(owner, 4, 4, string.format("Somone used your service: +$"..CP*caller.CellVars["minutes"]))
					owner:AddMoney(CP*caller.CellVars["minutes"])
				end
			end
			elseif ply.CellVars["imcalling"] == 1 then
			
			for k,v in pairs(MobileOperators) do
				if ply.CellVars["operator"] == k then
					CP = v.Cprice
					CO = v.Cowner
				end
			end
			for k,v in pairs(player.GetAll()) do
				if v.CellVars["company"] != nil then
					if MatchUserID(tonumber(v:UserID()),tonumber(CO)) then
						owner = v
					end
				end
			end
			if owner != ply then
				ply:AddMoney(-CP*ply.CellVars["minutes"])
				GAMEMODE:Notify(ply, 0, 6, string.format("Paid $"..CP*ply.CellVars["minutes"].." for the "..ply.CellVars["minutes"].." minute(s) long call."))
				
				if IsValid(owner) and owner.CellVars["operator"] == owner.CellVars["company"] then
					GAMEMODE:Notify(owner, 4, 4, string.format("Somone used your service: +$"..CP*ply.CellVars["minutes"]))
					owner:AddMoney(CP*ply.CellVars["minutes"])
				end
			end
		end
	end

	caller.CellVars["inconvo"] = false
	ply.CellVars["inconvo"] = false
	caller:SetNWInt("cm_called", 0)
	ply:SetNWInt("cm_called", 0)
	caller.CellVars["caller"] = nil
	ply.CellVars["caller"] = nil
	caller.CellVars["imcalling"] = 0
	ply.CellVars["imcalling"] = 0
	caller.CellVars["minutes"] = 0
	ply.CellVars["minutes"] = 0
	
	return ""
end)

local function SMS(ply, args)
	if args == "" then return "" end
	if ply.CellVars["operator"] == "nil" then
		GAMEMODE:Notify(ply, 1, 6, string.format("You need a cellphone operator to send text messages."))
		return ""
	end
	
	local namepos = string.find(args, " ")
	if not namepos then return "" end

	local name = string.sub(args, 1, namepos - 1)
	local msg = string.sub(args, namepos + 1)
	if msg == "" then return "" end
	target = GAMEMODE:FindPlayer(name)
	
	if ply.DarkRPVars.CMsignal == 0 then
		SendColoredText(ply, Color(255,100,0), "You need network signal to be available to send a text message.")
		return ""
	end
	
	
	if target then
		if target.CellVars["operator"] == "nil" then
			SendColoredText(ply, Color(255,100,0), "The person you are trying to reach, does not have a cellphone.")
			return ""
		end
		if target.DarkRPVars.CMsignal == 0 then
			SendColoredText(ply, Color(255,100,0), "The person you are trying to reach, is not available for the moment. Please try again later.")
			return ""
		end

		
		local TP, CO
		for k,v in pairs(MobileOperators) do
			if ply.CellVars["operator"] == k then
				TP = v.Tprice
				CO = v.Cowner
			end
		end
		local owner
		for k,v in pairs(player.GetAll()) do
			if v.CellVars["company"] != nil then
				if MatchUserID(tonumber(v:UserID()),tonumber(CO)) then
					owner = v
				end
			end
		end
		if owner != ply then
			if not ply:CanAfford(TP) then
				GAMEMODE:Notify(ply, 1, 4, string.format(LANGUAGE.cant_afford, "textmessage"))
				return ""
			end
			ply:AddMoney(-TP)
			GAMEMODE:Notify(ply, 0, 6, string.format("Paid $"..TP.." for the text message"))
			if IsValid(owner) and owner.CellVars["operator"] == owner.CellVars["company"] then
				GAMEMODE:Notify(owner, 0, 4, string.format("Somone used your service: +$"..TP))
				owner:AddMoney(TP)
			end
		end
		
		local col = team.GetColor(ply:Team())
		GAMEMODE:TalkToPerson(target, col, "(SMS) "..ply:Nick(),Color(255,255,255,255), msg, ply)
		GAMEMODE:TalkToPerson(ply, col, "(SMS) "..ply:Nick(), Color(255,255,255,255), msg, ply)
		target:EmitSound("cellmod/text_message.wav", 75, 100)
	else
		GAMEMODE:Notify(ply, 1, 4, string.format(LANGUAGE.could_not_find, "player: "..tostring(name)))
	end

	return ""
end
AddChatCommand("/text", SMS)
AddChatCommand("/sms", SMS)