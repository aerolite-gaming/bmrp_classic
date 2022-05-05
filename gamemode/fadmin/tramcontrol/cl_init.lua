CreateConVar("TramControlStatus", 1, {FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE})

FAdmin.StartHooks["TramControl"] = function()
	FAdmin.Access.AddPrivilege("TramControl", 2)
	FAdmin.Commands.AddCommand("ToggleTram", nil)
	
	FAdmin.ScoreBoard.Server:AddServerAction(function() return (tobool(GetConVarNumber("TramControlStatus")) and "Disable" or "Enable").." Tram" end,
	function() return "FAdmin/icons/PickUp", tobool(GetConVarNumber("TramControlStatus")) and "FAdmin/icons/disable" end, Color(0, 155, 0, 255), true, function(button)
		button:SetImage2((not tobool(GetConVarNumber("TramControlStatus")) and "FAdmin/icons/disable") or "null")
		button:SetText((not tobool(GetConVarNumber("TramControlStatus")) and "Disable" or "Enable").." Tram")
		button:GetParent():InvalidateLayout()
		RunConsoleCommand("_FAdmin", "ToggleTram", (tobool(GetConVarNumber("TramControlStatus")) and "0") or "1")
	end)
end