AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/props/bm/greenvendingmachine.mdl" )
	self:SetSolid( SOLID_BBOX ) 
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
end

function ENT:OnTakeDamage( dmg ) 
	return false
end

function ENT:AcceptInput( name, activator, caller )
	if ( name == "Use" && IsValid( activator ) && activator:IsPlayer() ) then
		activator:ConCommand( "rp_eat_food" )
	end
end

local function ProximityTest( ply )
	for id, ent in pairs( ents.FindInSphere( ply:GetPos(), 64 ) ) do
		if ( ent:GetClass() == "atm_machine" ) then
			return true
		end
	end
	return false
end

concommand.Add( "rp_eat_food", function( pl )
	if ( !ProximityTest( pl ) ) then pl:ChatPrint( "You must be near vending machine to use it!" ) return end
	plHunger = pl:getDarkRPVar("Energy")
	plMoney = pl:getDarkRPVar("money")
	if ( plMoney > 20) then
		pl:ChatPrint( "Nom Nom!" )
		pl:EmitSound("Eat.mp3", 100, 100)
		pl:SetSelfDarkRPVar("money", plMoney-20)
		pl:SetSelfDarkRPVar("Energy", plHunger+20 )
	else
		pl:ChatPrint( "Sorry, you cannot afford that action" )
	end
end )


