-- Black Mesa Time Schedule

local map = game.GetMap();
timer.Create("timeschedule", 2, 0, function()
    
	local hour = tonumber(os.date("%H"));
	local minute = tonumber(os.date("%M"));
	local second = tonumber(os.date("%S"));

--	Black Mesa Roleplay 
	
	if hour == 04 and minute == 00 and map == "rp_sectorc_beta" then
	RunConsoleCommand("changelevel", "rp_sectorc_beta");
	end
	
-- Defining Messages

	if hour == 03 and minute == 50 and second == 00 then
	PrintMessage( HUD_PRINTTALK, "Server will reset the map in 10 minutes!" )
	end
	
	if hour == 03 and minute == 59 and second == 00 then
	PrintMessage( HUD_PRINTTALK, "Server will reset the map in 1 minutes!" )
	end
	
end);

function killthetimer(ply)
	if ply:IsAdmin() then
		timer.Destroy("timeschedule")
		print "Timer has been killed!"
	end
end

concommand.Add("KillTimer", killthetimer)
