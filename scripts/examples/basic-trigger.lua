-- basic-trigger.lua
-- Minimal example: print a message when any player enters the trigger zone.
--
-- HOW TO USE:
--   1. Place a Trigger (Box or Sphere) on the map via the RGE Triggers tab.
--   2. Open the trigger's Script panel.
--   3. Paste this entire file into the panel and click Apply.
--   4. Playtest the mission and walk into the zone to see the output.
--
-- CUSTOMISE:
--   - Change the message in onEnter to suit your mission.
--   - Adjust COOLDOWN_SECONDS to control how often the trigger can fire.

local COOLDOWN_SECONDS = 2

local onCooldown = false

-- onEnter fires every time a player's character walks into the trigger volume.
function onEnter(trigger, character)
    if onCooldown then return end

    local player = Players.getByName(character.Name)
    if not player then return end

    onCooldown = true
    Mission.sendMessage(player.Name .. " entered the zone!", 3)
    print("[BasicTrigger] " .. player.Name .. " entered " .. trigger.Name)

    -- Reset the cooldown after COOLDOWN_SECONDS
    trigger:setTimer(COOLDOWN_SECONDS, "cooldown_reset")
end

-- onExit fires when a player's character leaves the trigger volume.
function onExit(trigger, character)
    local player = Players.getByName(character.Name)
    if player then
        print("[BasicTrigger] " .. player.Name .. " left " .. trigger.Name)
    end
end

-- onTimer fires when a setTimer call expires.
function onTimer(trigger, timerID)
    if timerID == "cooldown_reset" then
        onCooldown = false
    end
end
