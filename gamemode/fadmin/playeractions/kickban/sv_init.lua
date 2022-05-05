-- Kicking
local function Kick(ply, cmd, args)
	local targets = FAdmin.FindPlayer(args[1])
	if not targets or #targets == 1 and not IsValid(targets[1]) then
		FAdmin.Messages.SendMessage(ply, 1, "Player not found")
		return
	end

	local CanKick = hook.Call("FAdmin_CanKick", nil, ply, targets)

	if CanKick == false then return end

	local stage = args[2] or ""
	stage = string.lower(stage)
	local stages = {"start", "cancel", "update", "execute"}
	local Reason = (not table.HasValue(stages, stage) and table.concat(args, ' ', 2)) or table.concat(args, ' ', 3) or ply.FAdminKickReason

	for _, target in pairs(targets) do
		if not FAdmin.Access.PlayerHasPrivilege(ply, "Kick", target) then FAdmin.Messages.SendMessage(ply, 5, "No access!")  return end
		if IsValid(target) then
			if stage == "start" then
				SendUserMessage("FAdmin_kick_start", target) -- Tell him he's getting kicked
				target:Lock() -- Make sure he can't remove the hook clientside and keep minging.
				target:Freeze(true)
			elseif stage == "cancel" then
				SendUserMessage("FAdmin_kick_cancel", target) -- No I changed my mind, you can stay
				target:UnLock()
				target:Freeze(false)
				ply.FAdminKickReason = nil
			elseif stage == "update" then -- Update reason text
				if not args[3] then return end
				ply.FAdminKickReason = args[3]
				SendUserMessage("FAdmin_kick_update", target, args[3])
			else//if stage == "execute" or stage == "" then--execute or no stage = kick instantly
				local name = IsValid(ply) and ply:IsPlayer() and ply:Nick() or "Console"

				FAdmin.Messages.ActionMessage(ply, target, "You have kicked %s", "You were kicked by %s", "Kicked %s")

				game.ConsoleCommand(string.format("kickid %s %s\n", target:UserID(), "Kicked by " .. name ..
					" (" .. (Reason or "No reason provided") .. ")"))
				ply.FAdminKickReason = nil
			end
		end
	end
end

local StartBannedUsers = {} -- Prevent rejoining before actual ban occurs
hook.Add("PlayerAuthed", "FAdmin_LeavingBeforeBan", function(ply, SteamID, ...)
	if table.HasValue(StartBannedUsers, SteamID) then
		game.ConsoleCommand(string.format("kickid %s %s\n", ply:UserID(), "Getting banned"))
	end
end)

-- Banning
FAdmin.BANS = FAdmin.BANS or {}

