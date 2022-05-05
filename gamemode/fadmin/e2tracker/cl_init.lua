FAdmin.StartHooks["E2Tracker"] = function()
	FAdmin.Access.AddPrivilege("E2Tracker", 2)
	FAdmin.Commands.AddCommand("E2Tracker", nil)
end

net.Receive("E2Tracker_SendData", function(len, ply)
	E2TrackerPanel = vgui.Create("DFrame")
	E2TrackerPanel:SetPos(ScrW()-ScrW()/2-300, ScrH()-ScrH()/2-200)
	E2TrackerPanel:SetSize(570, 370)
	E2TrackerPanel:SetTitle("gE2Tracker")
	E2TrackerPanel:SetVisible(true)
	E2TrackerPanel:SetDraggable(true)
	E2TrackerPanel:ShowCloseButton(true)
	E2TrackerPanel:MakePopup()
 
	E2TrackerListView = vgui.Create("DListView", E2TrackerPanel)
	E2TrackerListView:SetPos(10, 30)
	E2TrackerListView:SetSize(550, 325)
	E2TrackerListView:SetMultiSelect(false)
	local EntIndex = E2TrackerListView:AddColumn("EntIndex")
	EntIndex:SetWidth(1)
	E2TrackerListView:AddColumn("Name")
	E2TrackerListView:AddColumn("Player")
	E2TrackerListView:AddColumn("Player - SteamID")
	LoadE2TrackerData(net.ReadTable())
	
	E2TrackerListView.OnClickLine = function(parent, line, isselected)
		local ClickMenu = DermaMenu() 
		local TeleportChipButton = ClickMenu:AddOption("Goto E2 Chip")
			TeleportChipButton:SetIcon("icon16/eye.png")
			TeleportChipButton.DoClick = function()
			LocalPlayer():ConCommand("fadmin tptopos " .. '"' .. string.Replace(tostring(ents.GetByIndex(line:GetValue(1)):GetPos()), " ", ", " ) .. '"')
			end
			
		local TeleportOwnerButton = ClickMenu:AddOption("Goto Owner")
			TeleportOwnerButton:SetIcon("icon16/user_go.png")
			TeleportOwnerButton.DoClick = function()
			LocalPlayer():ConCommand('fadmin goto ' .. '"' .. line:GetValue(4) ..'"')
			end
				
		ClickMenu:AddSpacer()
		
		local DownloadButton = ClickMenu:AddOption("View in Editor")
			DownloadButton:SetIcon("icon16/script_key.png")
			DownloadButton.DoClick = function()
				net.Start("E2Tracker_Action")
					net.WriteString("Download") 
					net.WriteEntity(ents.GetByIndex(line:GetValue(1)))
				net.SendToServer()
			end

		local DeleteButton = ClickMenu:AddOption("Delete")
			DeleteButton:SetIcon("icon16/cross.png")
			DeleteButton.DoClick = function()
				net.Start("E2Tracker_Action")
					net.WriteString("Delete") 
					net.WriteEntity(ents.GetByIndex(line:GetValue(1)))
				net.SendToServer()
			end
		ClickMenu:Open()
	end
end)

net.Receive("E2Tracker_ReloadData", function(len, ply)
	local tbl = net.ReadTable()
	LoadE2TrackerData(tbl)
end)

function LoadE2TrackerData(e2ChipTbl)
	E2TrackerListView:Clear()
	
	for i=1, table.Count(e2ChipTbl) do
		E2TrackerListView:AddLine(e2ChipTbl[i][1]:EntIndex(),e2ChipTbl[i][3], e2ChipTbl[i][2]:Name(), e2ChipTbl[i][2]:SteamID())
	end
end