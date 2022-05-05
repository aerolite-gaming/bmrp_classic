SourceBans = SourceBans or {}

SourceBans.ServerID = "2"

SourceBans.Hostname = "127.0.0.1"
SourceBans.Username = "aerolitebans"
SourceBans.Password = "bA3t35Vm3zrwTyFd"
SourceBans.Database = "aerolitebans"
SourceBans.DBPort = 3306

SourceBans.CONNECTED_TO_MYSQL = nil
SourceBans.databaseObject = nil

function SourceBans.connectToMySQL()
	if (type(tmysql) != "table") then Error("MySQL modules aren't installed properly!") end

	local dbError
	SourceBans.databaseObject, dbError = tmysql.initialize(SourceBans.Hostname, SourceBans.Username, SourceBans.Password, SourceBans.Database, SourceBans.DBPort)

	if (dbError != nil) then
		Error("Connection to SourceBans database could not be established.")
		Error(dbError)
	else
		hook.Call("SourceBans_RetrieveAdmins", nil)
		hook.Call("SourceBans_RetrieveBans", nil)

		print("Connection to SourceBans database has been established.")
	end
end

hook.Add("DatabaseInitialized", "FAdmin_CreateMySQLTables", function()
	SourceBans.connectToMySQL()
end)

/*---------------------------------------------------------------------------
Store a ban in the MySQL tables
---------------------------------------------------------------------------*/

function SourceBans.BanSQL(ip, steam, nick, length, reason, adminid, adminip, serverid)
	SourceBans.databaseObject:Query("INSERT INTO sb_bans (ip, authid, name, created, ends, length, reason, aid, adminip, sid, type) VALUES (" .. ip .. ", " ..  MySQLite.SQLStr(steam) .. ", " .. nick .. ", UNIX_TIMESTAMP(), (UNIX_TIMESTAMP() + " .. length .. "), " .. length .. ", " .. reason .. ", " .. adminid .. ", " .. adminip .. ", " .. serverid .. ", 0);", function(results)
		if (results[1].status) then
			local adminname = IsValid(SourceBans.AdminList[adminid]) and SourceBans.AdminList[adminid].name or "Console"
			local adminsteam = IsValid(SourceBans.AdminList[adminid]) and SourceBans.AdminList[adminid].steamid or "STEAM_ID_SERVER"

			SourceBans.BANS[results[1].lastid] = {
				steamid = steam,
				name = nick,
				reason = reason,
				adminname = adminname,
				adminsteam = adminsteam,
				timestamp = os.time() + length,
				length = length
			}
		else
			print("SQL Error on SourceBans_StoreBan Query")
			print(ip, steam, nick, length, reason, adminid, adminip, serverid)
			PrintTable(results[1])
			return false
		end
	end)
end


hook.Add("SourceBans_StoreBan", "MySQLBans", function(ply, steamid, length, reason, admin, global)
	local ip = IsValid(ply) and ply:IsPlayer() and MySQLite.SQLStr(string.Explode(":", ply:IPAddress())[1]) or MySQLite.SQLStr("::1")
	local steam = steamid
	local nick = IsValid(ply) and ply:IsPlayer() and MySQLite.SQLStr(ply:Name()) or MySQLite.SQLStr("Unknown")
	local length = 	length * 60
	local reason = reason and MySQLite.SQLStr(reason) or MySQLite.SQLStr("Unknown")
	local adminid = 0
	local adminip =  IsValid(admin) and admin:IsPlayer() and MySQLite.SQLStr(string.Explode(":", admin:IPAddress())[1]) or MySQLite.SQLStr("::1")
	local serverid = global and 0 or SourceBans.ServerID

	if (IsValid(admin) and ply) then
		for k, v in pairs(SourceBans.AdminList) do
			if (v.steamid == admin:SteamID()) then
				adminid = k
			end
		end
		if (adminid == 0) then
			SourceBans.databaseObject:Query("INSERT INTO sb_admins (user, authid) VALUES (" .. MySQLite.SQLStr(admin:SteamName()) .. ", " .. MySQLite.SQLStr(admin:SteamID()) .. ");", function(results)
				if (results[1].status) then
					adminid = results[1].lastid
				end

				return SourceBans.BanSQL(ip, steam, nick, length, reason, adminid, adminip, serverid)
			end)
		end
	end

	return SourceBans.BanSQL(ip, steam, nick, length, reason, adminid, adminip, serverid)
end)

/*---------------------------------------------------------------------------
Unban someone
---------------------------------------------------------------------------*/
hook.Add("SourceBans_UnBan", "FAdmin_MySQLUnban", function(bid, admin, expired)
	local adminid = 0
	local type = expired and "E" or "U"

	if (IsValid(admin) and not expired) then
		for k, v in pairs(SourceBans.AdminList) do
			if (v.steamid == admin:SteamID()) then
				adminid = k
			end
		end

		if (adminid == 0) then
			SourceBans.databaseObject:Query("INSERT INTO sb_admins (user, authid) VALUES (" .. MySQLite.SQLStr(admin:SteamName()) .. ", " .. MySQLite.SQLStr(admin:SteamID()) .. ");", function(results)
				if (results[1].status) then
					adminid = results[1].lastid
				end
				
				SourceBans.BANS[bid] = nil
				SourceBans.databaseObject:Query("UPDATE sb_bans SET RemovedBy = " .. adminid .. ", RemoveType = " .. MySQLite.SQLStr(type) .. ", RemovedOn = 'UNIX_TIMESTAMP()' WHERE bid = " .. bid .. ";")
				return
			end)
		end
	end

	SourceBans.BANS[bid] = nil
	SourceBans.databaseObject:Query("UPDATE sb_bans SET RemovedBy = " .. adminid .. ", RemoveType = " .. MySQLite.SQLStr(type) .. ", RemovedOn = 'UNIX_TIMESTAMP()' WHERE bid = " .. bid .. ";")
end)


hook.Add("SourceBans_RetrieveAdmins", "getSourceBansAdmins", function()
	SourceBans.AdminList = {}

	SourceBans.databaseObject:Query("Select aid, user, authid FROM sb_admins;", function(results)
		if (results[1].status) then
			for k, v in pairs(results[1].data) do
				SourceBans.AdminList[v.aid] = {
					name = v.user,
					steamid = v.authid
				}
			end
		else
			ErrorNoHalt(results[1].error .. " (RetrieveSourceBans)")
		end
	end)
end)


hook.Add("SourceBans_RetrieveBans", "getMySQLBans", function()
	SourceBans.BANS = {}

	SourceBans.databaseObject:Query("SELECT bid, authid, name, created, ends, length, reason, aid FROM sb_bans WHERE RemovedBy IS NULL AND (sid = '0' OR sid = '" .. SourceBans.ServerID .. "');", function(results)
		if (results[1].status) then
			for k, v in pairs(results[1].data) do
				local adminname = IsValid(SourceBans.AdminList[v.aid]) and SourceBans.AdminList[v.aid].name or "Console"
				local adminsteam = IsValid(SourceBans.AdminList[v.aid]) and SourceBans.AdminList[v.aid].steamid or "STEAM_ID_SERVER"
				SourceBans.BANS[v.bid] = {
					steamid = v.authid,
					name = v.name,
					reason = v.reason,
					adminname = adminname,
					adminsteam = adminsteam,
					timestamp = v.ends,
					length = v.length
				}
			end
		else
			ErrorNoHalt(results[1].error .. " (RetrieveSourceBans)")
		end
	end)
end)