local painKillers = {}
local enums = require("curseofthetower_scripts.enums")
local utility = require("curseofthetower_scripts.utility")

local pillsInRun = {}

function painKillers:onHit(entity, amount, flags, source)
    if not entity then return end
    if flags == 268443649 then return end -- Does not activate if the damage is taken from bad trip
    local player = entity:ToPlayer()
    if not player then return end

    if player:HasCollectible(enums.Collectibles.PAIN_KILLERS) then
        local seed = player:GetCollectibleRNG(enums.Collectibles.PAIN_KILLERS)
        local roll = seed:RandomInt(PillColor.NUM_STANDARD_PILLS) + 1 -- A roll of 0 throws an error
        
        if roll == 14 then -- Because we need to add 1 to the roll
            roll = 13
        end

        for i = 1, PillColor.NUM_STANDARD_PILLS - 1 do -- Create table with pills in current run
            pillsInRun[i] = Game():GetItemPool():GetPillEffect(i)
        end

        local pill = pillsInRun[roll]

        if pill == PillEffect.PILLEFFECT_BAD_TRIP or pill == PillEffect.PILLEFFECT_HEALTH_DOWN then
            pill = utility:convertKillingPills(player, pill, amount)
        end

        player:UsePill(pill, 0) -- 0 = useflag
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, painKillers.onHit, EntityType.ENTITY_PLAYER)
return painKillers