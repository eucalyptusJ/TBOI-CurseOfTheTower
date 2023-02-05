local tarotBombs = {}
local enums = require("curseofthetower_scripts.enums")
local savedata = require("curseofthetower_scripts.savedata")

local cardsRollable = {}

local tarotBombsData = {
    BASE_CHANCE = 35,
    REMOVAL_CHANCE = 20,
    SPAWN_CHANCE = 10
}

for i = 1, 21 do -- 22 tarot cards exist
    cardsRollable[i] = i
end

function tarotBombs:onBombUpdate(bomb)
    if not bomb then return end
    local sprite = bomb:GetSprite()
    if not bomb.SpawnerEntity then return end
    local player = bomb.SpawnerEntity:ToPlayer()
    if not player then return end
    if player:HasCollectible(enums.Collectibles.TAROT_BOMBS) then
        if bomb.FrameCount == 1 and bomb.Variant == BombVariant.BOMB_NORMAL and player:HasGoldenBomb() then -- Gold
            sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/goldtarot2.png")
            sprite:LoadGraphics()
        elseif bomb.FrameCount == 1 and bomb.Variant == BombVariant.BOMB_NORMAL then -- Normal
            sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/tarot2.png")
            sprite:LoadGraphics()
        end
        
        if bomb.FrameCount == 10 and bomb.Variant == BombVariant.BOMB_NORMAL and player:HasGoldenBomb() then -- Gold
            sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/goldtarot_pulse.png")
            sprite:LoadGraphics()
        elseif bomb.FrameCount == 10 and bomb.Variant == BombVariant.BOMB_NORMAL then -- Normal
            sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/tarot_pulse.png")
            sprite:LoadGraphics()
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, tarotBombs.onBombUpdate)

function tarotBombs:onExplode(entity)
    if not entity then return end
    local player = entity.SpawnerEntity and entity.SpawnerEntity:ToPlayer()
    if not player then return end
    if player:HasCollectible(enums.Collectibles.TAROT_BOMBS) then

        if savedata.PersistentData.cardsSpawned == nil then
            savedata.PersistentData.cardsSpawned = 0
        end

        if entity:ToBomb().IsFetus == true then
            tarotBombsData.BASE_CHANCE = 5
            tarotBombsData.SPAWN_CHANCE = 2
        end

        local seed = player:GetCollectibleRNG(enums.Collectibles.TAROT_BOMBS)
        local roll = seed:RandomInt(100)
        local delRoll = seed:RandomInt(100)
        local spawnRoll = seed:RandomInt(100)

        local tarotExplode = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, entity.Position, Vector(0,0), nil)
        tarotExplode.Color = Color(8, 3, 4, 1)

        if roll <= tarotBombsData.BASE_CHANCE then
            local card = player:GetCard(0)
            if card > 0 and card < 22 then
                player:UseCard(card, 0)
                tarotExplode.Color = Color(8, 3, 9, 1)
            else return end

            if delRoll <= tarotBombsData.REMOVAL_CHANCE then
                player:SetCard(0, 0)
            end
        end

        if spawnRoll <= tarotBombsData.SPAWN_CHANCE and savedata.PersistentData.cardsSpawned < 10 then
            local card = seed:RandomInt(#cardsRollable)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card, entity.Position, Vector(0,0), nil)
            savedata.PersistentData.cardsSpawned = savedata.PersistentData.cardsSpawned + 1
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, tarotBombs.onExplode, EntityType.ENTITY_BOMB)

function tarotBombs:onNewStage()
    savedata.PersistentData.cardsSpawned = 0
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, tarotBombs.onNewStage)
return tarotBombs