function class(name, base)
    local cls = {}
    cls.__index = cls
    cls.__name = name

    if base then
        setmetatable(cls, { __index = base })
        cls.super = base
    else
        cls.super = nil
    end

    function cls:new(...)
        local instance = setmetatable({}, cls)
        if instance.__construct then
            instance:__construct(...)
        end
        return instance
    end

    return cls
end
