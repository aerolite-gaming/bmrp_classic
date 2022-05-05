AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("cl_init.lua")

function ENT:Initialize()

	self:SetModel("models/extras/info_speech.mdl")

	self:SetMoveType(MOVETYPE_NOCLIP)
	self:SetSolid(SOLID_NONE)

end

function ENT:Think()
	if not IsValid( self.ply ) then -- just in case

		self:Remove()

		return
	end

	self:SetPos( self.ply:GetPos() + Vector( 0, 0, 85 ) )

end

local function ToggleChatIndicator( ply )

/*	if not IsValid( ply.ChatIndicator ) then
		if ply:GetNoDraw() == true then return else
			ply.ChatIndicator = ents.Create("chatindicator")
			ply.ChatIndicator.ply = ply -- plyception
			ply.ChatIndicator:SetPos( ply:GetPos() + Vector( 0, 0, 85 ) )
			ply.ChatIndicator:Spawn()
			ply.ChatIndicator:Activate()
		end
	else

		ply.ChatIndicator:Remove()

	end*/
	if ply:getDarkRPVar("currentlytyping") ~= true then
		ply:SetDarkRPVar("currentlytyping", true)
	else
		ply:SetDarkRPVar("currentlytyping", false)
	end	

end
concommand.Add("_DarkRP_ToggleChat", ToggleChatIndicator )

/*local function MakeBotTalk (ply)

for k,v in pairs (player.GetAll()) do
	if v:SteamID() == "BOT" then
		v:SetDarkRPVar("currentlytyping", true)
	end	
end

end
concommand.Add("bottalk", MakeBotTalk)*/

local function RemoveChatIndicator( ply )

	--if IsValid( ply.ChatIndicator ) then

		--ply.ChatIndicator:Remove()

	--end
	ply:SetDarkRPVar("currentlytyping", false)

end
hook.Add("PlayerDisconnected", "Disc_RemoveIndicator", RemoveChatIndicator )
hook.Add("KeyPress", "Move_RemoveIndicator", RemoveChatIndicator ) -- so people can't abuse the command.
hook.Add("PlayerDeath", "Die_RemoveIndicator", RemoveChatIndicator )