--- Dual Universe Schematics Monitor v2.1
--- Created by Zrips.
--- DateTime: 2022-10-06 11:03
--- Updated by Vtreka#1337
--- LastUpdate: 2023-03-11 06:37

system.print(" --- Schematics Bank v2.1 ---")

mceil = math.ceil
smatch = string.match
ssub = string.sub

local concat = table.concat
local function internalSerialize(table, tC, t)
    t[tC] = "{"
    tC = tC + 1
    if #table == 0 then
        local hasValue = false
        for key, value in pairs(table) do
            hasValue = true
            local keyType = type(key)
            if keyType == "string" then
                t[tC] = key .. "="
            elseif keyType == "number" then
                t[tC] = "[" .. key .. "]="
            elseif keyType == "boolean" then
                t[tC] = "[" .. tostring(key) .. "]="
            else
                t[tC] = "notsupported="
            end
            tC = tC + 1

            local check = type(value)
            if check == "table" then
                tC = internalSerialize(value, tC, t)
            elseif check == "string" then
                t[tC] = '"' .. value .. '"'
            elseif check == "number" then
                t[tC] = value
            elseif check == "boolean" then
                t[tC] = tostring(value)
            else
                t[tC] = '"Not Supported"'
            end
            t[tC + 1] = ","
            tC = tC + 2
        end
        if hasValue then
            tC = tC - 1
        end
    else
        for i = 1, #table do
            local value = table[i]
            local check = type(value)
            if check == "table" then
                tC = internalSerialize(value, tC, t)
            elseif check == "string" then
                t[tC] = '"' .. value .. '"'
            elseif check == "number" then
                t[tC] = value
            elseif check == "boolean" then
                t[tC] = tostring(value)
            else
                t[tC] = '"Not Supported"'
            end
            t[tC + 1] = ","
            tC = tC + 2
        end
        tC = tC - 1
    end
    t[tC] = "}"
    return tC
end

function serialize(value)
    local t = {}
    local check = type(value)

    if check == "table" then
        internalSerialize(value, 1, t)
    elseif check == "string" then
        return '"' .. value .. '"'
    elseif check == "number" then
        return value
    elseif check == "boolean" then
        return tostring(value)
    else
        return '"Not Supported"'
    end

    return concat(t)
end

function deserialize(s)
    return load("return " .. s)()
end