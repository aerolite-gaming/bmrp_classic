local debug = debug
local error = error
local Error = Error
local ErrorNoHalt = ErrorNoHalt
local hook = hook
local include = include
local pairs = pairs
local require = require
local sql = sql
local table = table
local timer = timer
local tostring = tostring
local print = print
local GAMEMODE = GM

local RP_MySQLConfig = RP_MySQLConfig

require("tmysql4")
MySQLite = MySQLite or {}

function MySQLite.initialize()
	if RP_MySQLConfig.EnableMySQL then
		timer.Simple(1, function()
			MySQLite.connectToMySQL(RP_MySQLConfig.Host, RP_MySQLConfig.Username, RP_MySQLConfig.Password, RP_MySQLConfig.Database_name, RP_MySQLConfig.Database_port)
		end)
	else
		timer.Simple(0, function()
			GAMEMODE.DatabaseInitialized = GAMEMODE.DatabaseInitialized or function() end
			hook.Call("DatabaseInitialized", GAMEMODE)
		end)
	end
end

CONNECTED_TO_MYSQL = false
databaseObject = nil


local queuedQueries

function MySQLite.begin()
	if not CONNECTED_TO_MYSQL then
		sql.Begin()
	else
		if queuedQueries then
			debug.Trace()
			error("Transaction ongoing!")
		end
		queuedQueries = {}
	end
end

function MySQLite.commit(onFinished)
	if not CONNECTED_TO_MYSQL then
		sql.Commit()
		if onFinished then onFinished() end
		return
	end

	if not queuedQueries then
		error("No queued queries! Call begin() first!")
	end

	if #queuedQueries == 0 then
		queuedQueries = nil
		return
	end

	-- Copy the table so other scripts can create their own queue
	local queue = table.Copy(queuedQueries)
	queuedQueries = nil

	-- Handle queued queries in order
	local queuePos = 0
	local call

	-- Recursion invariant: queuePos > 0 and queue[queuePos] <= #queue
	call = function(...)
		queuePos = queuePos + 1

		if queue[queuePos].callback then
			queue[queuePos].callback(...)
		end

		-- Base case, end of the queue
		if queuePos + 1 > #queue then
			if onFinished then onFinished() end -- All queries have finished
			return
		end

		-- Recursion
		local nextQuery = queue[queuePos + 1]
		MySQLite.query(nextQuery.query, call, nextQuery.onError)
	end

	MySQLite.query(queue[1].query, call, queue[1].onError)
end

function MySQLite.queueQuery(sqlText, callback, errorCallback)
	if CONNECTED_TO_MYSQL then
		table.insert(queuedQueries, {query = sqlText, callback = callback, onError = errorCallback})
	end
	-- SQLite is instantaneous, simply running the query is equal to queueing it
	MySQLite.query(sqlText, callback, errorCallback)
end

function MySQLite.query(sqlText, callback, errorCallback)
	if CONNECTED_TO_MYSQL and databaseObject then
		databaseObject:Query(sqlText, function(results)
			if (results[1].status) then
				if (callback) then callback(results[1].data, results[1].lastid) end
			else
				if not (type(databaseObject) == "Database") then
					table.insert(cachedQueries, {sqlText, callback, false})
					return
				end

				if errorCallback then errorCallback() end

				ErrorNoHalt(results[1].error .. " (" .. sqlText .. ")\n")
			end
		end)
		return
	end

	local lastError = sql.LastError()
	local Result = sql.Query(sqlText)
	if sql.LastError() and sql.LastError() ~= lastError then
		error("SQLite error: " .. sql.LastError())
	end

	if callback then callback(Result) end
	return Result
end

function MySQLite.queryValue(sqlText, callback, errorCallback)
	if CONNECTED_TO_MYSQL and databaseObject then
		databaseObject:Query(sqlText, function(results)
			if (results[1].status) then
				if callback then
					for k, v in pairs(results[1].data or {}) do
						for k2, v2 in pairs(v) do
							callback(v2)
							return
						end
					end
					callback()
				end
			else
				if not (type(databaseObject) == "Database") then
					table.insert(cachedQueries, {sqlText, callback, false})
					return
				end

				if errorCallback then errorCallback() end

				ErrorNoHalt(results[1].error .. " (" .. sqlText .. ")\n")
			end
		end)
		return
	end

	local lastError = sql.LastError()
	local val = sql.QueryValue(sqlText)
	if sql.LastError() and sql.LastError() ~= lastError then
		error("SQLite error: " .. sql.LastError())
	end

	if callback then callback(val) end
	return val
end

function MySQLite.connectToMySQL(host, username, password, database_name, database_port)
	if (type(tmysql) != "table") then Error("MySQL modules aren't installed properly!") end

	local dbError
	databaseObject, dbError = tmysql.initialize(host, username, password, database_name, database_port)

	if (dbError != nil) then
		Error("Connection to database could not be established.")
		Error(dbError)
	else
		CONNECTED_TO_MYSQL = true
		if cachedQueries then
			for _, v in pairs(cachedQueries) do
				if v[3] then
					queryValue(v[1], v[2])
				else
					query(v[1], v[2])
				end
			end
		end
		cachedQueries = {}

		hook.Call("DatabaseInitialized")

		print("Connection to database has been established.")
	end
end

function MySQLite.SQLStr(str)
	if not CONNECTED_TO_MYSQL then
		return sql.SQLStr(str)
	end

	return "\"" .. databaseObject:Escape(tostring(str)) .. "\""
end