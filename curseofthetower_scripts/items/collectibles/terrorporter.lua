local terrorporter = {}
local enums = require("curseofthetower_scripts.enums")
local utility = require("curseofthetower_scripts.utility")
local target, playerUsed -- playedUsed is a temporary solution to player becoming nil when passed to scheduler
local terrorportHappening = false

local terrorporterData = {
    TELEPORT_ANIM_LENGTH = 19,
    MOVE_DELAY = 30
}

function terrorporter:beginTeleport(player)
    playerUsed:AnimateTeleport(false)
    playerUsed.Position = target.Position
end

function terrorporter:movePlayer(player)
    if utility:isJudasBirthright(playerUsed) then
        Isaac.Explode(target.Position, playerUsed, (40 + (playerUsed.Damage * 3)))
        for i = 0, 7 do
            Isaac.GetFreeNearPosition(playerUsed.Position, 15)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, playerUsed.Position, Vector(5,0):Rotated(i * 45), playerUsed)
        end
    else
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0, playerUsed.Position, Vector.Zero, playerUsed)
        SFXManager():Play(SoundEffect.SOUND_DEATH_BURST_LARGE)
        target:TakeDamage(40 + (playerUsed.Damage * 3), DamageFlag.DAMAGE_TIMER, EntityRef(playerUsed), 0)
    end
  
    if playerUsed:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES) then
        --playerUsed:AddWisp(enums.Collectibles.TERRORPORTER, playerUsed.Position, false, false)
        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.WISP, enums.Collectibles.TERRORPORTER, target.Position, Vector.Zero, playerUsed):ToFamiliar():RemoveFromOrbit()
    end

    target = nil
    playerUsed.ControlsEnabled = true
    terrorportHappening = false
end

function terrorporter:preUse(item, rng, player, flags, activeSlot)
    if not player then return true end
    if terrorportHappening == true then return true end
    terrorportHappening = true
    target = utility:getClosestEnemy(player, 9999)
    if not target then return true end
end
curseTowerMod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, terrorporter.preUse, enums.Collectibles.TERRORPORTER)

function terrorporter:onNewRoom()
    if terrorportHappening == true then
        terrorportHappening = false
    end
    
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.SubType == enums.Collectibles.TERRORPORTER then
            entity:Remove()
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, terrorporter.onNewRoom)

function terrorporter:onUse(item, rng, player)
    if not player then return end
    player:SetMinDamageCooldown(120)
    player.ControlsEnabled = false
    player:AnimateTeleport(true)
    playerUsed = player
    curseTowerMod.Schedule(terrorporterData.TELEPORT_ANIM_LENGTH, terrorporter.beginTeleport, {player})
    curseTowerMod.Schedule(terrorporterData.MOVE_DELAY, terrorporter.movePlayer, {player})
end
curseTowerMod:AddCallback(ModCallbacks.MC_USE_ITEM, terrorporter.onUse, enums.Collectibles.TERRORPORTER)

function terrorporter:onGameExitOrContinue()
    if terrorportHappening then
        terrorportHappening = false
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, terrorporter.onGameExitOrContinue)
curseTowerMod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, terrorporter.onGameExitOrContinue)
return terrorporter