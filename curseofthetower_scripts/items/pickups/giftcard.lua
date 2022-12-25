local giftCard = {}
local enums = require("curseofthetower_scripts.enums")
local giftCardUsed

-- local giftCardData = {
--     TIMES_ACTIVATED = 0
-- }

function giftCard:onUse(_CardEffect, player, useFlags)
    if not player then return end
    giftCardUsed = true
    local seed = player:GetCardRNG(enums.Cards.GIFT_CARD)
    local roll = seed:RandomInt(100)

    if Options.AnnouncerVoiceMode == 2 or Options.AnnouncerVoiceMode == 0 and roll <= 50 then
        SFXManager():Play(enums.Sounds.VOICE_GIFT_CARD, 3)
    end

    for i, entity in pairs(Isaac.GetRoomEntities()) do
        local pickup = entity:ToPickup()
        if pickup then
            if giftCardUsed == true then
                local data = pickup:GetData()
                if data.GiftCardDecreased ~= true then
                    pickup.AutoUpdatePrice = false
                    if pickup.Price > 1 then
                        pickup.Price = math.floor(pickup.Price / 2)
                    elseif pickup.Price == PickupPrice.PRICE_TWO_HEARTS then
                        pickup.Price = PickupPrice.PRICE_ONE_HEART
                    end
                    data.GiftCardDecreased = true
                end
            end
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_USE_CARD, giftCard.onUse, enums.Cards.GIFT_CARD)

function giftCard:onPickupInit(pickup)
    if not pickup then return end
    
    if pickup.SubType == enums.Cards.GIFT_CARD then
		pickup:GetSprite():ReplaceSpritesheet(0,"gfx/items/pick ups/giftcard.png")
		pickup:GetSprite():LoadGraphics()
	end

    if giftCardUsed == true then
        local data = pickup:GetData()
        if data.GiftCardDecreased ~= true then
            pickup.AutoUpdatePrice = false
            if pickup.Price > 1 then
                pickup.Price = math.floor(pickup.Price / 2)
            elseif pickup.Price == PickupPrice.PRICE_TWO_HEARTS then
                pickup.Price = PickupPrice.PRICE_ONE_HEART
            end
            data.GiftCardDecreased = true
        end
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, giftCard.onPickupInit)

function giftCard:onNewLevel()
    giftCardUsed = false
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, giftCard.onNewLevel)
return giftCard