local IDManager = {}
IDManager.__index = IDManager

function IDManager:new()
    local obj = setmetatable({}, self)
    obj:clear()
    return obj
end

function IDManager:clear()
    self.max = 0
    self.ids = {}
end

function IDManager:gen()
    if #self.ids > 0 then
        return table.remove(self.ids)
    else
        local r = self.max
        self.max = self.max + 1
        return r
    end
end

function IDManager:free(id)
    table.insert(self.ids, id)
end

return IDManager
