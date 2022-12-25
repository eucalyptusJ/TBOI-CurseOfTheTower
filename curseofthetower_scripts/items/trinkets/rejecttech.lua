local rejectTech = {}
local enums = require("curseofthetower_scripts.enums")

local rejectTechData = {
    BASE_CHANCE = 10,
    MAX_LUCK = 15,
    DMG_MULTIPLIER = 1.2
}

function rejectTech:onTearInit(tear)
    if not tear then return end
    local player = tear.SpawnerEntity and tear.SpawnerEntity:ToPlayer()
    if not player then return end
    if player:HasTrinket(enums.Trinkets.REJECT_TECH) then
        local seed = player:GetTrinketRNG(enums.Trinkets.REJECT_TECH)
        local roll = seed:RandomInt(100)
        local multiplier = rejectTechData.DMG_MULTIPLIER * player:GetTrinketMultiplier(enums.Trinkets.REJECT_TECH)
        if roll <= ((100 - rejectTechData.BASE_CHANCE) * player.Luck / rejectTechData.MAX_LUCK) + rejectTechData.BASE_CHANCE then
            tear:Remove()
            player:FireTechLaser(player.Position, LaserOffset.LASER_TECH1_OFFSET, player:GetAimDirection(), false, false, player, multiplier)
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, rejectTech.onTearInit)
return rejectTech