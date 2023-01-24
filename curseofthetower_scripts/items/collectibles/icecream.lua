local iceCream = {}
local enums = require("curseofthetower_scripts.enums")
local utility = require("curseofthetower_scripts.utility")

local iceCreamData = {
    TEAR_TRAIL_TIMEOUT = 20,
    TEAR_IMPACT_PUDDLE_TIMEOUT = 60,
    CIRCLE_LASER_TRAIL_TIMEOUT = 20,
    FETUS_IMPACT_PUDDLE_TIMEOUT = 999999999,
    FETUS_EXPLOSION_PUDDLE_SCALE = 1.8,
    SHOTSPEED_DEC = 0.20,
    RANGE_DEC = 0.50 * 40,
    CREEP_COLOR = Color(5, 1, 1, 1, 0, 0, 0),
    TEAR_COLOR = Color(5, 1, 1, 1, 0, 0, 0),
    GREEN_TEAR_COLOR = Color(1, 1, 1, 1, 0, 0.2, 0) -- Mysterious Liquid
}

function iceCream:spawnIceCreamCreep(target, timeout, entity, player) -- Used to spawn the creep and decide its color
    local variant, anm
  
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID) then
        variant = EffectVariant.PLAYER_CREEP_GREEN
        anm = "1000.023_creep (green).anm2"
    else
        variant = EffectVariant.PLAYER_CREEP_RED
        anm = "1000.023_creep (red).anm2"
    end

    local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, variant, 0, target, Vector(0,0), nil):ToEffect()
    if entity then
        if entity.Type == EntityType.ENTITY_BOMB then -- Dr. Fetus explosion
            creep.Scale = iceCreamData.FETUS_EXPLOSION_PUDDLE_SCALE
        else
            creep.Scale = entity.Scale
        end
    end

    if player:HasTrinket(TrinketType.TRINKET_LOST_CORK) then -- Lost cork synergy
        creep.Scale = creep.Scale * 2
    end

    local sprite = creep:GetSprite()
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID) then
        sprite:Load(anm)
    else
        sprite:Load(anm)
        iceCreamData.CREEP_COLOR:SetColorize(3, 1, 1, 1)
        sprite.Color = iceCreamData.CREEP_COLOR
    end
    creep:SetTimeout(timeout)
end

function iceCream:onTearUpdate(tear) -- Regular tear trails
    local player = utility:findPlayerFromTear(tear)
    if not player then return end
    if player:HasCollectible(enums.Collectibles.ICE_CREAM) then
        if Game():GetFrameCount() % 2 == 0 then
            iceCream:spawnIceCreamCreep(tear.Position, iceCreamData.TEAR_TRAIL_TIMEOUT, tear, player)
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, iceCream.onTearUpdate)

function iceCream:onTearCollision(tear, collider, low) -- Tears colliding with enemies
    if not collider then return end
    local player = utility:findPlayerFromTear(tear)
    if not player then return end
    if player:HasCollectible(enums.Collectibles.ICE_CREAM) then
        iceCream:spawnIceCreamCreep(collider.Position, iceCreamData.TEAR_TRAIL_TIMEOUT, nil, player)
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, iceCream.onTearCollision)

function iceCream:onCache(player, cacheFlag)
    if not player then return end

    if player:HasCollectible(enums.Collectibles.ICE_CREAM) then

        if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed - iceCreamData.SHOTSPEED_DEC
        end

        if cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange - iceCreamData.RANGE_DEC
        end

        if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = iceCreamData.TEAR_COLOR
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, iceCream.onCache)

-- Synergies

function iceCream:onPlayerUpdate(player) -- Dr. Fetus
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        local bomb = entity:ToBomb()
        if bomb and bomb.IsFetus == true then
            player = entity.SpawnerEntity:ToPlayer()
            if not player then return end

            if player:HasCollectible(enums.Collectibles.ICE_CREAM) and Game():GetFrameCount() % 2 == 0 then
                iceCream:spawnIceCreamCreep(bomb.Position, iceCreamData.TEAR_TRAIL_TIMEOUT, nil, player)
            end
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, iceCream.onPlayerUpdate)

