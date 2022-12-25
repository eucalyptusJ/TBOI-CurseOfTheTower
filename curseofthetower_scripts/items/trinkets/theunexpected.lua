local theUnexpected = {}
local enums = require("curseofthetower_scripts.enums")
local game = Game()

local theUnexpectedData = {
    BASE_CHANCE = 20,
    IS_DADS_NOTE = false
}

function theUnexpected:onItemDecide(collectible, itemPoolType)
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasTrinket(enums.Trinkets.THE_UNEXPECTED) then
            for i = 0, game:GetNumPlayers() - 1 do
                local player = Isaac.GetPlayer(i)
                local seed = player:GetTrinketRNG(enums.Trinkets.THE_UNEXPECTED)
                local roll = seed:RandomInt(100)

                local currentChance
                local multiplier = player:GetTrinketMultiplier(enums.Trinkets.THE_UNEXPECTED)
                currentChance = theUnexpectedData.BASE_CHANCE * multiplier

                if roll <= currentChance then
                    local item = seed:RandomInt(CollectibleType.NUM_COLLECTIBLES)
                    if item == 668 then
                        theUnexpectedData.IS_DADS_NOTE = true
                        return item
                    else
                        return item
                    end
                end
            end
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, theUnexpected.onItemDecide)

function theUnexpected:onPlayerUpdate()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasTrinket(enums.Trinkets.THE_UNEXPECTED) then
            if theUnexpectedData.IS_DADS_NOTE == true then
                for i, entity in pairs(Isaac.GetRoomEntities()) do
                    local itemPedestal = entity:ToPickup()
                    if itemPedestal then
                        if itemPedestal.SubType == CollectibleType.COLLECTIBLE_DADS_NOTE then
                            entity:AddEntityFlags(EntityFlag.FLAG_GLITCH)
                            theUnexpectedData.IS_DADS_NOTE = false
                        end
                    end
                end
            end
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, theUnexpected.onPlayerUpdate)
return theUnexpected