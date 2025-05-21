local Prepares = {}

local table_schema = [[
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    whitelist INT DEFAULT 0,
    priority INT DEFAULT 0,
    license VARCHAR(64) UNIQUE,
    name VARCHAR(50),
    money INT DEFAULT 1000,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
]]

local table_whitelist = [[
CREATE TABLE IF NOT EXISTS whitelist (
    license VARCHAR(64) PRIMARY KEY,
    name VARCHAR(50),
    priority INT DEFAULT 0,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
]]
local table_players = [[
CREATE TABLE IF NOT EXISTS players (
    id INT AUTO_INCREMENT PRIMARY KEY,
    license VARCHAR(64) UNIQUE,
    name VARCHAR(100),
    job VARCHAR(50) DEFAULT 'unemployed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
]]

local table_bans = [[
CREATE TABLE IF NOT EXISTS bans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    license VARCHAR(64),
    reason VARCHAR(255),
    banned_by VARCHAR(50),
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
]]

function InitDatabase()
    MySQL.query(table_schema)
    MySQL.query(table_whitelist)
    MySQL.query(table_players)
    MySQL.query(table_bans)
end

function GetUserData(license)
    local Low = FCore.Query("core:isAccount", {
        license = license
    })
    return Low[1]
end

function CreateUser(license, name)
    local p = promise.new()

    MySQL.insert('INSERT INTO users (license, name) VALUES (?, ?)', {license, name}, function(insertId)

        MySQL.query('SELECT * FROM users WHERE license = ?', {license}, function(res)
            p:resolve(res and res[1] or nil)
        end)
    end)

    return Citizen.Await(p)
end

function EnsureAccount(license, name)
    local p = promise.new()

    MySQL.query('SELECT * FROM users WHERE license = ?', {license}, function(res)
        if res and #res > 0 then
            p:resolve(res[1])
        else
            local account = CreateUser(license, name)
            p:resolve(account)
        end
    end)

    return Citizen.Await(p)
end

function FCore.Prepare(name, query)
    if not name or not query then
        print("^1[coreNova] Prepare: nome ou query inválida.^0")
        return
    end
    Prepares[name] = query or {}
end

function FCore.Execute(query) 
  local p = promise.new()

    MySQL.query(query, {}, function(result)
        p:resolve(result)
    end)

    return Citizen.Await(p)
end

function FCore.Query(name, params)
    local query = Prepares[name]
    if not query then
        print("^1[coreNova] Query: '" .. name .. "' não foi preparada.^0")
        return nil
    end

    local p = promise.new()

    MySQL.query(query, params or {}, function(result)
        p:resolve(result)
    end)

    return Citizen.Await(p)
end

exports('initDatabase', InitDatabase)
