local kerosene = {}
local game = Game()
local enums = require("curseofthetower_scripts.enums")
local utility = require("curseofthetower_scripts.utility")

local keroseneData = {
    BASE_CHANCE = 35,
    ENEMY_TINT = Color(0.15, 0.15, 0.15, 1, 0, 0, 0) -- Gish
}

function kerosene:onUse(item, rng, entity)
    if not entity then return end
    local player = entity:ToPlayer()
    if not player then return end
    player:AnimateCollectible(enums.Collectibles.KEROSENE, "Pickup", "PlayerPickupSparkle")
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity:GetData().KeroseneDoused == true or (entity:ToEffect() and entity:ToEffect().Variant == EffectVariant.PLAYER_CREEP_BLACK) then
            if utility:isJudasBirthright(player) then
                local judasIgnite = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, entity.Position, Vector(0,0), player):ToEffect()
                local sprite = judasIgnite:GetSprite()
                local color = Color(1, 1, 1, 1, 0, 0, 0)
                color:SetColorize(4, 0, 0, 1) -- Maybe change this color?
                sprite.Color = color
                local rift = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RIFT, 0, entity.Position, Vector(0,0), player):ToEffect()
                rift.Timeout = 180
            else
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, entity.Position, Vector(0,0), player)
            end
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_USE_ITEM, kerosene.onUse, enums.Collectibles.KEROSENE)

function kerosene:isGas(tear)
    local player = utility:findPlayerFromTear(tear)
    if not player then return end
    if player:GetActiveItem(0) == enums.Collectibles.KEROSENE or player:GetActiveItem(1) == enums.Collectibles.KEROSENE then
        if tear.Variant ~= 4 and tear.Variant ~= 9 and tear.Variant ~= 19 then
            local seed = player:GetCollectibleRNG(enums.Collectibles.KEROSENE)
            local roll = seed:RandomInt(100)
            if roll <= keroseneData.BASE_CHANCE then
                tear:ChangeVariant(TearVariant.EXPLOSIVO)
                tear.TearFlags = tear.TearFlags | TearFlags.TEAR_GISH
                tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SLOW
            end
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, kerosene.isGas)

function kerosene:onHit(tear, collider)
    if not collider then return end
    if collider:IsVulnerableEnemy() and collider:IsActiveEnemy() then
        if tear:HasTearFlags(TearFlags.TEAR_GISH) then
            collider:GetData().KeroseneDoused = true
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, kerosene.onHit)

function kerosene:onPlayerUpdate()
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity:HasEntityFlags(EntityFlag.FLAG_SLOW) == false
        and entity:GetData().KeroseneDoused == true
        then
            entity:GetData().KeroseneDoused = false
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, kerosene.onPlayerUpdate)
return kerosene