FAdmin.StartHooks["E2Tracker"] = function()
	FAdmin.Access.AddPrivilege("E2Tracker", 2)
	FAdmin.Commands.AddCommand("E2Tracker", E2TrackerOpenMenu)
end

util.AddNetworkString("E2Tracker_SendData")
util.AddNetworkString("E2Tracker_Action")
util.AddNetworkString("E2Tracker_ReloadData")

function E2TrackerOpenMenu(ply, cmd, args)
	if not FAdmin.Access.PlayerHasPrivilege(ply, "E2Tracker") then FAdmin.Messages.SendMessage(ply, 5, "No access!") return end
	
	local e2ChipTbl = {}
	for k,v in pairs(ents.FindByClass("gmod_wire_expression2")) do
		table.insert(e2ChipTbl, {v, v.player, v.name})
	end
	
	net.Start("E2Tracker_SendData")
		net.WriteTable(e2ChipTbl)
	net.Send(ply)
end

net.Receive("E2Tracker_Action", function(len, ply)
	if not FAdmin.Access.PlayerHasPrivilege(ply, "E2Tracker") then FAdmin.Messages.SendMessage(ply, 5, "No access!") return end
	
	local Action = net.ReadString()
	local E2Chip = net.ReadEntity()
	print(Action)
	if Action == "Download" then
		WireLib.Expression2Download(ply, E2Chip)
		E2TrackerReloadData(ply)
	elseif Action == "Delete" then
		E2Chip:Remove()
		E2TrackerReloadData(ply)
	else 
		print("E2Tracker > Unassigned Action received.") 
	end
end)

function E2TrackerReloadData(ply)
	timer.Simple(0.1, function() 
		local e2ChipTbl = {}
		for k,v in pairs(ents.FindByClass("gmod_wire_expression2")) do
			table.insert(e2ChipTbl, {v, v.player, v.name})
		end

		net.Start("E2Tracker_ReloadData")
			net.WriteTable(e2ChipTbl)
		net.Send(ply)
	end)
end