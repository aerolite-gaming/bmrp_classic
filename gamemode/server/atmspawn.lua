local function CreateATMMachine( pos, ang )
	local ATM = ents.Create( "atm_machine" )
	ATM:SetPos( pos )
	ATM:SetAngles( ang )
	ATM:Spawn()
	ATM:Activate()
end 


local function LoadATMs()
	if ( file.Exists( "atm/"..string.lower( game.GetMap() )..".txt", "DATA" ) ) then
		local ATMs = util.JSONToTable( file.Read( "atm/" .. string.lower( game.GetMap() ) .. ".txt" ) )
		for id, tab in pairs( ATMs ) do
			CreateATMMachine( tab.pos, tab.ang )
		end
	else
		MsgN("ATM Spawn file is missing for map " .. string.lower( game.GetMap() ) )
	end
end

concommand.Add( "rp_atm_removespawns", function( ply )
	if ( !ply:IsSuperAdmin() ) then return end
	file.Delete( "atm/"..string.lower( game.GetMap() )..".txt" )
end )

concommand.Add( "rp_atm_savespawns", function( ply )
	if ( !ply:IsSuperAdmin() ) then return end
	local tableOfATMs = {}
	for k, v in pairs( ents.FindByClass( "atm_machine" ) ) do
		table.insert( tableOfATMs, { ang = v:GetAngles(), pos = v:GetPos() } )
	end
	if ( !file.IsDir( "atm", "DATA" ) ) then file.CreateDir( "atm" ) end
	file.Write( "atm/"..string.lower( game.GetMap() ) .. ".txt", util.TableToJSON( tableOfATMs ) )
end )

concommand.Add( "rp_atm_respawnall", function( ply )
	if ( !ply:IsSuperAdmin() ) then return end
	for k, v in pairs( ents.FindByClass( "atm_machine" ) ) do v:Remove() end
	LoadATMs()
end )

concommand.Add( "rp_atm_removeall", function( ply )
	if ( !ply:IsSuperAdmin() ) then return end
	for k, v in pairs( ents.FindByClass( "atm_machine" ) ) do v:Remove() end
end )

timer.Simple( 2, function()
	LoadATMs()
end )
