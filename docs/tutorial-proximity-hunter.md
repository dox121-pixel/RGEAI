# Tutorial: Proximity Hunter — Grouped Model That Stalks Lone Players

## Overview

This tutorial shows you how to make a **grouped model** (a collection of parts grouped with **Ctrl+G**) behave like a living threat:

| Situation | Behaviour |
|-----------|-----------|
| **Exactly 1 player** is near the object | Wait **10 seconds**, then the model moves toward the player and kills them |
| **More than 1 player** is near | The model stays still and players **cannot be killed** by it |

You will use:
- A **Sphere trigger** placed around the model as a proximity detector
- A **trigger Lua script** that checks the player count, manages a countdown, and fires the kill sequence
- The RGE `tween` and `explosion` console commands for movement and damage

---

## Prerequisites

- Basic familiarity with the RGE editor (open with **P**)
- Know how to place and name triggers
- Know how to open the trigger Script panel

---

## Step 1 — Build and Group Your Model

1. Open the **Objects** tab and place all the parts that will make up your creature/model.
2. Position and size each part until the model looks the way you want.
3. Select all parts of the model (click each while holding **Shift**, or drag-select).
4. Press **Ctrl + G** to group them.

> **Note:** Only **Parts** can be grouped. Make sure none of the parts have `isTrigger` enabled before saving — see [Known Bugs](rge-overview.md#bug-fixed-unable-to-enter-studio-camera--trigger-ghosts-on-parts).

5. With the group selected, open its **Properties** panel and give it a clear name — for example `CreatureModel`.
6. Note down the **UID** of the group (shown in the Properties panel). You will need this for the `tween` command later.

---

## Step 2 — Place the Detection Trigger

1. Open the **Triggers** tab.
2. Choose **Sphere** shape.
3. Click to place the sphere so that its centre is at roughly the same position as your model.
4. Use the **Scale** handle to set the radius to the distance at which you want the creature to "notice" a player — typically **15–20 studs**.
5. In the **Properties** panel, name the trigger `ProximityHunter`.
6. Make sure **Active on Start** is enabled.

---

## Step 3 — Configure the Trigger Group via Console

Open the RGE console (double-click the console bar to move it to the bottom if needed) and run these commands. Replace `w1` with your actual world slice name.

```
trigger create w1 HunterGroup
trigger set w1 %ProximityHunter HunterGroup true
trigger whitelist w1 HunterGroup Players true
```

> `trigger whitelist IsLooping` is **not** used here — the Lua script manages its own reset logic, so we do not need the trigger to loop at the console level. For details on what IsLooping does, see [Trigger Console Commands — IsLooping](rge-triggers.md#islooping).

---

## Step 4 — Write the Trigger Script

1. With `ProximityHunter` selected, open its **Script** panel.
2. Paste the script below. Read the comments — every configuration value is at the top.
3. Click **Apply / Save**.

```lua
-- proximity-hunter.lua
--
-- BEHAVIOUR:
--   Solo player enters zone  →  wait 10 s  →  print tween/explosion commands  →  reset
--   2+ players in zone       →  model stays still, no kill
--
-- CONFIGURATION — edit these values to match your setup:
local WORLD          = "w1"          -- world slice (e.g. "w1", "w2")
local MODEL_UID      = "XXXXX"       -- UID of your grouped model (from Properties panel)
local WAIT_SECONDS   = 10            -- seconds to wait before striking
local TWEEN_DURATION = 2             -- seconds the model takes to move toward the player
local EXPL_RADIUS    = 10            -- explosion radius in studs
local EXPL_DAMAGE    = 200           -- damage (200 kills a full-health player)
local EXPL_TYPE      = "Grenade"     -- explosion visual (see rge-api-reference.md)

-- TARGET_PX / TARGET_PY / TARGET_PZ are placeholder coordinates.
-- RGE trigger scripts cannot read live player position; hard-code a fixed
-- strike point for your map, or update these before the hunt sequence runs.
local TARGET_PX = 0
local TARGET_PY = 0
local TARGET_PZ = 0

-- ── Internal state ──────────────────────────────────────────────────────────
local isActive    = false   -- true while a hunt sequence is running
local targetPlayer = nil    -- the player currently being hunted

-- ── onInit ────────────────────────────────────────────────────────────────────
function onInit(trigger)
    print("[ProximityHunter] Ready — watching for lone players.")
end

-- ── onEnter ───────────────────────────────────────────────────────────────────
function onEnter(trigger, character)
    local player = Players.getByName(character.Name)
    if not player then return end

    -- Count players currently inside the zone (includes the one who just entered)
    local playersInZone = trigger:getPlayers()

    if #playersInZone > 1 then
        -- Safety in numbers — abort any active hunt
        if isActive then
            trigger:cancelTimer("hunt_strike")
            isActive     = false
            targetPlayer = nil
            print("[ProximityHunter] Multiple players detected — hunt cancelled.")
        end
        return
    end

    -- Exactly one player — start the hunt
    if isActive then return end   -- already hunting this player
    isActive     = true
    targetPlayer = player

    print("[ProximityHunter] Lone player detected: "
        .. player.Name .. " — stalking begins. Strike in " .. WAIT_SECONDS .. "s.")

    trigger:setTimer(WAIT_SECONDS, "hunt_strike")
end

-- ── onExit ────────────────────────────────────────────────────────────────────
function onExit(trigger, character)
    local player = Players.getByName(character.Name)
    if not player then return end

    -- If the hunted player escaped, cancel the countdown
    if targetPlayer and player == targetPlayer then
        trigger:cancelTimer("hunt_strike")
        isActive     = false
        targetPlayer = nil
        print("[ProximityHunter] Target escaped — hunt cancelled.")
        return
    end

    -- A second player left — re-check the count; resume hunt if now solo
    local playersInZone = trigger:getPlayers()
    if #playersInZone == 1 and not isActive then
        targetPlayer = playersInZone[1]
        isActive     = true
        print("[ProximityHunter] Back to one player (" .. targetPlayer.Name
            .. ") — resuming hunt. Strike in " .. WAIT_SECONDS .. "s.")
        trigger:setTimer(WAIT_SECONDS, "hunt_strike")
    end
end

-- ── onTimer ───────────────────────────────────────────────────────────────────
function onTimer(trigger, timerID)
    if timerID ~= "hunt_strike" then return end

    -- Safety re-check: abort if multiple players are now in the zone
    local playersInZone = trigger:getPlayers()
    if #playersInZone > 1 then
        isActive     = false
        targetPlayer = nil
        print("[ProximityHunter] Multiple players at strike time — aborting.")
        return
    end

    if not targetPlayer then
        isActive     = false
        targetPlayer = nil
        return
    end

    -- NOTE: RGE trigger scripts cannot read live player position.
    -- Run the tween and explosion commands manually in the RGE console,
    -- substituting the player's actual coordinates for pX pY pZ.
    -- TARGET_PX/PY/PZ are zero by default — update them for your map layout.
    print(string.format(
        "[ProximityHunter] Tween command (run in console): tween %s %s %d %d %d %d 0 0 0",
        WORLD, MODEL_UID, TWEEN_DURATION, TARGET_PX, TARGET_PY, TARGET_PZ
    ))

    -- Wait for the tween to finish before detonating
    wait(TWEEN_DURATION + 0.1)

    print(string.format(
        "[ProximityHunter] Explosion command (run in console): explosion %d %d %d %d %d %s",
        EXPL_RADIUS, EXPL_DAMAGE, TARGET_PX, TARGET_PY, TARGET_PZ, EXPL_TYPE
    ))

    -- Reset state so the creature can hunt again
    isActive     = false
    targetPlayer = nil
    print("[ProximityHunter] Strike complete. Resetting.")
end
```

> **About the `tween` and `explosion` lines:**  
> The `tween` and `explosion` are **RGE console commands**, not Lua functions. They cannot be called from a trigger script. The `print(...)` lines above output the exact command string to the console so you can copy-paste it. Player position is also not readable from a trigger script — set `TARGET_PX`, `TARGET_PY`, `TARGET_PZ` in the configuration block to fixed coordinates that match your map layout.

---

## Step 5 — Fill In Your Model UID

In the script you just pasted, find this line near the top:

```lua
local MODEL_UID = "XXXXX"
```

Replace `"XXXXX"` with the **UID** of your grouped model (the number shown in the Properties panel when the group is selected).

---

## Step 6 — Combine with the Tween Console Command

Because `tween` cannot be called from a Lua script directly, you have two options:

### Option A — Manual tween on detection (simpler)

1. When the trigger fires `onEnter`, the script prints the `tween` command to the console.
2. You (the mission host) copy that printed command and run it in the console manually.  
   This works well for showcase/cinematic missions where someone is watching the console.

### Option B — Tween trigger chaining (automated)

1. Create a **second trigger** called `TweenExecutor` placed at the same location as `ProximityHunter`.
2. In `TweenExecutor`'s script, use `onActivate` to run a `wait(10)` then execute the tween (if your RGE build exposes a console-execute API).
3. From `ProximityHunter`'s `onEnter`, call:
   ```lua
   local tweenTrigger = Triggers.get("TweenExecutor")
   if tweenTrigger then tweenTrigger:activate() end
   ```

### Option C — Use explosion only (easiest)

If moving the model is not critical, simplify by skipping the tween entirely: just let the countdown expire and detonate an explosion at the player's position. The creature "jumps" to the player instantaneously when the kill fires.

---

## Step 7 — Test the Mission

1. Press **Playtest** (or use the console `file load` to load the mission in play mode).
2. **Solo test:** Walk into the sphere trigger. You should see the console print `"Lone player detected"`. Wait 10 seconds — the tween and explosion commands will be printed.
3. **Group test:** Have a second player (or open two clients) both walk into the sphere. The console should print `"Multiple players detected — hunt cancelled"` and nothing else happens.
4. **Escape test:** Walk in, then walk out before 10 seconds. The console should print `"Target escaped — hunt cancelled"`.

---

## Tuning Tips

| Setting | What to change |
|---------|---------------|
| Reaction distance | Resize the `ProximityHunter` sphere trigger |
| Countdown length | Change `WAIT_SECONDS` |
| How fast the model moves | Change `TWEEN_DURATION` |
| Kill radius | Change `EXPL_RADIUS` |
| Damage amount | Change `EXPL_DAMAGE` (100 = half health, 200 = instant kill) |
| Visual explosion style | Change `EXPL_TYPE` — see [Explosion Types](rge-api-reference.md#explosion-types) |

---

## Full Behaviour Summary

```
Player enters sphere
        │
        ├─ More than 1 player? ──► do nothing (or cancel active hunt)
        │
        └─ Exactly 1 player?
                │
                ▼
          Start 10-second countdown
                │
         ┌──────┴──────────────────────┐
         │  Player exits before timer  │
         │  fires → cancel, reset      │
         └──────┬──────────────────────┘
                │  Timer fires
                ▼
          Re-check: still solo? ──► No → abort
                │ Yes
                ▼
          Tween model to player position
          Wait for tween to complete
          Explosion at player position
          Reset — ready for next hunt
```

---

## See Also

- [RGE Triggers — Console Commands & Event Handlers](rge-triggers.md)
- [Full API Reference — Explosion Types & Console Commands](rge-api-reference.md)
- [Example Script (ready to paste)](../scripts/examples/proximity-hunter.lua)
