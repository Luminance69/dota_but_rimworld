--[[
    Cargo Pods (apparel/weapons):
        A random item is dropped on a random location on the map.
]]
-- CreateItemOnPositionSync

return function()
    if not Incidents:CheckKarma(Incidents.karmas["cargo_pod"]) then return end

    -- God I fucking hate working with KV's, wtf is this garbage
    local tier = min(4, math.ceil(Incidents:CheckPowerLevel()))
    local types = {"Apparel", "Weapons"}
    local item_type = types[RandomInt(1, 2)]
    local item_types = LoadKeyValues("scripts/kv/item_names.txt")
    local item_tiers = item_types[item_type]
    local item_names = item_tiers[tostring(tier)]

    count = 0

    for _, _ in pairs(item_names) do
        count = count + 1
    end

    local item_name = item_names[tostring(RandomInt(1, count))]

    local item = CreateItem(item_name, nil, nil)

    local phys_item = CreateItemOnPositionSync(RandomVector(RandomInt(0, 7000)), item)

    SendLetterToAll({
        type = "CargoPod",
        targets = phys_item:GetEntityIndex(),
        special = {
            main = {
                item_type = item_type,
            }
        }
    })
end
