-- mission-flow.lua
-- Multi-stage mission sequence using chained triggers.
--
-- MISSION STRUCTURE (paste one copy of this script into EACH listed trigger):
--
--   [TriggerStart]  → player enters → activate Objective 1, spawn Wave1
--   [TriggerWave1]  → Wave1 eliminated → complete Objective 1, open MainGate,
--                     activate Objective 2
--   [TriggerExtract]→ player enters extraction zone → mission win
--
-- SETUP STEPS:
--   1. Create three trigger volumes and name them:
--        "TriggerStart", "TriggerWave1", "TriggerExtract"
--   2. Create a SpawnGroup named "Wave1" via the Entities tab.
--   3. Create two Objectives named "Obj_EngageEnemies" and "Obj_Extraction".
--   4. Create a Gate named "MainGate".
--   5. Paste this script into each trigger's Script panel.
--   6. The script checks its own trigger.Name to decide which phase to run.

-- ─────────────────────────────────────────────────────────
-- Shared helpers
-- ─────────────────────────────────────────────────────────

local function log(msg)
    print("[MissionFlow] " .. msg)
end

-- ─────────────────────────────────────────────────────────
-- Phase 1 — Mission start zone
-- ─────────────────────────────────────────────────────────

local phase1Done = false

local function runPhase1(trigger)
    if phase1Done then return end
    phase1Done = true

    log("Phase 1 started")

    -- Show first objective
    local obj1 = Objectives.get("Obj_EngageEnemies")
    if obj1 then
        obj1:setTitle("Eliminate all enemies in the compound")
        obj1:activate()
    end

    -- Spawn first enemy wave
    local wave1 = SpawnGroups.get("Wave1")
    if wave1 then
        wave1:spawn()
        log("Wave1 spawned")

        -- When all enemies are dead, move to phase 2
        wave1.Eliminated:Connect(function()
            log("Wave1 eliminated — starting Phase 2")
            runPhase2()
        end)
    else
        warn("[MissionFlow] SpawnGroup 'Wave1' not found!")
    end

    -- Self-deactivate so this trigger doesn't re-fire
    trigger:deactivate()
end

-- ─────────────────────────────────────────────────────────
-- Phase 2 — Open gate and set extraction objective
-- ─────────────────────────────────────────────────────────

local phase2Done = false

local function runPhase2()
    if phase2Done then return end
    phase2Done = true

    -- Complete the first objective
    local obj1 = Objectives.get("Obj_EngageEnemies")
    if obj1 then obj1:complete() end

    -- Open the main gate
    local gate = Gates.get("MainGate")
    if gate then
        gate:open()
        log("MainGate opened")
    end

    -- Activate extraction objective
    local obj2 = Objectives.get("Obj_Extraction")
    if obj2 then
        obj2:setTitle("Reach the extraction zone")
        obj2:activate()
    end

    Mission.sendMessage("Enemies eliminated! Proceed to extraction.", 5)
end

-- ─────────────────────────────────────────────────────────
-- Phase 3 — Extraction zone
-- ─────────────────────────────────────────────────────────

local extractionStarted = false

local function runPhase3(trigger)
    if not phase2Done then return end  -- only active after gate opens
    if extractionStarted then return end
    extractionStarted = true

    log("Player reached extraction zone — starting extraction timer")

    Mission.sendMessage("Hold the extraction zone for 10 seconds!", 4)
    trigger:setTimer(10, "extraction_complete")
end

-- ─────────────────────────────────────────────────────────
-- Event handlers (same script used by all three triggers)
-- ─────────────────────────────────────────────────────────

function onEnter(trigger, character)
    local player = Players.getByName(character.Name)
    if not player then return end

    if trigger.Name == "TriggerStart" then
        runPhase1(trigger)
    elseif trigger.Name == "TriggerExtract" then
        runPhase3(trigger)
    end
end

function onExit(trigger, character)
    if trigger.Name == "TriggerExtract" and extractionStarted and phase2Done then
        -- Player left before timer finished — cancel extraction
        trigger:cancelTimer("extraction_complete")
        extractionStarted = false
        Mission.sendMessage("Extraction cancelled — stay in the zone!", 4)
        log("Extraction cancelled — player left zone early")
    end
end

function onTimer(trigger, timerID)
    if timerID == "extraction_complete" then
        log("Extraction complete — mission won!")
        local obj2 = Objectives.get("Obj_Extraction")
        if obj2 then obj2:complete() end
        Mission.sendMessage("Extraction successful! Mission complete.", 5)
        wait(3)
        Mission.win()
    end
end
