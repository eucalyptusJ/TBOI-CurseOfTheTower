local darkOrb = {}
local enums = require("curseofthetower_scripts.enums")
local orbItem
local isSpawning
local playerTaken

local darkOrbData = {
    BASE_CHANCE = 35,
    CURR_CHANCE = 0
}

function darkOrb:findDarkOrbLocust()
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity:ToFamiliar() then
            if entity:ToFamiliar().SubType == enums.Collectibles.DARK_ORB then
                return true
            end
        end
    end
end

function darkOrb:onPlayerUpdate(player)
    if not player then return end
    if not playerTaken then
        playerTaken = player
    end
 
    if playerTaken:IsItemQueueEmpty() then
        isSpawning = false
        playerTaken = false
    return end

    if isSpawning == true then return end
    if player.QueuedItem.Item.ID == enums.Collectibles.DARK_ORB then
        isSpawning = true
        local spawnPosition = Isaac.GetFreeNearPosition(player.Position, 40)
        local seed = player:GetCollectibleRNG(enums.Collectibles.DARK_ORB)

        repeat
            orbItem = Game():GetItemPool():GetCollectible(seed:RandomInt(31))
        until Isaac.GetItemConfig():GetCollectible(orbItem).Quality == 4

        SFXManager():Play(SoundEffect.SOUND_SATAN_GROW)
        Game():Darken(1, 60)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, orbItem, spawnPosition, Vector(0,0), nil)
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, darkOrb.onPlayerUpdate)

function darkOrb:onCollectibleDecide(collectible, itemPool)
    local newCollectible = collectible
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(enums.Collectibles.DARK_ORB) then
            if Isaac.GetItemConfig():GetCollectible(collectible).Quality == 4 and isSpawning == false then -- Reroll q4
                newCollectible = Game():GetItemPool():GetCollectible(itemPool)
            elseif Isaac.GetItemConfig():GetCollectible(collectible).Quality == 3 then -- Reroll q3
                local seed = player:GetCollectibleRNG(enums.Collectibles.DARK_ORB)
                local roll = seed:RandomInt(100)

                darkOrbData.CURR_CHANCE = darkOrbData.BASE_CHANCE * (player:GetCollectibleNum(enums.Collectibles.DARK_ORB, true))

                if roll <= darkOrbData.CURR_CHANCE then
                    newCollectible = Game():GetItemPool():GetCollectible(itemPool)
                end
            end
            darkOrbData.CURR_CHANCE = darkOrbData.BASE_CHANCE
            return newCollectible
                           
        elseif Isaac.GetItemConfig():GetCollectible(collectible).Quality == 4 and isSpawning == false and darkOrb:findDarkOrbLocust() == true then -- Locust reroll q4 to q3
            repeat
                newCollectible = Game():GetItemPool():GetCollectible(itemPool)
            until Isaac.GetItemConfig():GetCollectible(newCollectible).Quality == 3
        end
        return newCollectible
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, darkOrb.onCollectibleDecide)
return darkOrb