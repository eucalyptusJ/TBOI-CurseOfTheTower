local savedata = {}
local json = require("json")
savedata.PersistentData = {}

function savedata:onPlayerInit()
    if curseTowerMod:HasData() then
        savedata.PersistentData = json.decode(curseTowerMod:LoadData())
    end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, savedata.onPlayerInit)

function savedata:onGameExit()
    curseTowerMod:SaveData(json.encode(savedata.PersistentData))
end
curseTowerMod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, savedata.onGameExit)
--curseTowerMod:AddCallback(ModCallbacks.MC_POST_GAME_END, savedata.onGameExit)

function savedata:onGameEnd()
    savedata.PersistentData = {}
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_GAME_END, savedata.onGameEnd)
return savedata