local function slice_n_dice(first, rest)
    local new_list = {first}
    for i = 3, #rest do
        table.insert(new_list, rest[i])
    end
    return new_list
end

local function recurse(list, target, ops)
    if #list > 1 then
        local add = slice_n_dice( list[1] + list[2], list )
        local mul = slice_n_dice( list[1] * list[2], list )
        if ops == 3 then
            local con = slice_n_dice( tonumber(list[1] .. list[2]), list )
            return recurse(add, target, ops)
                or recurse(mul, target, ops)
                or recurse(con, target, ops)
        end
        return recurse(add, target, ops) or recurse(mul, target, ops)
    else
        return list[1] == target
    end
end

local result = 0
local result2 = 0
for line in io.open("input"):lines() do
    local idx = 0
    local t
    local nums = {}

    for i in string.gmatch(line, "([^ ]+)") do
        if idx ~= 0 then
            table.insert(nums, tonumber(i))
        else
            t = tonumber(string.gsub(i, ":", ""), 10)
        end
        idx = idx + 1
    end

    if recurse(nums, t, 2) then
        result = result + t
        result2 = result2 + t
    elseif recurse(nums, t, 3) then
        result2 = result2 + t
    end
end

print(string.format("%.0f", result))
print(string.format("%.0f", result2))
