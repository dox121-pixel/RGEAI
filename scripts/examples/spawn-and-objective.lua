-- spawn-and-objective.lua
-- Spawn enemy waves tied to an objective and count surviving enemies.
--
-- SETUP:
--   1. Create a Trigger named "TriggerCompound" covering the compound entrance.
--   2. Create SpawnGroups named "Wave1", "Wave2", "Wave3" in the Entities tab.
--   3. Create an Objective named "Obj_ClearCompound".
--   4. Paste this script into TriggerCompound's Script panel.
--
-- BEHAVIOUR:
--   - When a BLUFOR player enters the trigger, Wave1 spawns.
--   - After Wave1 is eliminated, Wave2 spawns automatically.
--   - After Wave2 is eliminated, Wave3 (boss wave) spawns.
--   - After Wave3 is eliminated, the objective completes.

-- ─────────────────────────────────────────────────────────
-- Configuration
-- ─────────────────────────────────────────────────────────

local WAVE_NAMES = { "Wave1", "Wave2", "Wave3" }
local OBJECTIVE_NAME = "Obj_ClearCompound"
local DELAY_BETWEEN_WAVES = 5  -- seconds before next wave spawns

-- ─────────────────────────────────────────────────────────
-- State
-- ─────────────────────────────────────────────────────────

local currentWaveIndex = 0
local missionTrigger = nil

-- ─────────────────────────────────────────────────────────
-- Helpers
-- ─────────────────────────────────────────────────────────

local function log(msg)
    print("[SpawnObjective] " .. msg)
end

local function spawnNextWave()
    currentWaveIndex = currentWaveIndex + 1

    if currentWaveIndex > #WAVE_NAMES then
        -- All waves cleared
        log("All waves eliminated — objective complete")
        local obj = Objectives.get(OBJECTIVE_NAME)
        if obj then obj:complete() end
        Mission.sendMessage("Compound cleared! All enemies eliminated.", 5)
        return
    end

    local waveName = WAVE_NAMES[currentWaveIndex]
    local group = SpawnGroups.get(waveName)

    if not group then
        warn("[SpawnObjective] SpawnGroup '" .. waveName .. "' not found — skipping")
        spawnNextWave()  -- skip missing waves
        return
    end

    Mission.sendMessage(
        "Wave " .. currentWaveIndex .. " of " .. #WAVE_NAMES .. " incoming!",
        4
    )
    log("Spawning " .. waveName)
    group:spawn()

    -- Update objective text to reflect current wave
    local obj = Objectives.get(OBJECTIVE_NAME)
    if obj then
        obj:setTitle(
            "Clear the compound — Wave " .. currentWaveIndex .. "/" .. #WAVE_NAMES
        )
    end

    -- When this wave is eliminated, wait then spawn the next
    group.Eliminated:Connect(function()
        log(waveName .. " eliminated")
        Mission.sendMessage("Wave " .. currentWaveIndex .. " cleared. Prepare for next wave.", 3)
        missionTrigger:setTimer(DELAY_BETWEEN_WAVES, "next_wave_" .. currentWaveIndex)
    end)
end

-- ─────────────────────────────────────────────────────────
-- Event handlers
-- ─────────────────────────────────────────────────────────

function onInit(trigger)
    missionTrigger = trigger
    -- Only allow BLUFOR to trigger this zone
    trigger:setTeamFilter("BLUFOR")
end

function onEnter(trigger, character)
    -- Only start if no wave has been triggered yet
    if currentWaveIndex > 0 then return end

    local player = game.Players:GetPlayerFromCharacter(character)
    if not player then return end

    log("BLUFOR entered compound — starting engagement")

    -- Activate the objective
    local obj = Objectives.get(OBJECTIVE_NAME)
    if obj then
        obj:setTitle("Clear the compound — Wave 1/" .. #WAVE_NAMES)
        obj:activate()
    end

    -- Deactivate this trigger so the zone entry doesn't re-trigger
    trigger:deactivate()

    -- Start wave sequence
    spawnNextWave()
end

function onTimer(trigger, timerID)
    -- timerID format: "next_wave_<waveIndex>"
    if timerID:sub(1, 10) == "next_wave_" then
        spawnNextWave()
    end
end
