local function permute(list, target, op_count)
    local combinations = op_count ^ (#list - 1)
    for i = 0, combinations do
        local acc = list[1]
        local consumable = i
        for j = 1, #list - 1 do
            if consumable % op_count == 0 then
                acc = acc + list[j + 1]
            elseif consumable % op_count == 1 then
                acc = acc * list[j + 1]
            else
                acc = tonumber(acc .. list[j + 1])
            end
            -- LuaJIT does not yet support the //
            -- operator, this will have to do
            consumable = math.floor(consumable / op_count)
        end
        if acc == target then
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
        result2 = result2 + t
    elseif permute(nums, t, 3) then
        result2 = result2 + t
    end
end

print(string.format("%.0f", result))
print(string.format("%.0f", result2))
