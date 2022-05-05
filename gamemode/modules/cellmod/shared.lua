/*                                      | * FILE: shared.lua
                  ______                |
                  |    |                | * AUTHOR: Blt950
                  |    |                | * AUTHOR WEBSIDE: http://blt950.com
                  |    |                |
        ________________                | * PRODUCT LICENSED: http://creativecommons.org/licenses/by-nd/3.0/
        |  __________  |                | By using this product, you agree to follow the license limitations.
        | |  CellMod | |                | Got any questions, contact author.
        | |   v1.2   | |                |
        | |          | |                | * FACEPUNCH THREAD: http://www.facepunch.com/threads/1131388
        | |__________| |                |
        |              |                |
        |  1   2   3   |                |
        |  4   5   6   |                |
        |  7   8   9   |                |
        |  *   0   #   |                |
        ________________                |
                                    	|
										|
________________________________________|____________________________________________________________________________________
*/
/*
TEAM_MOPERATOR = AddExtraTeam("Mobile Operator", Color(255, 0, 255, 255), "models/player/mossman.mdl", [[(CellMod) As a mobile network operator,
your job is to make your mobile service and prices
attractive for other players, and conquer with other companies.
To give other players your company simcard use /givesim.]], {}, "operator", 4, 45, 0, 0, false)*/

TEAM_MOPERATOR = AddExtraTeam("Mobile Operator", {
	color = Color(255, 0, 255, 255),
	model = "models/player/mossman.mdl",
	description = [[(CellMod) As a mobile network operator,
your job is to make your mobile service and prices
attractive for other players, and conquer with other companies.
To give other players your company simcard use /givesim.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "operator",
	max = 0,
	salary = 50,
	admin = 0,
	vote = false,
	hasLicense = false,
	DonatorOnly = "No",
	XPNeeded = "20",
	candemote = false,
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=20 or ply:IsAdmin() end	
})
