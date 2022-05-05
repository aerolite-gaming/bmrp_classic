local function HideScoreboard(ply, cmd, args)
	if not FAdmin.Access.PlayerHasPrivilege(ply, "HideFromScoreboard") then FAdmin.Messages.SendMessage(ply, 5, "No access!") return end

	local targets = FAdmin.FindPlayer(args[1])
	if not targets or #targets == 1 and not IsValid(targets[1]) then
		FAdmin.Messages.SendMessage(ply, 1, "Player not found")
		return
	end

	for _, target in pairs(targets) do
		if IsValid(target) and not target:FAdmin_GetGlobal("FAdmin_hidescoreboard") then
			target:FAdmin_SetGlobal("FAdmin_hidescoreboard", true)
		end
	end
	FAdmin.Messages.ActionMessage(ply, targets, "You were hidden on the Scoreboard by %s", "You were hidden on the Scoreboard by %s", "Hidden %s on the Scoreboard")
end

local function UnhideScoreboard(ply, cmd, args)
	if not FAdmin.Access.PlayerHasPrivilege(ply, "HideFromScoreboard") then FAdmin.Messages.SendMessage(ply, 5, "No access!") return end

	local targets = FAdmin.FindPlayer(args[1])
	if not targets or #targets == 1 and not IsValid(targets[1]) then
		FAdmin.Messages.SendMessage(ply, 1, "Player not found")
		return
	end

	for _, target in pairs(targets) do
		if IsValid(target) and target:FAdmin_GetGlobal("FAdmin_hidescoreboard") then
			target:FAdmin_SetGlobal("FAdmin_hidescoreboard", false)
		end
	end
	FAdmin.Messages.ActionMessage(ply, targets, "You were unhidden on the Scoreboard by %s", "You were unhidden on the Scoreboard by %s", "Unhidden %s on the Scoreboard")
end

FAdmin.StartHooks["HideFromScoreboard"] = function()
	FAdmin.Commands.AddCommand("HideScoreboard", HideScoreboard)
	FAdmin.Commands.AddCommand("UnhideScoreboard", UnhideScoreboard)

	FAdmin.Access.AddPrivilege("HideFromScoreboard", 2)
end