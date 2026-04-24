-- proximity-hunter.lua
-- Grouped model that hunts a lone player after a 10-second countdown.
-- If more than one player is in the zone, the model stays dormant and no
-- one can be killed by it.
--
-- HOW TO USE:
--   1. Build and group your model (Ctrl+G). Note its UID from the Properties panel.
--   2. Place a Sphere trigger around the model and name it "ProximityHunter".
--   3. In the RGE console, run:
--        trigger create w1 HunterGroup
--        trigger set w1 %ProximityHunter HunterGroup true
--        trigger whitelist w1 HunterGroup Players true
--   4. Open ProximityHunter's Script panel, paste this file, and click Apply.
--   5. Set MODEL_UID below to your grouped model's actual UID.
--
-- For a full walkthrough see: docs/tutorial-proximity-hunter.md

-- ── Configuration ─────────────────────────────────────────────────────────────
local WORLD          = "w1"       -- world slice (match your trigger create command)
local MODEL_UID      = "XXXXX"    -- UID of your grouped model
local WAIT_SECONDS   = 10         -- countdown before the creature strikes
local TWEEN_DURATION = 2          -- seconds the model takes to reach the player
local EXPL_RADIUS    = 10         -- explosion radius in studs
local EXPL_DAMAGE    = 200        -- damage dealt (200 kills a full-health player)
local EXPL_TYPE      = "Grenade"  -- explosion visual type

-- ── Internal state ────────────────────────────────────────────────────────────
local isActive     = false
local targetPlayer = nil

-- ── Helper ────────────────────────────────────────────────────────────────────
local function getPlayerXYZ(player)
    if not player or not player.Character then return nil end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local p = hrp.Position
    return p.X, p.Y, p.Z
end

-- ── Event handlers ────────────────────────────────────────────────────────────

function onInit(trigger)
    print("[ProximityHunter] Ready — watching for lone players.")
end

function onEnter(trigger, character)
    local player = game.Players:GetPlayerFromCharacter(character)
    if not player then return end

    local playersInZone = trigger:getPlayers()

    if #playersInZone > 1 then
        -- Safety in numbers — abort any running hunt
        if isActive then
            trigger:cancelTimer("hunt_strike")
            isActive     = false
            targetPlayer = nil
            print("[ProximityHunter] Multiple players — hunt cancelled.")
        end
        return
    end

    -- Exactly one player: start the countdown
    if isActive then return end
    isActive     = true
    targetPlayer = player

    print("[ProximityHunter] Lone player: " .. player.Name
        .. " — striking in " .. WAIT_SECONDS .. "s.")
    trigger:setTimer(WAIT_SECONDS, "hunt_strike")
end

function onExit(trigger, character)
    local player = game.Players:GetPlayerFromCharacter(character)
    if not player then return end

    if targetPlayer and player == targetPlayer then
        -- Hunted player escaped
        trigger:cancelTimer("hunt_strike")
        isActive     = false
        targetPlayer = nil
        print("[ProximityHunter] Target escaped — hunt cancelled.")
        return
    end

    -- A second player left — if now solo, resume hunt
    local playersInZone = trigger:getPlayers()
    if #playersInZone == 1 and not isActive then
        targetPlayer = playersInZone[1]
        isActive     = true
        print("[ProximityHunter] Back to one player (" .. targetPlayer.Name
            .. ") — resuming. Strike in " .. WAIT_SECONDS .. "s.")
        trigger:setTimer(WAIT_SECONDS, "hunt_strike")
    end
end

function onTimer(trigger, timerID)
    if timerID ~= "hunt_strike" then return end

    -- Re-check player count at strike time
    local playersInZone = trigger:getPlayers()
    if #playersInZone > 1 then
        isActive     = false
        targetPlayer = nil
        print("[ProximityHunter] Multiple players at strike time — aborting.")
        return
    end

    if not targetPlayer or not targetPlayer.Character then
        isActive     = false
        targetPlayer = nil
        return
    end

    local x, y, z = getPlayerXYZ(targetPlayer)
    if not x then
        isActive     = false
        targetPlayer = nil
        return
    end

    local px = math.floor(x + 0.5)
    local py = math.floor(y + 0.5)
    local pz = math.floor(z + 0.5)

    -- Print the tween command (run this in the RGE console to move the model).
    -- Replace MODEL_UID with your actual UID if you have not done so above.
    print(string.format(
        "[ProximityHunter] Run in console: tween %s %s %d %d %d %d 0 0 0",
        WORLD, MODEL_UID, TWEEN_DURATION, px, py, pz
    ))

    -- Wait for the tween animation to complete before detonating
    wait(TWEEN_DURATION + 0.1)

    -- Re-fetch position (player may have moved slightly during the tween)
    local x2, y2, z2 = getPlayerXYZ(targetPlayer)
    if x2 then
        px = math.floor(x2 + 0.5)
        py = math.floor(y2 + 0.5)
        pz = math.floor(z2 + 0.5)
    end

    -- Print the explosion command (or run it directly if your RGE build supports it).
    print(string.format(
        "[ProximityHunter] Run in console: explosion %d %d %d %d %d %s",
        EXPL_RADIUS, EXPL_DAMAGE, px, py, pz, EXPL_TYPE
    ))

    -- Reset for the next hunt
    isActive     = false
    targetPlayer = nil
    print("[ProximityHunter] Strike complete. Ready for next hunt.")
end
