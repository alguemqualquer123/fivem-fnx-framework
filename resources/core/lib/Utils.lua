-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
SERVER = IsDuplicityVersion()
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCATEGORY
-----------------------------------------------------------------------------------------------------------------------------------------
function ClassCategory(Number)
    local Category = "B"

    if Number >= 100 and Number <= 200 then
        Category = "B+"
    elseif Number >= 201 and Number <= 350 then
        Category = "A"
    elseif Number >= 351 and Number <= 500 then
        Category = "A+"
    elseif Number >= 501 and Number <= 1000 then
        Category = "S"
    elseif Number >= 1001 then
        Category = "S+"
    end

    return Category
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SANGUINE
-----------------------------------------------------------------------------------------------------------------------------------------
function Sanguine(Number)
    local Types = {"A+", "B+", "A-", "B-"}

    return Types[Number]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLE.MAXN
-----------------------------------------------------------------------------------------------------------------------------------------
function table.maxn(Table)
    local Number = 0

    for Index, _ in pairs(Table) do
        local Next = tonumber(Index)
        if Next and Next > Number then
            Number = Next
        end
    end

    return Number
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COUNTTALBE
-----------------------------------------------------------------------------------------------------------------------------------------
function CountTable(Table)
    local Number = 0

    for _, v in pairs(Table) do
        Number = Number + 1
    end

    return Number
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MODULE
-----------------------------------------------------------------------------------------------------------------------------------------
-- local modules = {}

-- function module(resource, path)
--     if not path then
--         path = resource
--         resource = GetCurrentResourceName()
--     end

--     local key = ("%s/%s"):format(resource, path)

--     if modules[key] then
--         return modules[key]
--     end

--     local code = LoadResourceFile(resource, path .. ".lua")
--     if not code then
--         error(("Module not found: %s/%s.lua"):format(resource, path))
--     end

--     local chunk, err = load(code, key)
--     if not chunk then
--         error(("Failed to load module %s: %s"):format(key, err))
--     end

--     local success, result = pcall(chunk)
--     if not success then
--         error(("Error running module %s: %s"):format(key, result))
--     end

--     modules[key] = result or true

--     return modules[key]
-- end

-----------------------------------------------------------------------------------------------------------------------------------------
-- WAIT
-----------------------------------------------------------------------------------------------------------------------------------------
local function wait(self)
    local rets = Citizen.Await(self.p)
    if not rets then
        if self.r then
            rets = self.r
        end
    end

    return table.unpack(rets, 1, table.maxn(rets))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARETURN
-----------------------------------------------------------------------------------------------------------------------------------------
local function areturn(self, ...)
    self.r = {...}
    self.p:resolve(self.r)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSOLE.LOG
