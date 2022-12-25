local freeBlood = {}
local enums = require("curseofthetower_scripts.enums")

local freeBloodStats = {
    BASE_CHANCE = 10
}

--[[
local exclude = {
    DamageFlag.DAMAGE_CURSED_DOOR,
    DamageFlag.DAMAGE_IV_BAG,
    DamageFlag.DAMAGE_CHEST,
    DamageFlag.DAMAGE_NO_PENALTIES
}
]]

function freeBlood:onHit(entity, amount, useFlags)
    if not entity then return end
    local player = entity:ToPlayer()
    if not player then return end

    if player:HasTrinket(enums.Trinkets.FREE_BLOOD) then
        local seed = player:GetTrinketRNG(enums.Trinkets.FREE_BLOOD)
        local roll = seed:RandomInt(100)

        local currentChance
        local multiplier = player:GetTrinketMultiplier(enums.Trinkets.FREE_BLOOD)
        currentChance = freeBloodStats.BASE_CHANCE * multiplier
       
        if roll <= currentChance then
            if useFlags & DamageFlag.DAMAGE_IV_BAG ~= 0  or useFlags & DamageFlag.DAMAGE_CHEST ~= 0 or useFlags & DamageFlag.DAMAGE_CURSED_DOOR ~= 0 or useFlags & DamageFlag.DAMAGE_RED_HEARTS ~= 0 then
                return false
            end
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, freeBlood.onHit, EntityType.ENTITY_PLAYER)
return freeBlood