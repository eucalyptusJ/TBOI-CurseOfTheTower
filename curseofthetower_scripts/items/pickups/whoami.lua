local whoAmI = {}
local enums = require("curseofthetower_scripts.enums")
local utility = require("curseofthetower_scripts.utility")
local currentPill

local charactersRollable = {}

local noRedHearts = {
    PlayerType.PLAYER_BLUEBABY,
    PlayerType.PLAYER_BLACKJUDAS,
    PlayerType.PLAYER_THEFORGOTTEN,
    PlayerType.PLAYER_BLUEBABY_B,
    PlayerType.PLAYER_THEFORGOTTEN_B
}

for i = 0, 40 do
    charactersRollable[i] = i
end

-- Below are not actual character IDs, but their "new" ones, due to the table removing characters
table.remove(charactersRollable, 17) -- The Soul
table.remove(charactersRollable, 19) -- Esau
table.remove(charactersRollable, 36) -- Tainted Lazarus 2
table.remove(charactersRollable, 36) -- Lost Jacob
table.remove(charactersRollable, 36) -- Tainted The Soul

function whoAmI:onUse(_PillEffect, player, useFlags)
    if not player then return end

    local origChar = player:GetPlayerType()

    local voiceSeed = player:GetPillRNG(enums.Pills.WHO_AM_I)
    local voiceRoll = voiceSeed:RandomInt(100)

    SFXManager():Play(SoundEffect.SOUND_EDEN_GLITCH)
    local origMaxHealth = player:GetEffectiveMaxHearts()
    local seed = player:GetPillRNG(enums.Pills.WHO_AM_I)
    local roll = seed:RandomInt(#charactersRollable)
    local newChar = charactersRollable[roll]

    if utility:isHorsePill(useFlags, currentPill) == true then
        player:ChangePlayerType(newChar)
        player:UseActiveItem(CollectibleType.COLLECTIBLE_D4)

        if Options.AnnouncerVoiceMode == 2 or Options.AnnouncerVoiceMode == 0 and voiceRoll <= 50 then
            SFXManager():Play(enums.Sounds.VOICE_WHO_AM_I_HORSE, 5)
        end
    else
        player:ChangePlayerType(newChar)
        if Options.AnnouncerVoiceMode == 2 or Options.AnnouncerVoiceMode == 0 and voiceRoll <= 50 then
            SFXManager():Play(enums.Sounds.VOICE_WHO_AM_I, 3)
        end
    end

    player:PlayExtraAnimation("Glitch")

    local currentChar = player:GetPlayerType()

    -- Gives soul heart only characters and the forgotten the same amount of health as they had as the previous character, but in their respective HP types
    if utility:hasValue(noRedHearts, currentChar) then
        if origMaxHealth - 1 > 0 then -- Incase the pill is used while having only half a soul heart, this will prevent death
            player:AddSoulHearts(origMaxHealth - 1) -- Subtract 1 to remove the half soul heart granted by default
        end
    elseif currentChar == PlayerType.PLAYER_THEFORGOTTEN then
        player:AddBoneHearts(origMaxHealth)
        player:AddSoulHearts(-origMaxHealth)
        player:AddSoulHearts(2)
    end

    if utility:hasValue(noRedHearts, origChar) and currentChar == PlayerType.PLAYER_BETHANY then -- Incase you transform into Bethany from a soul heart only character
        player:AddMaxHearts(origMaxHealth, true)
    end

    --Gives characters who need their active items their respective active items
    if currentChar == PlayerType.PLAYER_MAGDALENE_B then
        player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_YUM_HEART, 2, false)

    elseif currentChar == PlayerType.PLAYER_CAIN_B then
        player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING, 2, false)

    elseif currentChar == PlayerType.PLAYER_JUDAS_B then
        player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_DARK_ARTS, 2, false)

    elseif currentChar == PlayerType.PLAYER_BLUEBABY_B then
        player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_HOLD, 2, false)

    elseif currentChar == PlayerType.PLAYER_EVE_B then
        player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_SUMPTORIUM, 2, false)

    elseif currentChar == PlayerType.PLAYER_LAZARUS_B then
        player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_FLIP, 2, false)

    elseif currentChar == PlayerType.PLAYER_APOLLYON_B then
        player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_ABYSS, 2, false)

    elseif currentChar == PlayerType.PLAYER_BETHANY_B then
        player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_LEMEGETON, 2, false)

    elseif currentChar == PlayerType.PLAYER_JACOB_B then
        player:SetPocketActiveItem(CollectibleType.COLLECTIBLE_ANIMA_SOLA, 2, false)
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_USE_PILL, whoAmI.onUse, enums.Pills.WHO_AM_I)

function whoAmI:onPlayerUpdate(player)
    currentPill = player:GetPill(0)
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, whoAmI.onPlayerUpdate)
return whoAmI