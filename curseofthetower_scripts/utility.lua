local utility = {}

-- Use to cycle through a table and compare values, if you want to exclude certain things, etc...
function utility:hasValue(table, val)
    for i, value in pairs(table) do
        if value == val then
            return true
        end
    end

    return false
end

-- Check if a pill is a horse pill
-- Thank you Xalum for this function
function utility:isHorsePill(useFlags, currentPill)
  if not currentPill then return end
  local holdingHorsePill = currentPill & PillColor.PILL_GIANT_FLAG > 0
  local proceedByEchoChamber = useFlags & (1 << 11) > 0

  return holdingHorsePill and not proceedByEchoChamber
end

-- Scheduler
-- Thank you Xalum for this function
curseTowerMod.ScheduleData = {}
function curseTowerMod.Schedule(delay, func, args)
  table.insert(curseTowerMod.ScheduleData, {
    Time = Game():GetFrameCount(),
    Delay = delay,
    Call = func,
    Args = args
  })
end

curseTowerMod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
  local time = Game():GetFrameCount()
  for i = #curseTowerMod.ScheduleData, 1, -1 do
    local data = curseTowerMod.ScheduleData[i]
    if data.Time + data.Delay <= time then
      data.Call(table.unpack(data.Args))
      table.remove(curseTowerMod.ScheduleData, i)
    end
  end
end)

-- Check if the player is Judas with birthright
function utility:isJudasBirthright(player)
    if player:GetPlayerType() == 3 and player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        return true
    else return false end 
end

-- Convert bad trip to full health and health down to health up if they would kill the player
function utility:convertKillingPills(player, pillEffect, damageTaken)
    if damageTaken == nil then
        damageTaken = 0
    end
   
    local maxHits = player:GetHearts() + player:GetRottenHearts() + player:GetSoulHearts()
    local maxContain = player:GetEffectiveMaxHearts() + player:GetSoulHearts()
    local hitsAfterDmg = maxHits - (damageTaken + 2)
    local containAfterDmg = maxContain - 2

    if pillEffect == PillEffect.PILLEFFECT_BAD_TRIP and hitsAfterDmg <= 0 then -- Check to make sure bad trip will not kill the player
       pillEffect = PillEffect.PILLEFFECT_FULL_HEALTH
    elseif pillEffect == PillEffect.PILLEFFECT_HEALTH_DOWN and containAfterDmg <= 0 then -- Check to make sure the health down will not remove the player's last container or soul heart
        pillEffect = PillEffect.PILLEFFECT_HEALTH_UP
    end
    return pillEffect
end

-- Get the enemy closest to the player in question
function utility:getClosestEnemy(entityToTeleport, radius)
    local target = nil
    for i, entity in pairs(Isaac.GetRoomEntities()) do
        if entity:IsActiveEnemy(false) and entity:IsVulnerableEnemy() then
            local distance = entityToTeleport.Position:Distance(entity.Position)
            if distance < radius then
                radius = distance
                target = entity
            end
        end
    end
    return target
end

-- Function to get the exact player that fired a tear
-- Thank you oatmealine for this function 
---@param tear EntityTear
---@return EntityPlayer | nil
function utility:findPlayerFromTear(tear)
  if not tear then return end
  local parent = tear.Parent
  if not parent then return end

  if parent:ToPlayer() then
    return parent:ToPlayer()
  elseif parent:ToFamiliar() and parent.Variant == FamiliarVariant.INCUBUS then
    return parent:ToFamiliar().Player
  end
end

return utility