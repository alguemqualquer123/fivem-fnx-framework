local table_schema = [[
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
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
    MySQL.query(table_players, {}, function()
        print("[CoreNova] Banco de dados atualizado.")
    end)
    MySQL.query(table_bans, {}, function()
        print("[CoreNova] Banco de dados preparado.")
    end)
end

exports('initDatabase', InitDatabase)

function GetUserData(license)
    return promise.new(function(resolve, reject)
        MySQL.query('SELECT * FROM users WHERE license = ?', { license }, function(result)
            if result and result[1] then
                resolve(result[1])
            else
                resolve(nil)
            end
        end)
    end)
end

function CreateUser(license, name)
    MySQL.insert('INSERT INTO users (license, name) VALUES (?, ?)', { license, name })
end
