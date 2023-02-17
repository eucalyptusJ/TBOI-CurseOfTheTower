local eid = {}
local enums = require("curseofthetower_scripts.enums")
local descriptions = require("curseofthetower_scripts.modcompatibility.descriptions")

function eid:addEid()
    if EID then
        -- Collectibles
        EID:addCollectible(enums.Collectibles.ICE_CREAM, descriptions.Collectibles.ICE_CREAM)
        EID:addCollectible(enums.Collectibles.KEROSENE, descriptions.Collectibles.KEROSENE)
        EID:addCollectible(enums.Collectibles.PAIN_KILLERS, descriptions.Collectibles.PAIN_KILLERS)
        EID:addCollectible(enums.Collectibles.POKER_FACE, descriptions.Collectibles.POKER_FACE)
        EID:addCollectible(enums.Collectibles.POP_O_MATIC, descriptions.Collectibles.POP_O_MATIC)
        EID:addCollectible(enums.Collectibles.TAROT_BOMBS, descriptions.Collectibles.TAROT_BOMBS)
        EID:addCollectible(enums.Collectibles.WHITE_BELT, descriptions.Collectibles.WHITE_BELT)
        EID:addCollectible(enums.Collectibles.DARK_ORB, descriptions.Collectibles.DARK_ORB)
        EID:addCollectible(enums.Collectibles.TERRORPORTER, descriptions.Collectibles.TERRORPORTER)
        EID:addCollectible(enums.Collectibles.LIL_RAINMAKER, descriptions.Collectibles.LIL_RAINMAKER)
        EID:addCollectible(enums.Collectibles.HEX_OF_THE_TOWER, descriptions.Collectibles.HEX_OF_THE_TOWER)

        -- Trinkets
        EID:addTrinket(enums.Trinkets.FREE_BLOOD, descriptions.Trinkets.FREE_BLOOD)
        EID:addTrinket(enums.Trinkets.MINTY_GUM, descriptions.Trinkets.MINTY_GUM)
        EID:addTrinket(enums.Trinkets.THE_UNEXPECTED, descriptions.Trinkets.THE_UNEXPECTED)
        EID:addTrinket(enums.Trinkets.REJECT_TECH, descriptions.Trinkets.REJECT_TECH)

        -- Pickups
        EID:addCard(enums.Cards.GIFT_CARD, descriptions.Cards.GIFT_CARD)
        --EID:addPill(enums.Pills.WHO_AM_I, descriptions.Pills.WHO_AM_I)

        -- Book of Virtues
        EID.descriptions["en_us"].bookOfVirtuesWisps[enums.Collectibles.KEROSENE] = descriptions.BookOfVirtues.KEROSENE
        EID.descriptions["en_us"].bookOfVirtuesWisps[enums.Collectibles.TERRORPORTER] = descriptions.BookOfVirtues.TERRORPORTER

        -- Judas Birthright
        EID.descriptions["en_us"].bookOfBelialBuffs[enums.Collectibles.KEROSENE] = descriptions.JudasBirthright.KEROSENE
        EID.descriptions["en_us"].bookOfBelialBuffs[enums.Collectibles.TERRORPORTER] = descriptions.JudasBirthright.TERRORPORTER

        -- Locusts
        EID.descriptions["en_us"].abyssSynergies[enums.Collectibles.ICE_CREAM] = descriptions.AbyssLocusts.ICE_CREAM
        EID.descriptions["en_us"].abyssSynergies[enums.Collectibles.POKER_FACE] = descriptions.AbyssLocusts.POKER_FACE
        EID.descriptions["en_us"].abyssSynergies[enums.Collectibles.WHITE_BELT] = descriptions.AbyssLocusts.WHITE_BELT
        EID.descriptions["en_us"].abyssSynergies[enums.Collectibles.DARK_ORB] = descriptions.AbyssLocusts.DARK_ORB
        EID.descriptions["en_us"].abyssSynergies[enums.Collectibles.HEX_OF_THE_TOWER] = descriptions.AbyssLocusts.HEX_OF_THE_TOWER
    end
end
return eid