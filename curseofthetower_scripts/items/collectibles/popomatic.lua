local popOmatic = {}
local enums = require("curseofthetower_scripts.enums")
local utility = require("curseofthetower_scripts.utility")

function popOmatic:onHit(entity)
    if not entity then return end
    local player = entity:ToPlayer()
    if not player then return end
 
    if player:HasCollectible(enums.Collectibles.POP_O_MATIC) then
        SFXManager():Play(SoundEffect.SOUND_EDEN_GLITCH)

        local seed = player:GetCollectibleRNG(enums.Collectibles.POP_O_MATIC)
        local roll = seed:RandomInt(100)
        local rollSpecial = seed:RandomInt(100)

        if roll >= 50 and rollSpecial > 1 then
            player:UseActiveItem(CollectibleType.COLLECTIBLE_D12)

        elseif roll <= 50 and rollSpecial > 1 then 
            player:UseActiveItem(CollectibleType.COLLECTIBLE_D10)
            
        elseif rollSpecial == 1 then
            player:UseActiveItem(CollectibleType.COLLECTIBLE_D100)
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, popOmatic.onHit, EntityType.ENTITY_PLAYER)
return popOmatic