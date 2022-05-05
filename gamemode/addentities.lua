AddCustomShipment("Desert eagle", {
	model = "models/weapons/w_pist_deagle.mdl",
	entity = "weapon_real_cs_desert_eagle",
	price = 850,
	amount = 10,
	seperate = true,
	pricesep = 750,
	noship = true,
	allowed = {TEAM_HECU, TEAM_HECUCOMMANDER}
})

AddCustomShipment("Fiveseven", {
	model = "models/weapons/w_pist_fiveseven.mdl",
	entity = "weapon_real_cs_five-seven",
	price = 550,
	amount = 10,
	seperate = true,
	pricesep = 550,
	noship = true,
	allowed = {TEAM_HECU, TEAM_HECUCOMMANDER}
})

AddCustomShipment("Glock", {
	model = "models/weapons/w_pist_glock18.mdl",
	entity = "weapon_real_cs_glock18",
	price = 350,
	amount = 10,
	seperate = true,
	pricesep = 350,
	noship = true,
	allowed = {TEAM_HECU, TEAM_HECUCOMMANDER, TEAM_SECURITYADMIN}
})

AddCustomShipment("P228", {
	model = "models/weapons/w_pist_p228.mdl",
	entity = "weapon_real_cs_p228",
	price = 600,
	amount = 10,
	seperate = true,
	pricesep = 600,
	noship = true,
	allowed = {TEAM_HECU, TEAM_HECUCOMMANDER}
})

AddCustomShipment("AK47", {
	model = "models/weapons/w_rif_ak47.mdl",
	entity = "weapon_real_cs_ak47",
	price = 1400,
	amount = 10,
	seperate = true,
	pricesep = 1400,
	noship = true,
	allowed = {TEAM_HECU, TEAM_HECUCOMMANDER}
})

AddCustomShipment("M4A1", {
	model = "models/weapons/w_rif_m4a1.mdl",
	entity = "weapon_real_cs_m4a1",
	price = 1400,
	amount = 10,
	seperate = true,
	pricesep = 1400,
	noship = true,
	allowed = {TEAM_HECU, TEAM_HECUCOMMANDER}
})

AddCustomShipment("Famas", {
	model = "models/weapons/w_rif_famas.mdl",
	entity = "weapon_real_cs_famas",
	price = 1150,
	amount = 10,
	seperate = true,
	pricesep = 1150,
	noship = true,
	allowed = {TEAM_HECU, TEAM_HECUCOMMANDER}
})

AddCustomShipment("MP5", {
	model = "models/weapons/w_smg_mp5.mdl",
	entity = "weapon_real_cs_mp5a5",
	price = 1000,
	amount = 10,
	seperate = true,
	pricesep = 1000,
	noship = true,
	allowed = {TEAM_HECU, TEAM_HECUCOMMANDER}
})


AddCustomShipment("Mac 10", {
	model = "models/weapons/w_smg_mac10.mdl",
	entity = "weapon_real_cs_mac10",
	price = 850,
	amount = 10,
	seperate = true,
	pricesep = 850,
	noship = true,
	allowed = {TEAM_HECU, TEAM_HECUCOMMANDER}
})

AddCustomShipment("Pump shotgun", {
	model = "models/weapons/w_shot_m3super90.mdl",
	entity = "weapon_real_cs_pumpshotgun",
	price = 1100,
	amount = 10,
	seperate = true,
	pricesep = 1100,
	noship = true,
	allowed = {TEAM_HECU, TEAM_HECUCOMMANDER, TEAM_SECURITYADMIN}
})

AddCustomShipment("Smoke Grenade", {
	model = "models/weapons/w_eq_smokegrenade.mdl",
	entity = "weapon_real_cs_smoke",
	price = 100,
	amount = 1,
	seperate = true,
	pricesep = 100,
	noship = true,
	allowed = {TEAM_HECU, TEAM_HECUCOMMANDER}
})

AddCustomShipment("Flashbang", {
	model = "models/weapons/w_eq_flashbang.mdl",
	entity = "weapon_real_cs_flash",
	price = 100,
	amount = 1,
	seperate = true,
	pricesep = 100,
	noship = true,
	allowed = {TEAM_HECU, TEAM_HECUCOMMANDER}
})

AddCustomShipment("Grenade", {
	model = "models/weapons/w_eq_fraggrenade.mdl",
	entity = "weapon_real_cs_grenade",
	price = 500,
	amount = 0,
	seperate = true,
	pricesep = 500,
	noship = true,
	allowed = {TEAM_HECU, TEAM_HECUCOMMANDER}
})


AddEntity("Computer", {
	ent = "sent_computer",
	model = "models/props_lab/monitor01a.mdl",
	price = 350,
	max = 100,
	cmd = "/buycomputer",
	allowed = TEAM_TECHNICIAN
})

AddEntity("Dumpster", {
	ent = "dumpster",
	model = "models/props_junk/TrashDumpster01a.mdl",
	price = 50,
	max = 5,
	cmd = "/buydumpster",
	allowed = TEAM_JANITOR
})

/*AddEntity("Drug lab", {
	ent = "drug_lab",
	model = "models/props_lab/crematorcase.mdl",
	price = 400,
	max = 3,
	cmd = "/buydruglab",
	allowed = {TEAM_GANG, TEAM_MOB}
})

AddEntity("Money printer", {
	ent = "money_printer",
	model = "models/props_c17/consolebox01a.mdl",
	price = 1000,
	max = 2,
	cmd = "/buymoneyprinter"
})

AddEntity("Gun lab", {
	ent = "gunlab",
	model = "models/props_c17/TrapPropeller_Engine.mdl",
	price = 500,
	max = 1,
	cmd = "/buygunlab",
	allowed = TEAM_HECU
})*/

-- ADD CUSTOM SHIPMENTS HERE(next line):
