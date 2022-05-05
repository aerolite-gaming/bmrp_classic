/*
================================================================================
This script should fix MAX_CHANNELS on Sector C and other maps with the issue
================================================================================
*/

if CLIENT then
	pressedornot = 0
	function Soundfix (P, key)
		if pressedornot ~= 1 then
			RunConsoleCommand("stopsound")
			RunConsoleCommand("cl_pred_optimize", "1");
			RunConsoleCommand("FAdmin_IsScoreboard", "1");
			print("ALG: Ran Soundfix")
			pressedornot = 1
		end	
	end
	hook.Add( "KeyPress", "Soundfixer", Soundfix )
	concommand.Add("SoundFix", "SoundFix", Soundfix)
end

function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf ) 
	 if ply:GetNoDraw() == true then return true else return false end
end