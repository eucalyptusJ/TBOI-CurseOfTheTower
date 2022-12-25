local lilRainmaker = {}
local enums = require("curseofthetower_scripts.enums")
local utility = require("curseofthetower_scripts.utility")

local lilRainmakerData = {
	FireDelay = 20
}

function lilRainmaker:onFamiliarInit(lilRainmakerFamiliar)
	if not lilRainmakerFamiliar then return end
	lilRainmakerFamiliar.IsFollower = true
	lilRainmakerFamiliar:AddToFollowers()
end
curseTowerMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, lilRainmaker.onFamiliarInit, enums.EntityVariants.LIL_RAINMAKER)

function lilRainmaker:onCache(player, cacheFlag)
	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		local lilRainmakerCount = player:GetCollectibleNum(enums.Collectibles.LIL_RAINMAKER) + player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_BOX_OF_FRIENDS)
		player:CheckFamiliar(enums.EntityVariants.LIL_RAINMAKER, lilRainmakerCount, RNG())
	end
end
curseTowerMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, lilRainmaker.onCache)

function lilRainmaker:onFamiliarUpdate(lilRainmakerFamiliar)
	if not lilRainmakerFamiliar then return end
	lilRainmakerFamiliar:FollowParent()
end
curseTowerMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, lilRainmaker.onFamiliarUpdate, enums.EntityVariants.LIL_RAINMAKER)

function lilRainmaker:onPlayerUpdate(player)
	if not player then return end
	if player:HasCollectible(enums.Collectibles.LIL_RAINMAKER) and Game():GetRoom():GetAliveEnemiesCount() > 0 then
		if Game():GetFrameCount() % lilRainmakerData.FireDelay == 0 then
			for i, entity in pairs(Isaac.GetRoomEntities()) do
				if entity.Variant == enums.EntityVariants.LIL_RAINMAKER then
					local tearSpawnPos = Isaac.GetFreeNearPosition(entity.Position, 55)
					Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WATER_RIPPLE, 0, tearSpawnPos, Vector.Zero, entity:ToFamiliar())
					local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, tearSpawnPos, Vector.Zero, entity):ToTear()
					local data = tear:GetData()
					data.isLilRainmakerTear = true
					tear.HomingFriction = tear.HomingFriction * 1.1
					tear.TearFlags = tear.TearFlags | TearFlags.TEAR_SPECTRAL
					tear.TearFlags = tear.TearFlags | TearFlags.TEAR_HOMING
					local frame = tear.FrameCount
				end
			end
		end
	end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, lilRainmaker.onPlayerUpdate)

function lilRainmaker:onTearCollision(tear, collider, low)
	if tear == nil then return end
	if tear:GetData().isLilRainmakerTear == true then
		local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 0, collider.Position, Vector.Zero, tear)
		creep:Update()
	end
end
curseTowerMod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, lilRainmaker.onTearCollision)

function lilRainmaker:postRender()
	local sprite
	for i, entity in pairs(Isaac.GetRoomEntities()) do
		if entity.Variant == enums.EntityVariants.LIL_RAINMAKER then
			sprite = entity:GetSprite()
			if sprite:IsLoaded() ~= true then
				sprite:Load("gfx/lilrainmaker.anm2", true)
			end

			if Game():GetRoom():GetFrameCount() == 1 then
				if not sprite then return end
				sprite:Play("Start", true)
			end

			if Game():GetFrameCount() % 8 == 0 and Game():GetRoom():GetAliveEnemiesCount() > 0 then
				if not sprite then return end
				sprite:Play("Spin", true)
			end

			if Game():GetRoom():GetAliveEnemiesCount() <= 0 then
				if not sprite then return end
				if sprite:IsFinished("Spin") then
					sprite:Play("End", true)
				end
				sprite:Play("Idle", true)
			end
		end
	end
end
curseTowerMod:AddCallback(ModCallbacks.MC_POST_RENDER, lilRainmaker.postRender)
return lilRainmaker