-- Luapress
-- File: lib/table_to_lua.lua
-- Desc: helper to convert a table object into a Lua string
-- Originally from: https://github.com/Fizzadar/Lua-Bits/blob/master/tableToLuaFile.lua


-- Takes a Lua table object and outputs a Lua string
local function table_to_lua(table, indent)
    indent = indent or 1
    local out = ''

    for k, v in pairs(table) do
        out = out .. '\n'
        for i = 1, indent * 4 do
            out = out .. ' '
        end
        -- Create local copies to modify, leaving the loop 'k' and 'v' untouched
        local current_k = k
        local current_v = v
        if type(current_v) == 'table' then
            if type(current_k) == 'string' and current_k:find('%.') then
                out = out .. '[\'' .. current_k .. '\'] = ' .. table_to_lua(current_v, indent + 1)
            else
                out = out .. current_k .. ' = ' .. table_to_lua(current_v, indent + 1)
            end
            out = out .. ','
        else
            if type(current_v) == 'string' then current_v = "'" .. current_v .. "'" end
            if type(current_v) == 'boolean' then current_v = tostring(current_v) end
            
            -- Fix: Assigning to current_k instead of the loop variable k
            if type(current_k) == 'number' then 
                current_k = '' 
            else 
                current_k = current_k .. ' = ' 
            end
            
            out = out .. current_k .. current_v .. ','
        end
    end

    -- Strip final commas (optional, ofc!)
    out = out:sub(0, out:len() - 1)

    -- Ensure the final } lines up with any indent
    out = '{' .. out .. '\n'
    if indent > 1 then
        for i = 1, (indent - 1) * 4 do
            out = out .. ' '
        end
    end

    return out .. '}'
end


-- Export
return table_to_lua
