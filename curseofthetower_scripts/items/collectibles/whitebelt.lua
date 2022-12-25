local whiteBelt = {}
local game = Game()
local enums = require("curseofthetower_scripts.enums")
local utility = require("curseofthetower_scripts.utility")

local whiteBeltData = {
    ENEMY_DEC = 0.15,
    BOSS_DEC = 0.05,
    DMG_DEC = 1
}

function whiteBelt:onPlayerUpdate(player)
    if not player then return end
   
    if player:HasCollectible(enums.Collectibles.WHITE_BELT) then
        for i, entity in pairs(Isaac.GetRoomEntities()) do
            if entity:IsEnemy() or entity:IsBoss() then
                local data = entity:GetData()
                local origEnemyHp = entity.MaxHitPoints

                if entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and entity:IsBoss() == false and data.whiteBeltDecreased ~= true then
                    entity.MaxHitPoints = entity.MaxHitPoints - (origEnemyHp * whiteBeltData.ENEMY_DEC)
                    entity.HitPoints = entity.MaxHitPoints
                    data.whiteBeltDecreased = true

                elseif entity:IsVulnerableEnemy() and entity:IsActiveEnemy() and entity:IsBoss() and data.whiteBeltDecreased ~= true then
                    entity.MaxHitPoints = entity.MaxHitPoints - (origEnemyHp * whiteBeltData.BOSS_DEC)
                    entity.HitPoints = entity.MaxHitPoints
                    data.whiteBeltDecreased = true
                end
            end
            if entity:IsEnemy() then -- Champion removal
                local oldEnemy = entity:ToNPC()
                if oldEnemy:IsChampion() then
                    Isaac.Spawn(oldEnemy.Type, oldEnemy.Variant, oldEnemy.SubType, oldEnemy.Position, oldEnemy.Velocity, oldEnemy.Parent)
                    oldEnemy:Remove()
                end
            end
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, whiteBelt.onPlayerUpdate)

function whiteBelt:onCache(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        if player:HasCollectible(enums.Collectibles.WHITE_BELT) then
            player.Damage = player.Damage - whiteBeltData.DMG_DEC
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, whiteBelt.onCache)

function whiteBelt:onFamiliarCollision(familiar, collider)
    if not collider then return end
    if familiar.SubType == enums.Collectibles.WHITE_BELT then
        if collider:IsVulnerableEnemy() and collider:IsActiveEnemy() and collider:ToNPC():IsChampion() then
            collider:Kill()
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_PRE_FAMILIAR_COLLISION, whiteBelt.onFamiliarCollision)
return whiteBelt