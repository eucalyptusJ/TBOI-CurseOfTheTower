local hexOfTheTower = {}
local enums = require("curseofthetower_scripts.enums")
local savedata = require("curseofthetower_scripts.savedata")

local hexOfTheTowerData = {
    CHANCE = 10
}

function hexOfTheTower:onPlayerInit(player) -- Decide if Hex of The Tower will replace Curse of The Tower, per run
    if player == nil then return end
    local rng = player:GetCollectibleRNG(enums.Collectibles.HEX_OF_THE_TOWER)
    local roll = rng:RandomInt(100)
    if roll <= hexOfTheTowerData.CHANCE then
        savedata.PersistentData.hexOfTheTower = true
    else
        savedata.PersistentData.hexOfTheTower = false
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, hexOfTheTower.onPlayerInit)

function hexOfTheTower:getCollectible(collectible)
    if collectible == CollectibleType.COLLECTIBLE_CURSE_OF_THE_TOWER and savedata.PersistentData.hexOfTheTower == true then
        return enums.Collectibles.HEX_OF_THE_TOWER
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, hexOfTheTower.getCollectible)

function hexOfTheTower:onDeath(npc)
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(enums.Collectibles.HEX_OF_THE_TOWER) then
            local bombCount = 1 * (player:GetCollectibleNum(enums.Collectibles.HEX_OF_THE_TOWER, true))
            local entity = EntityRef(npc)
            for i = 1, bombCount do
                if npc:IsBoss() then
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_SUPERTROLL, entity.Position, Vector(0,0), nil)
                else
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_TROLL, entity.Position, Vector(0,0), nil)
                end
            end
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, hexOfTheTower.onDeath)

function hexOfTheTower:onHit(entity, amount, flags, source)
    if not entity then return end
    if not source then return end
    if not source.Entity then return end
    local familiar = source.Entity:ToFamiliar()
    if not familiar then return end
    if familiar.SubType == enums.Collectibles.HEX_OF_THE_TOWER and entity.HitPoints <= amount then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_TROLL, entity.Position, Vector(0,0), nil)
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, hexOfTheTower.onHit)
return hexOfTheTower