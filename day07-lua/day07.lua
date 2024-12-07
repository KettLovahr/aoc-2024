local function permute(list, t, v)
    local length = #list
    local combinations = v ^ (length - 1)
    for i = 0, combinations do
        local acc = list[1]
        local the_number = i
        for j = 1, length - 1 do
            if the_number % v == 0 then
                acc = acc + list[j + 1]
            elseif the_number % v == 1 then
                acc = acc * list[j + 1]
            else
                acc = tonumber(acc .. list[j + 1])
            end
            -- LuaJIT does not yet support the //
            -- operator, this will have to do
            the_number = math.floor(the_number / v)
        end
        if acc == t then
            return true
        end
    end
    return false
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

    if permute(nums, t, 2) then
        result = result + t
    end
    if permute(nums, t, 3) then
        result2 = result2 + t
    end
end

print(string.format("%.0f", result))
print(string.format("%.0f", result2))
