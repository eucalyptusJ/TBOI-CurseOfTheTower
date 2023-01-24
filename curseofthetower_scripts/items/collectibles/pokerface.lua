local pokerFace = {}
local game = Game()
local enums = require("curseofthetower_scripts.enums")
local utility = require("curseofthetower_scripts.utility")

local pokerFaceData = {
    BASE_CHANCE = 1
}

local exclude = {
    TearVariant.BOBS_HEAD,
    TearVariant.CHAOS_CARD,
    TearVariant.KEY,
    TearVariant.KEY_BLOOD,
    TearVariant.SWORD_BEAM,
    TearVariant.TECH_SWORD_BEAM,
    TearVariant.ERASER,
    TearVariant.SPORE
}

function pokerFace:onHit(tear, collider, low)
    if not collider then return end
    if collider:IsVulnerableEnemy() and collider:IsActiveEnemy() then
        local player = utility:findPlayerFromTear(tear)
        if not player then return end
        if player:HasCollectible(enums.Collectibles.POKER_FACE) then -- or tear.SpawnerVariant == FamiliarVariant.INCUBUS or tear.SpawnerVariant == FamiliarVariant.FATES_REWARD then
            collider:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)

            local seed = player:GetCollectibleRNG(enums.Collectibles.POKER_FACE)
            local roll = seed:RandomInt(100)

            if roll == pokerFaceData.BASE_CHANCE and tear.Variant ~= TearVariant.CHAOS_CARD then
                local randomCard = game:GetItemPool():GetCard(Random() + 1, true, false, false)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, randomCard, collider.Position, Vector(0,0), nil)
            end
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, pokerFace.onHit)

function pokerFace:onTearInit(tear)
    if not tear then return end
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end
    if player:HasCollectible(enums.Collectibles.POKER_FACE) then
        local data = tear:GetData()
        local sprite = tear:GetSprite()
        if utility:hasValue(exclude, tear.Variant) == false then
            if data.isPokerFaceTear ~= true then
                sprite:ReplaceSpritesheet(0, "gfx/pokertears.png") -- Replace this with actual sheet
                sprite:LoadGraphics()
                data.isPokerFaceTear = true
            end
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, pokerFace.onTearInit)

function pokerFace:onFamiliarCollision(familiar, collider)
    if not collider then return end
    if collider:IsVulnerableEnemy() and collider:IsActiveEnemy() then
        local player = familiar.Player
        if not player then return end
        if familiar.SubType == enums.Collectibles.POKER_FACE then
            collider:AddEntityFlags(EntityFlag.FLAG_BLEED_OUT)

            local seed = player:GetCollectibleRNG(enums.Collectibles.POKER_FACE)
            local roll = seed:RandomInt(100)

            if roll == pokerFaceData.BASE_CHANCE then
                local randomCard = game:GetItemPool():GetCard(Random() + 1, true, false, false)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, randomCard, collider.Position, Vector(0,0), nil)
            end
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, pokerFace.onFamiliarCollision)
return pokerFace