function iceCream:onKnifeUpdate(knife) -- Mom's knife, forgotten's bone, etc
    local player = utility:findPlayerFromTear(knife)
    if not player then return end
    if player:HasCollectible(enums.Collectibles.ICE_CREAM) then
        if Game():GetFrameCount() % 2 == 0 and knife:IsFlying() then
            iceCream:spawnIceCreamCreep(knife.Position, iceCreamData.TEAR_TRAIL_TIMEOUT, nil, player)
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, iceCream.onKnifeUpdate)

function iceCream:onLaserUpdate(laser) -- Lasers
    if not laser then return end
    local parent = laser.Parent
    if not parent then return end

    local player

    if parent.Type == EntityType.ENTITY_PLAYER then -- Regular case
        player = parent:ToPlayer()

    elseif parent.Type == EntityType.ENTITY_EFFECT then -- Anti-Gravity
        local effect = parent:ToEffect()
        player = effect.SpawnerEntity:ToPlayer()

    elseif parent.Type == EntityType.ENTITY_LASER then -- Multishot
        player = parent.Parent:ToPlayer()

    elseif parent.Type == EntityType.ENTITY_FAMILIAR then -- Incubus and twisted pair

        if parent.FamiliarVariant ~= FamiliarVariant.INCUBUS
        and parent.FamiliarVariant ~= FamiliarVariant.FATES_REWARD
        and parent.FamiliarVariant ~= FamiliarVariant.TWISTED_BABY
        then return end

        player = parent:ToFamiliar().Player
    end

    if not player then return end

    if player:HasCollectible(enums.Collectibles.ICE_CREAM) then
        local sprite =  laser:GetSprite()

        if player:HasCollectible(CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID) then
            iceCreamData.GREEN_TEAR_COLOR:SetColorize(1, 3, 1, 1)
            sprite.Color = iceCreamData.GREEN_TEAR_COLOR
        else
            iceCreamData.TEAR_COLOR:SetColorize(3, 1, 1, 1)
            sprite.Color = iceCreamData.TEAR_COLOR
        end

        if laser.FrameCount % 4 == 0 or laser.FrameCount == 1 then
            local samplePoints = laser:GetNonOptimizedSamples()
            for i = 0, #samplePoints - 1 do
                local pos = samplePoints:Get(i)
                iceCream:spawnIceCreamCreep(pos, iceCreamData.CIRCLE_LASER_TRAIL_TIMEOUT, nil, player)
            end
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, iceCream.onLaserUpdate)

function iceCream:onEffectUpdate(effect) -- Brimstone swirls
    if not effect.SpawnerEntity then return end
    local player = effect.SpawnerEntity:ToPlayer()
    if not player then return end
    if player:HasCollectible(enums.Collectibles.ICE_CREAM) and effect.Variant == EffectVariant.BRIMSTONE_SWIRL then
        local sprite = effect:GetSprite()
        if player:HasCollectible(CollectibleType.COLLECTIBLE_MYSTERIOUS_LIQUID) then
            iceCreamData.GREEN_TEAR_COLOR:SetColorize(1, 3, 1, 1)
            sprite.Color = iceCreamData.GREEN_TEAR_COLOR
        else
            iceCreamData.TEAR_COLOR:SetColorize(3, 1, 1, 1)
            sprite.Color = iceCreamData.TEAR_COLOR
        end
        iceCream:spawnIceCreamCreep(effect.Position, iceCreamData.CIRCLE_LASER_TRAIL_TIMEOUT, nil, player)
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, iceCream.onEffectUpdate)

function iceCream:onEntityRemove(entity) -- Dr. Fetus explosion
    if not entity then return end
    if not entity.SpawnerEntity then return end
    local player = entity.SpawnerEntity:ToPlayer()
    if not player then return end

    local bomb = entity:ToBomb()

    if player:HasCollectible(enums.Collectibles.ICE_CREAM) then
        if bomb.IsFetus then
            iceCream:spawnIceCreamCreep(bomb.Position, iceCreamData.FETUS_IMPACT_PUDDLE_TIMEOUT, entity, player)
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, iceCream.onEntityRemove, EntityType.ENTITY_BOMB)

function iceCream:onFamiliarUpdate(familiar) -- Abyss locust
    if not familiar then return end
    if familiar.SubType == enums.Collectibles.ICE_CREAM then
        iceCream:spawnIceCreamCreep(familiar.Position, iceCreamData.TEAR_TRAIL_TIMEOUT, nil, familiar.Player)
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, iceCream.onFamiliarUpdate)
return iceCream