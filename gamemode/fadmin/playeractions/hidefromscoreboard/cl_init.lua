FAdmin.StartHooks["HideFromScoreboard"] = function()
	FAdmin.Access.AddPrivilege("HideFromScoreboard", 2)
	FAdmin.Commands.AddCommand("HideScoreboard", nil, "<Player>")
	FAdmin.Commands.AddCommand("UnhideScoreboard", nil, "<Player>")

	FAdmin.ScoreBoard.Player:AddActionButton(function(ply)
		if ply:FAdmin_GetGlobal("FAdmin_hidescoreboard") then return "Unhide from Scoreboard" end
		return "Hide from Scoreboard"
	end, function(ply)
		if ply:FAdmin_GetGlobal("FAdmin_hidescoreboard") then return "FAdmin/icons/cloak", "FAdmin/icons/disable" end
		return "FAdmin/icons/cloak"
	end, Color(255, 130, 0, 255),

	function(ply) return FAdmin.Access.PlayerHasPrivilege(LocalPlayer(), "HideFromScoreboard") and ply == LocalPlayer() end, function(ply, button)
		if not ply:FAdmin_GetGlobal("FAdmin_hidescoreboard") then
			RunConsoleCommand("_FAdmin", "hidescoreboard", ply:UserID())
		else
			RunConsoleCommand("_FAdmin", "unhidescoreboard", ply:UserID())
		end

		if not ply:FAdmin_GetGlobal("FAdmin_hidescoreboard") then button:SetImage2("FAdmin/icons/disable") button:SetText("Unhide from Scoreboard") button:GetParent():InvalidateLayout() return end
		button:SetImage2("null")
		button:SetText("Hide from Scoreboard")
		button:GetParent():InvalidateLayout()
	end)
end