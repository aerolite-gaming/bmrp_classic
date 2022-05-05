TEAM_CITIZEN = AddExtraTeam("Visitor", {
	color = Color(20, 150, 20, 255),
	model = {
		"models/player/Group01/Female_01.mdl",
		"models/player/Group01/Female_02.mdl",
		"models/player/Group01/Female_03.mdl",
		"models/player/Group01/Female_04.mdl",
		"models/player/Group01/Female_06.mdl",
		"models/player/group01/male_01.mdl",
		"models/player/Group01/Male_02.mdl",
		"models/player/Group01/male_03.mdl",
		"models/player/Group01/Male_04.mdl",
		"models/player/Group01/Male_05.mdl",
		"models/player/Group01/Male_06.mdl",
		"models/player/Group01/Male_07.mdl",
		"models/player/Group01/Male_08.mdl",
		"models/player/Group01/Male_09.mdl"
	},
	description = [[You are a visitor to the Black Mesa research facility.
You may only access certain areas of the facility and must be
accompanied by a member of staff at all times.]],
	weapons = {},
	command = "visitor",
	max = 0,
	salary = 0,
	admin = 0,
	vote = false,
	XPNeeded = "0",	
	DonatorOnly = "No",	
	hasLicense = false
})

TEAM_SECURITY = AddExtraTeam("Security Officer", {
	color = Color(25, 25, 170, 255),
	model = {
		"models/player/hdpp/male_09.mdl",
		"models/player/hdpp/male_06.mdl",
		"models/player/hdpp/male_05.mdl",
		"models/player/hdpp/barney.mdl"
	},
	description = [[The vast majority of guards work as security officers, 
tasked with protecting secured areas and information, 
reporting breaches of authority to their administrative 
sponsor and helping with general maintenance tasks. 
In rare cases, security officers will be tasked 
with capturing escaped research specimens.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "securityofficer",
	max = 5,
	salary = 65,
	admin = 0,
	vote = false,
	security = true,
	XPNeeded = "35",
	DonatorOnly = "No",	
	hasLicense = true,
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=35 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end	
})


TEAM_SECINSTRUCTOR = AddExtraTeam("Security Instructor", {
	color = Color(25, 25, 170, 255),
	model = {
		"models/player/hdpp/male_09.mdl",
		"models/player/hdpp/male_06.mdl",
		"models/player/hdpp/male_05.mdl",
		"models/player/hdpp/barney.mdl"
	},
	description = [[Security officers will often take on additional work 
instructing new recruits in the Sector A Training Facility.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "securityinstructor",
	max = 2,
	salary = 50,
	admin = 0,
	vote = false,
	security = true,	
	XPNeeded = "45",
	DonatorOnly = "No",	
	hasLicense = true,
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=45 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end	

})

TEAM_SECURITYADMIN = AddExtraTeam("Section Manager", {
	color = Color(25, 25, 170, 255),
	model = {
		"models/player/hdpp/male_09.mdl",
		"models/player/hdpp/male_06.mdl",
		"models/player/hdpp/male_05.mdl",
		"models/player/hdpp/barney.mdl"
	},
	description = [[The role of section manager is effectively a desk 
job that consists of directing security 
officers and assigning tasks.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "sectionmanager",
	max = 3,
	salary = 85,
	admin = 0,
	vote = false,
	hasLicense = true,
	security = true,	
	XPNeeded = "200",
	DonatorOnly = "Yes",	
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=200 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end	
})

TEAM_PHYSICIST = AddExtraTeam("Research and Development", {
	color = Color(75, 75, 75, 255),
	model = {
		"models/player/hdpp/male_01.mdl",
		"models/player/hdpp/male_02.mdl",
		"models/player/hdpp/male_03.mdl"
	},
	description = [[The largest portion of the scientists are assigned 
to research and development positions, where 
they conduct experiments and create new technologies. 
The research conducted ranges in focus from particle 
physics to biological study to space travel. 
Most R&D scientists have a limited knowledge 
of first aid, and can heal some wounds.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "researchanddevelopment",
	max = 10,
	salary = 95,
	admin = 0,
	vote = false,
	science = true,
	XPNeeded = "25",
	DonatorOnly = "No",	
	hasLicense = false,
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=25 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end	
})

TEAM_BIOLOGIST = AddExtraTeam("Research Associate", {
	color = Color(75, 75, 75, 255),
	model = {
		"models/player/hdpp/male_01.mdl",
		"models/player/hdpp/male_02.mdl",
		"models/player/hdpp/male_03.mdl"
	},
	description = [[Research Associates work alongside R&D scientists, 
but with a lower status in the employment hierarchy. 
They are usually required to conduct the more mundane or 
less desirable portions of a given experiment.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "researchassociate",
	max = 5,
	salary = 95,
	admin = 0,
	vote = false,
	science = true,
	XPNeeded = "15",	
	DonatorOnly = "No",	
	hasLicense = false,
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=15 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end	
})

TEAM_HES = AddExtraTeam("Hazardous Environment Supervisor", {
	color = Color(75, 75, 75, 255),
	model = {
		"models/player/hdpp/male_01.mdl",
		"models/player/hdpp/male_02.mdl",
		"models/player/hdpp/male_03.mdl"
	},
	description = [[Supervisors act in a similar role to research associates 
in that they assist in experiments, but they are 
primarily concerned with maintaining a safe work environment.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "hazenvironmentsupervisor",
	max = 2,
	salary = 95,
	admin = 0,
	vote = false,
	science = true,
	XPNeeded = "15",	
	DonatorOnly = "No",
	hasLicense = false,
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=15 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end	
})

TEAM_SCIINSTRUCTOR = AddExtraTeam("Science Instructor", {
	color = Color(75, 75, 75, 255),
	model = {
		"models/player/hdpp/male_01.mdl",
		"models/player/hdpp/male_02.mdl",
		"models/player/hdpp/male_03.mdl"
	},
	description = [[Scientists will often take on additional work training 
employees and conducting simulations in the 
Sector A Training Facility, as themselves or their 
hologram counterparts.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "scienceinstructor",
	max = 2,
	salary = 95,
	admin = 0,
	vote = false,
	science = true,
	XPNeeded = "35",
	DonatorOnly = "No",	
	hasLicense = false,
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=35 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end	
})

TEAM_HEADPHYSICIST = AddExtraTeam("Head Research and Development", {
	color = Color(25, 25, 25, 255),
	model = {
		"models/player/hdpp/male_01.mdl",
		"models/player/hdpp/male_02.mdl",
		"models/player/hdpp/male_03.mdl"
	},
	description = [[Scientists in the research and development team
need somebody to tell them what to do. That is your job,
assign them tasks and work with them.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "headresearchanddevelopment",
	max = 2,
	salary = 100,
	admin = 0,
	vote = false,
	hasLicense = false,
	XPNeeded = "200",	
	science = true,
	DonatorOnly = "Yes",	
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=200 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end	
})

TEAM_EXPLORATION = AddExtraTeam("Survey Team", {
	color = Color(255,209,26),
	model = {
		"models/player/hdpp/male_01.mdl",
		"models/player/hdpp/male_02.mdl",
		"models/player/hdpp/male_03.mdl"
	},
	description = [[Survey Teams were organized soon after the first 
teleportation labs were constructed in Black Mesa. 
Their assignment is the most dangerous, as they are 
tasked with entering the borderworld Xen to 
collect samples and conduct experiments. 
Because of the danger, Survey Team members are 
highly trained in the use of the HEV Suit and a 
variety of weapons. Many Survey Team scientists 
have died on Xen.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "surveyteam",
	max = 5,
	salary = 75,
	admin = 0,
	vote = false,
	science = true,
	XPNeeded = "30",
	DonatorOnly = "No",	
	hasLicense = false,
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=30 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end	
})

TEAM_HEADEXPLORATION = AddExtraTeam("Head Survey Team", {
	color = Color(255,209,26),
	model = {
		"models/player/hdpp/male_01.mdl",
		"models/player/hdpp/male_02.mdl",
		"models/player/hdpp/male_03.mdl"
	},
	description = [[Survey Teams were organized soon after the first 
teleportation labs were constructed in Black Mesa. 
Their assignment is the most dangerous, as they are 
tasked with entering the borderworld Xen to 
collect samples and conduct experiments. 
Because of the danger, Survey Team members are 
highly trained in the use of the HEV Suit and a 
variety of weapons. Many Survey Team scientists 
have died on Xen.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "headsurveyteam",
	max = 2,
	salary = 95,
	admin = 0,
	vote = false,
	hasLicense = false,
	science = true,
	XPNeeded = "200",	
	DonatorOnly = "Yes",	
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=200 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end	
})

TEAM_MEDIC = AddExtraTeam("Medic", {
	color = Color(47, 79, 79, 255),
	model = "models/player/kleiner.mdl",
	description = [[You are the onsite medic and must make sure that
if injury occurs in the workplace you are onsite
to help.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "medic",
	medic = true,
	max = 5,
	salary = 50,
	admin = 0,
	vote = false,
	XPNeeded = "10",
	DonatorOnly = "No",	
	hasLicense = false,
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=10 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end
})

TEAM_COOK = AddExtraTeam("Cafe Cook", {
	color = Color(238, 99, 99, 255),
	model = "models/player/mossman.mdl",
	description = [[Setup a Cafe in the facility and make sure the staff of
Black Mesa are fed when they need it. There is a 
few Cafe areas in the facility.
You can spawn a microwave and sell the food you make:
/Buymicrowave]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "cook",
	cook = true,
	max = 5,
	salary = 35,
	admin = 0,
	vote = false,
	XPNeeded = "5",	
	DonatorOnly = "No",	
	hasLicense = false,
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=5 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end
})

TEAM_MAYOR = AddExtraTeam("Administrator", {
	color = Color(150, 20, 20, 255),
	model = "models/player/breen.mdl",
	description = [[You decide where the government funding goes and you 
decide who to fire and who to hire.

Type /lockdown initiate a lockdown of the facility.
Everyone must evacuate the building during lockdown.
The Security should patrol the area
/unlockdown to end a lockdown]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "administrator",
	max = 1,
	salary = 135,
	admin = 0,
	vote = false,
	mayor = true,
	hasLicense = false,
	XPNeeded = "800",
	DonatorOnly = "Yes",
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=800 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end	
})

TEAM_HECUMEDIC = AddExtraTeam("HECU Medic", {
	color = Color(25,74,0),
	model = "models/player/shephard.mdl",
	description = [[Although the facility maintains a small military presence, 
the bulk of the facility's military personnel are the 
Hazardous Environment Combat Unit who are kept off-site 
and only sent in as a clean-up crew in case of extreme 
circumstances. ]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "hecumedic",
	max = 1,
	salary = 65,
	admin = 0,
	vote = false,
	hasLicense = true,
	XPNeeded = "400",
	DonatorOnly = "Yes",	
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=400 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end	
})

TEAM_HECU = AddExtraTeam("HECU Marine", {
	color = Color(25,74,0),
	model = "models/player/shephard.mdl",
	description = [[Although the facility maintains a small military presence, 
the bulk of the facility's military personnel are the 
Hazardous Environment Combat Unit who are kept off-site 
and only sent in as a clean-up crew in case of extreme 
circumstances. ]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "hecumarine",
	max = 5,
	salary = 65,
	admin = 0,
	vote = false,
	hasLicense = true,
	XPNeeded = "400",
	DonatorOnly = "Yes",	
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=400 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end	
})

TEAM_HECUCOMMANDER = AddExtraTeam("HECU Commander", {
	color = Color(25,74,0),
	model = "models/player/shephard.mdl",
	description = [[Although the facility maintains a small military presence, 
the bulk of the facility's military personnel are the 
Hazardous Environment Combat Unit who are kept off-site 
and only sent in as a clean-up crew in case of extreme 
circumstances.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "hecucommander",
	cook = true,
	max = 1,
	salary = 85,
	admin = 0,
	vote = false,
	hasLicense = true,
	XPNeeded = "750",
	DonatorOnly = "Yes",	
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=750 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end	
})

TEAM_HEALTHINSPECTOR = AddExtraTeam("Government Worker", {
	color = Color(87, 120, 255),
	model = "models/player/gman_high.mdl",
	description = [[Sent in by the government, you need to check the state
of the facility and make sure health and safety standards
are being followed at all times.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "healthinspecotr",
	max = 2,
	salary = 105,
	admin = 0,
	vote = false,
	XPNeeded = "300",
	DonatorOnly = "No",	
	hasLicense = false,
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=300 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end	
})

TEAM_JANITOR = AddExtraTeam("Service Personnel", {
	color = Color(238, 99, 99, 255),
	model = {
		"models/player/Group01/Female_04.mdl",
		"models/player/Group01/Female_06.mdl",
		"models/player/group01/male_01.mdl",
		"models/player/Group01/Male_02.mdl",
		"models/player/Group01/male_03.mdl"
	},
	description = [[As the service personnel your job is to make sure
the facility is maintained to the highest standards
by making sure it's clean and running efficiently.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "servicepersonnel",
	max = 5,
	salary = 25,
	admin = 0,
	vote = false,
	XPNeeded = "5",
	DonatorOnly = "No",	
	hasLicense = false,
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=5 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end
})

TEAM_TECHNICIAN = AddExtraTeam("IT Technician", {
	color = Color(238, 99, 99, 255),
	model = {
		"models/player/Group01/Female_04.mdl",
		"models/player/Group01/Female_06.mdl",
		"models/player/Group01/male_01.mdl",
		"models/player/Group01/Male_02.mdl",
		"models/player/Group01/male_03.mdl"
	},
	description = [[Like many places, Black Mesa uses computers.
It's your job to setup and maintain these computers
to ensure the Black Mesa employees can do their jobs.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "technician",
	max = 5,
	salary = 30,
	admin = 0,
	vote = false,
	hasLicense = false,
	XPNeeded = "10",
	DonatorOnly = "No",
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=10 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end
})

TEAM_BIOWORKER = AddExtraTeam("Bioworker", {
	color = Color(176,196,222),
	model = "models/player/aphaztechs.mdl",
	description = [[Sometimes hazardous substances are used across
the facility. It's your job to deal with those.]],
	weapons = {"weapon_physcannon", "weapon_physgun", "gmod_tool"},
	command = "bioworker",
	max = 5,
	salary = 90,
	admin = 0,
	vote = false,
	hasLicense = false,
	XPNeeded = "45",
	DonatorOnly = "Yes",	
	customCheck = function(ply) return ply:getDarkRPVar("xp") >=45 or ply:IsUserGroup("vip") or ply:IsUserGroup("moderator") or ply:IsAdmin() end	
})

AddDoorGroup("Scientists Only", TEAM_PHYSICIST, TEAM_BIOLOGIST, TEAM_HES, TEAM_SCIINSTRUCTOR, TEAM_HEADPHYSICIST, TEAM_EXPLORATION, TEAM_HEADEXPLORATION, TEAM_BIOWORKER)
AddDoorGroup("Security and Administrator Only", TEAM_MAYOR, TEAM_SECURITY, TEAM_SECINSTRUCTOR, TEAM_SECURITYADMIN)
AddDoorGroup("Supplier Only", TEAM_SUPPLIER)
AddDoorGroup("HECU Only", TEAM_HECU, TEAM_HECUCOMMANDER, TEAM_HECUMEDIC)

GM:AddGroupChat(TEAM_SECURITY, TEAM_SECINSTRUCTOR, TEAM_SECURITYADMIN)
GM:AddGroupChat(TEAM_PHYSICIST, TEAM_BIOLOGIST, TEAM_HES, TEAM_SCIINSTRUCTOR, TEAM_HEADPHYSICIST, TEAM_EXPLORATION, TEAM_HEADEXPLORATION, TEAM_BIOWORKER)
GM:AddGroupChat(TEAM_MEDIC)
GM:AddGroupChat(TEAM_COOK)
GM:AddGroupChat(TEAM_JANITOR)
GM:AddGroupChat(TEAM_HECU, TEAM_HECUCOMMANDER, TEAM_HECUMEDIC)
GM:AddGroupChat(TEAM_MAYOR, TEAM_HEALTHINSPECTOR)
GM:AddGroupChat(TEAM_TECHNICIAN)
