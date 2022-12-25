local enums = {}

enums.Collectibles = {
    ICE_CREAM = Isaac.GetItemIdByName("Ice Cream"),
    KEROSENE = Isaac.GetItemIdByName("Kerosene"),
    PAIN_KILLERS = Isaac.GetItemIdByName("Pain Killers"),
    POKER_FACE = Isaac.GetItemIdByName("Poker Face"),
    POP_O_MATIC = Isaac.GetItemIdByName("Pop-O-Matic"),
    TAROT_BOMBS = Isaac.GetItemIdByName("Tarot Bombs"),
    WHITE_BELT = Isaac.GetItemIdByName("White Belt"),
    DARK_ORB = Isaac.GetItemIdByName("Dark Orb"),
    LIL_RAINMAKER = Isaac.GetItemIdByName("Lil Rainmaker"),
    TERRORPORTER = Isaac.GetItemIdByName("Terrorporter"),
    HEX_OF_THE_TOWER = Isaac.GetItemIdByName("Hex of The Tower")
}

enums.Trinkets = {
    FREE_BLOOD = Isaac.GetTrinketIdByName("Free Blood"),
    MINTY_GUM = Isaac.GetTrinketIdByName("Minty Gum"),
    THE_UNEXPECTED = Isaac.GetTrinketIdByName("The Unexpected"),
    REJECT_TECH = Isaac.GetTrinketIdByName("Reject Tech")
}

enums.Pills = {
    WHO_AM_I = Isaac.GetPillEffectByName("Who am I?")
}

enums.Cards = {
    GIFT_CARD = Isaac.GetCardIdByName("GiftCard")
}

enums.Challenges = {
    KEEPERS_CURSE = Isaac.GetChallengeIdByName("The Keeper's Curse")
}

enums.EntityVariants = {
    LIL_RAINMAKER = Isaac.GetEntityVariantByName("Lil Rainmaker")
}

enums.Sounds = {
    VOICE_WHO_AM_I = Isaac.GetSoundIdByName("WhoAmI"),
    VOICE_WHO_AM_I_HORSE = Isaac.GetSoundIdByName("WhoAmIHorse"),
    VOICE_GIFT_CARD = Isaac.GetSoundIdByName("GiftCard")
}

return enums