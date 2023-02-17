local encyclopedia = {}
local descriptions = require("curseofthetower_scripts.modcompatibility.descriptions")
local enums = require("curseofthetower_scripts.enums")

function encyclopedia:addEncyclopedia()
    if Encyclopedia then
        -- Collectibles
        Encyclopedia.AddItem({
            ID = enums.Collectibles.ICE_CREAM,
            WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Collectibles.ICE_CREAM),
            Pools = {
            Encyclopedia.ItemPools.POOL_TREASURE,
            Encyclopedia.ItemPools.POOL_GREED_TREASURE,
            },
        })

        Encyclopedia.AddItem({
            ID = enums.Collectibles.KEROSENE,
            WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Collectibles.KEROSENE),
            Pools = {
            Encyclopedia.ItemPools.POOL_TREASURE,
            Encyclopedia.ItemPools.POOL_GREED_TREASURE,
            },
        })

        Encyclopedia.AddItem({
            ID = enums.Collectibles.PAIN_KILLERS,
            WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Collectibles.PAIN_KILLERS),
            Pools = {
            Encyclopedia.ItemPools.POOL_SECRET,
            Encyclopedia.ItemPools.POOL_GREED_SHOP,
            },
        })

        Encyclopedia.AddItem({
            ID = enums.Collectibles.POKER_FACE,
            WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Collectibles.POKER_FACE),
            Pools = {
            Encyclopedia.ItemPools.POOL_DEVIL,
            Encyclopedia.ItemPools.POOL_GREED_DEVIL,
            Encyclopedia.ItemPools.POOL_ULTRA_SECRET,
            },
        })

        Encyclopedia.AddItem({
            ID = enums.Collectibles.POP_O_MATIC,
            WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Collectibles.POP_O_MATIC),
            Pools = {
            Encyclopedia.ItemPools.POOL_TREASURE,
            Encyclopedia.ItemPools.POOL_GREED_TREASURE,
            },
        })

        Encyclopedia.AddItem({
            ID = enums.Collectibles.TAROT_BOMBS,
            WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Collectibles.TAROT_BOMBS),
            Pools = {
            Encyclopedia.ItemPools.POOL_TREASURE,
            Encyclopedia.ItemPools.POOL_GREED_TREASURE,
            },
        })

        Encyclopedia.AddItem({
            ID = enums.Collectibles.WHITE_BELT,
            WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Collectibles.WHITE_BELT),
            Pools = {
            Encyclopedia.ItemPools.POOL_SHOP,
            Encyclopedia.ItemPools.POOL_GREED_SHOP,
            },
        })

        Encyclopedia.AddItem({
            ID = enums.Collectibles.DARK_ORB,
            WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Collectibles.DARK_ORB),
            Pools = {
              Encyclopedia.ItemPools.POOL_DEVIL,
              Encyclopedia.ItemPools.POOL_GREED_DEVIL,
              Encyclopedia.ItemPools.POOL_SECRET,
            },
          })

          Encyclopedia.AddItem({
            ID = enums.Collectibles.LIL_RAINMAKER,
            WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Collectibles.LIL_RAINMAKER),
            Pools = {
              Encyclopedia.ItemPools.POOL_TREASURE,
              Encyclopedia.ItemPools.POOL_GREED_TREASURE,
              Encyclopedia.ItemPools.POOL_BABY_SHOP,
            },
          })

          Encyclopedia.AddItem({
            ID = enums.Collectibles.TERRORPORTER,
            WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Collectibles.TERRORPORTER),
            Pools = {
                Encyclopedia.ItemPools.POOL_DEVIL,
                Encyclopedia.ItemPools.POOL_GREED_DEVIL,
                Encyclopedia.ItemPools.POOL_CURSE,
            },
          })

          Encyclopedia.AddItem({
            ID = enums.Collectibles.HEX_OF_THE_TOWER,
            WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Collectibles.HEX_OF_THE_TOWER),
            Pools = {
                Encyclopedia.ItemPools.POOL_CURSE,
                Encyclopedia.ItemPools.POOL_RED_CHEST,
                Encyclopedia.ItemPools.POOL_TREASURE,
                Encyclopedia.ItemPools.POOL_GREED_CURSE,
                Encyclopedia.ItemPools.POOL_GREED_TREASURE,
            },
          })

        -- Trinkets
        Encyclopedia.AddTrinket({
            ID = enums.Trinkets.FREE_BLOOD,
            WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Trinkets.FREE_BLOOD),
        })

        Encyclopedia.AddTrinket({
            ID = enums.Trinkets.MINTY_GUM,
            WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Trinkets.MINTY_GUM),
        })

        Encyclopedia.AddTrinket({
            ID = enums.Trinkets.THE_UNEXPECTED,
            WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Trinkets.THE_UNEXPECTED),
        })

        Encyclopedia.AddTrinket({
            ID = enums.Trinkets.REJECT_TECH,
            WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Trinkets.REJECT_TECH),
        })

        -- Pickups 
        Encyclopedia.AddCard({
            ID = enums.Cards.GIFT_CARD,
            WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Cards.GIFT_CARD),
        })

        -- Encyclopedia.AddPill({
        --     ID = enums.Pills.WHO_AM_I,
        --     WikiDesc = Encyclopedia.EIDtoWiki(descriptions.Pills.WHO_AM_I),
        --     Color = 9,
        -- })
    end
end

return encyclopedia