local mintyGum = {}
local enums = require("curseofthetower_scripts.enums")
local utility = require("curseofthetower_scripts.utility")

local mintyGumData = {
    BASE_CHANCE = 10,
    MAX_LUCK = 10
}

function mintyGum:onUpdate()
    for _, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_TEAR then
            local tearData = entity:GetData()
            local tear = entity:ToTear()
            local player = utility:findPlayerFromTear(tear)
            if not player then return end
            if player:HasTrinket(enums.Trinkets.MINTY_GUM) then
                if not tearData.isMinty then
                    -- Decide if tear will have the ice effect or not
                    local seed = player:GetTrinketRNG(enums.Trinkets.MINTY_GUM)
                    local roll = seed:RandomInt(100)

                    local multiplier = player:GetTrinketMultiplier(enums.Trinkets.MINTY_GUM)
                    local currentChance = mintyGumData.BASE_CHANCE * multiplier

                    -- Linear growth of probability with luck from basechance to 100%
                    if roll <= ((100 - currentChance) * player.Luck / mintyGumData.MAX_LUCK) + currentChance and tear.Variant ~= 4 and tear.Variant ~= 9 and tear.Variant ~= 41 then
                        tear:ChangeVariant(TearVariant.ICE)
                        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_ICE
                    else
                        tearData.isMinty = 0
                    end
                end
            end
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_UPDATE, mintyGum.onUpdate)
return mintyGum