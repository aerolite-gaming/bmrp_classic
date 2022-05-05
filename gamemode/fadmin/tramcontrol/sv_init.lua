CreateConVar("TramControlStatus", 0, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})

local waittime = 10
local lasttimeusage = -waittime

local function ToggleTram(ply, cmd, args)
	if not FAdmin.Access.PlayerHasPrivilege(ply, "ToggleTram", target) then FAdmin.Messages.SendMessage(ply, 5, "No access!") return end

	if lasttimeusage + waittime > CurTime() then
		FAdmin.Messages.SendMessage(ply, 5, "Please wait 10 seconds before toggling the Tram again!")
		return
	end

	if not args[1] then return end

	local Value = tonumber(args[1])
	if Value ~= 1 and Value ~= 0 then return end
	RunConsoleCommand("TramControlStatus", Value)

	local TramInput = "stop"
	local DoorInput = "open"

	if Value == 0 then 
		TramInput = "stop" 
		DoorInput = "open"
	else 
		TramInput = "resume" 
		DoorInput = "close"
	end

	for k, v in pairs(ents.FindByName("train")) do
		v:Fire(TramInput)
	end

	for k,v in pairs(ents.FindByName("traindoor1")) do
		v:Fire(DoorInput)
	end

	for k,v in pairs(ents.FindByName("traindoor2")) do
		v:Fire(DoorInput)
	end

	lasttimeusage = CurTime()
end

FAdmin.StartHooks["TramControl"] = function()
	FAdmin.Access.AddPrivilege("TramControl", 2)
	FAdmin.Commands.AddCommand("ToggleTram", ToggleTram)
end