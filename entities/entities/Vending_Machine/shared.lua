
ENT.Base			= "base_gmodentity" 
ENT.Type			= "anim"
ENT.PrintName		= "VendingMachine"
ENT.Author			= "ALG_Radish"
ENT.Contact			= "N/A"
ENT.Purpose			= "Food Dispenser"
ENT.Instructions	= "Press E"
ENT.Category 		= "Roleplay"

ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end