-----------------------------------------------------------------------------------------------------------------------------------------
console = {
    log = function(...)
        local msg = table.concat({...}, " ")
        print("^7[LOG] ^7" .. msg .. "^0")
    end,

    warn = function(...)
        local msg = table.concat({...}, " ")
        print("^3[WARN] ^3" .. msg .. "^0") -- amarelo
    end,

    error = function(...)
        local msg = table.concat({...}, " ")
        print("^1[ERROR] ^1" .. msg .. "^0") -- vermelho
    end,

    success = function(...)
        local msg = table.concat({...}, " ")
        print("^2[SUCCESS] ^2" .. msg .. "^0") -- verde
    end,

    debug = function(...)
        local msg = table.concat({...}, " ")
        print("^5[DEBUG] ^5" .. msg .. "^0") -- roxo
    end
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- ASYNC
-----------------------------------------------------------------------------------------------------------------------------------------
function async(func)
    if func then
        Citizen.CreateThreadNow(func)
    else
        return setmetatable({
            wait = wait,
            p = promise.new()
        }, {
            __call = areturn
        })
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PARSEINT
-----------------------------------------------------------------------------------------------------------------------------------------
function parseInt(Value)
    local Result = 0
    local Number = tonumber(Value)

    if Number and Number > 0 then
        Result = math.floor(Number)
    end

    return Result
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SANITIZESTRING
-----------------------------------------------------------------------------------------------------------------------------------------
local sanitize_tmp = {}
function sanitizeString(str, strchars, allow_policy)
    local r = ""
    local chars = sanitize_tmp[strchars]
    if not chars then
        chars = {}
        local size = string.len(strchars)
        for i = 1, size do
            local char = string.sub(strchars, i, i)
            chars[char] = true
        end

        sanitize_tmp[strchars] = chars
    end

    size = string.len(str)
    for i = 1, size do
        local char = string.sub(str, i, i)
        if (allow_policy and chars[char]) or (not allow_policy and not chars[char]) then
            r = r .. char
        end
    end

    return r
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPLITSTRING
-----------------------------------------------------------------------------------------------------------------------------------------
function splitString(Full, Symbol)
    local Table = {}

    if not Symbol then
        Symbol = "-"
    end

    for Full in string.gmatch(Full, "([^" .. Symbol .. "]+)") do
        Table[#Table + 1] = Full
    end

    return Table
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPLITONE
-----------------------------------------------------------------------------------------------------------------------------------------
function SplitOne(Name, Symbol)
    if not Symbol then
        Symbol = "-"
    end

    return splitString(Name, Symbol)[1]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPLITTWO
-----------------------------------------------------------------------------------------------------------------------------------------
function SplitTwo(Name, Symbol)
    if not Symbol then
        Symbol = "-"
    end

    return splitString(Name, Symbol)[2]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MATHLEGTH
-----------------------------------------------------------------------------------------------------------------------------------------
function mathLength(Number)
    return math.ceil(Number * 100) / 100
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARSEFORMAT
-----------------------------------------------------------------------------------------------------------------------------------------
function parseFormat(Value)
    local Value = parseInt(Value)
    local Left, Number, Right = string.match(Value, "^([^%d]*%d)(%d*)(.-)$")
    return Left .. (Number:reverse():gsub("(%d%d%d)", "%1."):reverse()) .. Right
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPLETETIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function CompleteTimers(Seconds)
    local Days = math.floor(Seconds / 86400)
    Seconds = Seconds - Days * 86400
    local Hours = math.floor(Seconds / 3600)
    Seconds = Seconds - Hours * 3600
    local Minutes = math.floor(Seconds / 60)
    Seconds = Seconds - Minutes * 60

    if Days > 0 then
        return string.format("<b>%d Dias</b>, <b>%d Horas</b>, <b>%d Minutos</b>", Days, Hours, Minutes)
    elseif Hours > 0 then
        return string.format("<b>%d Horas</b>, <b>%d Minutos</b> e <b>%d Segundos</b>", Hours, Minutes, Seconds)
    elseif Minutes > 0 then
        return string.format("<b>%d Minutos</b> e <b>%d Segundos</b>", Minutes, Seconds)
    elseif Seconds > 0 then
        return string.format("<b>%d Segundos</b>", Seconds)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINIMALTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function MinimalTimers(Seconds)
    local Days = math.floor(Seconds / 86400)
    Seconds = Seconds - Days * 86400
    local Hours = math.floor(Seconds / 3600)
    Seconds = Seconds - Hours * 3600
    local Minutes = math.floor(Seconds / 60)
    Seconds = Seconds - Minutes * 60

    if Days > 0 then
        return string.format("%d Dias, %d Horas", Days, Hours)
    elseif Hours > 0 then
        return string.format("%d Horas, %d Minutos", Hours, Minutes)
    elseif Minutes > 0 then
        return string.format("%d Minutos", Minutes)
    elseif Seconds > 0 then
        return string.format("%d Segundos", Seconds)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUMBERZERO
-----------------------------------------------------------------------------------------------------------------------------------------
function NumberZero(Number)
    if Number <= 9 then
        return "0" .. Number
    end

    return Number
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUMBERTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function NumberTimers(Seconds)
    local Days = math.floor(Seconds / 86400)
    Seconds = Seconds - Days * 86400
    local Hours = math.floor(Seconds / 3600)
    Seconds = Seconds - Hours * 3600
    local Minutes = math.floor(Seconds / 60)
    Seconds = Seconds - Minutes * 60

    return NumberZero(Days) .. ":" .. NumberZero(Hours) .. ":" .. NumberZero(Minutes) .. ":" .. NumberZero(Seconds)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BONES
-----------------------------------------------------------------------------------------------------------------------------------------
local Bones = {
    [11816] = "Pelvis",
    [58271] = "Coxa Esquerda",
    [63931] = "Panturrilha Esquerda",
    [14201] = "Pe Esquerdo",
    [2108] = "Dedo do Pe Esquerdo",
    [65245] = "Pe Esquerdo",
    [57717] = "Pe Esquerdo",
    [46078] = "Joelho Esquerdo",
    [51826] = "Coxa Direita",
    [36864] = "Panturrilha Direita",
    [52301] = "Pe Direito",
    [20781] = "Dedo do Pe Direito",
    [35502] = "Pe Direito",
    [24806] = "Pe Direito",
    [16335] = "Joelho Direito",
    [23639] = "Coxa Direita",
    [6442] = "Coxa Direita",
    [57597] = "Espinha Cervical",
    [23553] = "Espinha Toraxica",
    [24816] = "Espinha Lombar",
    [24817] = "Espinha Sacral",
    [24818] = "Espinha Cocciana",
    [64729] = "Escapula Esquerda",
    [45509] = "Braco Esquerdo",
    [61163] = "Antebraco Esquerdo",
    [18905] = "Mao Esquerda",
    [18905] = "Mao Esquerda",
    [26610] = "Dedo Esquerdo",
    [4089] = "Dedo Esquerdo",
    [4090] = "Dedo Esquerdo",
    [26611] = "Dedo Esquerdo",
    [4169] = "Dedo Esquerdo",
    [4170] = "Dedo Esquerdo",
    [26612] = "Dedo Esquerdo",
    [4185] = "Dedo Esquerdo",
    [4186] = "Dedo Esquerdo",
    [26613] = "Dedo Esquerdo",
    [4137] = "Dedo Esquerdo",
    [4138] = "Dedo Esquerdo",
    [26614] = "Dedo Esquerdo",
    [4153] = "Dedo Esquerdo",
    [4154] = "Dedo Esquerdo",
    [60309] = "Mao Esquerda",
    [36029] = "Mao Esquerda",
    [61007] = "Antebraco Esquerdo",
    [5232] = "Antebraco Esquerdo",
    [22711] = "Cotovelo Esquerdo",
    [10706] = "Escapula Direita",
    [40269] = "Braco Direito",
    [28252] = "Antebraco Direito",
    [57005] = "Mao Direita",
    [58866] = "Dedo Direito",
    [64016] = "Dedo Direito",
    [64017] = "Dedo Direito",
    [58867] = "Dedo Direito",
    [64096] = "Dedo Direito",
    [64097] = "Dedo Direito",
    [58868] = "Dedo Direito",
    [64112] = "Dedo Direito",
    [64113] = "Dedo Direito",
    [58869] = "Dedo Direito",
    [64064] = "Dedo Direito",
    [64065] = "Dedo Direito",
    [58870] = "Dedo Direito",
    [64080] = "Dedo Direito",
    [64081] = "Dedo Direito",
    [28422] = "Mao Direita",
    [6286] = "Mao Direita",
    [43810] = "Antebraço Direito",
    [37119] = "Antebraço Direito",
    [2992] = "Cotovelo Direito",
    [39317] = "Pescoco",
    [31086] = "Cabeca",
    [12844] = "Cabeca",
    [65068] = "Rosto"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BONE
-----------------------------------------------------------------------------------------------------------------------------------------
function Bone(Number)
    return Bones[Number] or false
end