local function Ban(ply, cmd, args)
	if not args[2] then return end
	--start cancel update execute

	local targets = FAdmin.FindPlayer(args[1])

	if not targets and string.find(args[1], "STEAM_") ~= 1 and string.find(args[2], "STEAM_") ~= 1 then
		FAdmin.Messages.SendMessage(ply, 1, "Player not found")
		return
	elseif not targets and (string.find(args[1], "STEAM_") == 1 or string.find(args[2], "STEAM_") == 1) then
		targets = {(args[1] ~= "execute" and args[1]) or args[2]}
		if args[1] == "STEAM_0" then
			targets[1] = table.concat(args, "", 1, 5)
			args[1] = targets[1]
			args[2] = args[6]
			args[3] = args[7]
			for i = 2, #args do
				if i >= 4 then args[i] = nil end
			end
		end
	end

	local CanBan = hook.Call("FAdmin_CanBan", nil, ply, targets)

	if CanBan == false then return end

	local stage = string.lower(args[2])
	local stages = {"start", "cancel", "update", "execute"}
	local Reason = (not table.HasValue(stages, stage) and table.concat(args, ' ', 3)) or table.concat(args, ' ', 4) or ply.FAdminKickReason

	for _, target in pairs(targets) do
		if (type(target) == "string" and not FAdmin.Access.PlayerHasPrivilege(ply, "Ban")) or
		not FAdmin.Access.PlayerHasPrivilege(ply, "Ban", target) then
			FAdmin.Messages.SendMessage(ply, 5, "No access!")
			return
		end
		if stage == "start" and type(target) ~= "string" and IsValid(target) then
			SendUserMessage("FAdmin_ban_start", target) -- Tell him he's getting banned
			target:Lock() -- Make sure he can't remove the hook clientside and keep minging.
			target:Freeze(true)
			table.insert(StartBannedUsers, target:SteamID())

		elseif stage == "cancel" then
			if type(target) ~= "string" and IsValid(target) then
				SendUserMessage("FAdmin_ban_cancel", target) -- No I changed my mind, you can stay
				target:UnLock()
				target:Freeze(false)
				for k,v in pairs(StartBannedUsers) do
					if v == target:SteamID() then
						table.remove(StartBannedUsers, k)
					end
				end
			else -- If he left and you want to cancel
				for k,v in pairs(StartBannedUsers) do
					if v == args[1] then
						table.remove(StartBannedUsers, k)
					end
				end
			end
		elseif stage == "update" then -- Update reason text
			if not args[4] or type(target) == "string" or not IsValid(target) then return end
			ply.FAdminKickReason = args[4]
			umsg.Start("FAdmin_ban_update", target)
				umsg.Long(tonumber(args[3]))
				umsg.String(tostring(args[4]))
			umsg.End()
		else
			local time, Reason = tonumber(args[2]) or 0, (Reason ~= "" and Reason) or args[3] or ""
			if stage == "execute" then
				time = tonumber(args[3]) or 60 --Default to one hour, not permanent.
				Reason = args[4] or ""
			end

			local TimeText = FAdmin.PlayerActions.ConvertBanTime(time)
			if type(target) ~= "string" and  IsValid(target) then
				for k,v in pairs(StartBannedUsers) do
					if v == target:SteamID() then
						table.remove(StartBannedUsers, k)
						break
					end
				end
				local nick = ply.Nick and ply:Nick() or "console"

				local alreadyBanned = false
				for k, v in pairs(SourceBans.BANS) do
					if (v.steamid == target:SteamID()) then alreadyBanned = true end
				end

				if (alreadyBanned) then
					hook.Call("SourceBans_RetrieveBans", nil)
					FAdmin.Messages.ActionMessage(ply, {}, target.." is already banned.")
				else
					hook.Call("SourceBans_StoreBan", nil, target, target:SteamID(), time, Reason, ply, false)
					FAdmin.Messages.ActionMessage(ply, target, "You have Banned %s for " .. TimeText, "You were Banned by %s", "Banned %s (".. TimeText.. ") (".. Reason.. ")")
				end

				game.ConsoleCommand("banid " .. time.." ".. target:SteamID().."\n") -- Don't use banid in combination with RunConsoleCommand
				game.ConsoleCommand(string.format("kickid %s %s\n", target:UserID(), " banned by "..nick.." for "..TimeText.." ("..Reason .. ")" ))
			else
				for k,v in pairs(StartBannedUsers) do
					if v == args[1] then
						table.remove(StartBannedUsers, k)
						break
					end
				end
				
				local alreadyBanned = false
				for k, v in pairs(SourceBans.BANS) do
					if (v.steamid == target) then
						if (v.timestamp > os.time() or v.length == 0) then
							alreadyBanned = true
						end
					end
				end

				if (alreadyBanned) then
					hook.Call("SourceBans_RetrieveBans", nil)
					FAdmin.Messages.ActionMessage(ply, {}, target.." is already banned.", "", target.." is already banned.")
				else
					hook.Call("SourceBans_StoreBan", nil, nil, target, time, Reason, ply, false)
					FAdmin.Messages.ActionMessage(ply, {}, "You have Banned "..target.." for " .. TimeText, "", "Banned "..target.." (".. TimeText.. ") (".. Reason.. ")")
				end

				game.ConsoleCommand("banid ".. time.." ".. target.."\n")
			end
			ply.FAdminKickReason = nil
		end
	end
end

-- Unbanning
local function UnBan(ply, cmd, args)
	if not FAdmin.Access.PlayerHasPrivilege(ply, "UnBan") then FAdmin.Messages.SendMessage(ply, 5, "No access!") return end
	if not args[1] then return end
	local SteamID = string.upper(args[1])

	local banID = nil

	for k,v in pairs(SourceBans.BANS) do
		if v.steamid == SteamID then
			SourceBans.BANS[k] = nil
			banID = k
			break
		end
	end

	if (banID != nil) then hook.Call("SourceBans_UnBan", nil, banID, ply, false) end


	game.ConsoleCommand("removeid ".. SteamID .. "\n")
	FAdmin.Messages.ActionMessage(ply, {}, "You have Unbanned "..SteamID, "", "Unbanned "..SteamID)
end

-- Commands and privileges
FAdmin.StartHooks["KickBan"] = function()
	FAdmin.Commands.AddCommand("kick", Kick)
	FAdmin.Commands.AddCommand("ban", Ban)
	FAdmin.Commands.AddCommand("gban", GlobalBan)
	FAdmin.Commands.AddCommand("unban", UnBan)

	FAdmin.Access.AddPrivilege("Kick", 2)
	FAdmin.Access.AddPrivilege("Ban", 2)
	FAdmin.Access.AddPrivilege("UnBan", 2)
end