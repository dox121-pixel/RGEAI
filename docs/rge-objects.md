# RGE Placeable Objects Reference

This document describes the major categories of objects you can place in the RGE editor and how to interact with them from trigger scripts.

---

## AI / NPC Entities

### Enemy AI Types

The following enemy AI unit types are available in the **Entities** tab:

| Type | Description |
|------|-------------|
| `Rifleman` | Standard infantry with assault rifle |
| `SMG` | Close-quarters soldier with submachine gun |
| `Sniper` | Long-range marksman; stays stationary or patrols slowly |
| `MachineGunner` | Suppression unit with light or medium machine gun |
| `Grenadier` | Carries grenade launcher; lobs indirect fire |
| `Turret` | Stationary auto-firing emplacement; no movement |
| `VehicleCrew` | AI crew assigned to a vehicle; spawns with the vehicle |
| `Patrol` | AI that walks a set path (waypoints defined in editor) |
| `SpecialForces` | Elite enemy with better accuracy and health |

### AI Behavior Modes

| Mode | Description |
|------|-------------|
| `Idle` | Stands still; attacks only when spotted |
| `Patrol` | Walks between assigned waypoints |
| `Aggressive` | Actively hunts players within detection range |
| `Defensive` | Holds a position; engages when players approach |
| `Berserk` | Charges toward nearest player regardless of cover |

### AI Entity Properties (Editor Panel)

| Property | Type | Description |
|----------|------|-------------|
| `Name` | string | Identifier for script references |
| `Faction` | enum | `OPFOR`, `BLUFOR`, `Neutral` |
| `Type` | enum | Unit type (see table above) |
| `Behavior` | enum | AI behavior mode |
| `Health` | number | Starting health points |
| `Respawn` | bool | Whether the unit respawns after death |
| `RespawnDelay` | number | Seconds before respawning |
| `PatrolPath` | Path | Assigned waypoint path (Patrol mode only) |
| `AggroRange` | number | Detection radius in studs |
| `WeaponOverride` | string | Force a specific weapon loadout |

---

## SpawnGroup

A **SpawnGroup** is a named collection of AI units that spawn together. Groups can be activated on demand from a trigger script.

### SpawnGroup Properties

| Property | Type | Description |
|----------|------|-------------|
| `Name` | string | Unique group identifier |
| `Position` | Vector3 | Spawn origin (units fan out from here) |
| `Faction` | enum | `OPFOR` or `BLUFOR` |
| `Units` | array | List of unit definitions (type, count, behavior) |
| `Respawnable` | bool | Whether units in the group respawn |
| `ActiveOnStart` | bool | Spawn immediately when mission starts |

### Spawning a Group from a Trigger Script

```lua
function onActivate(trigger, player)
    local group = SpawnGroups.get("EnemyWave1")
    if group then
        group:spawn()
    end
end
```

### SpawnGroup Methods

| Method | Description |
|--------|-------------|
| `group:spawn()` | Spawn all units in the group |
| `group:despawn()` | Remove all living units in the group |
| `group:isAlive() → bool` | Returns `true` if any unit in the group is still alive |
| `group:getUnits() → {Unit}` | Returns a table of unit references |
| `group:setPosition(Vector3)` | Move the group spawn point at runtime |

### SpawnGroup Events

SpawnGroups emit events you can listen to from trigger scripts:

```lua
function onInit(trigger)
    local group = SpawnGroups.get("EnemyWave1")
    if group then
        group.Eliminated:Connect(function()
            print("All enemies in EnemyWave1 are down!")
            trigger:activate()
        end)
    end
end
```

---

## Objective

An **Objective** marks a mission goal. It appears in the HUD and can be active, pending, or complete.

### Objective Properties

| Property | Type | Description |
|----------|------|-------------|
| `Name` | string | Identifier |
| `Title` | string | Display text shown in the HUD |
| `Type` | enum | `Capture`, `Destroy`, `Defend`, `Reach`, `Eliminate`, `Custom` |
| `Position` | Vector3 | World position for map markers |
| `ActiveOnStart` | bool | Show from mission start |
| `MarkerColor` | Color3 | Colour of the map/HUD marker |

### Objective Methods

| Method | Description |
|--------|-------------|
| `obj:activate()` | Make the objective active (visible in HUD) |
| `obj:complete()` | Mark the objective as complete |
| `obj:fail()` | Mark the objective as failed |
| `obj:setTitle(text)` | Update the HUD text at runtime |
| `obj:isComplete() → bool` | Returns `true` if the objective is finished |

### Using Objectives in Scripts

```lua
function onInit(trigger)
    local obj = Objectives.get("SecureZoneA")
    obj:activate()
end

function onEnter(trigger, character)
    local players = trigger:getPlayers()
    if #players >= 3 then
        local obj = Objectives.get("SecureZoneA")
        obj:complete()
    end
end
```

---

## Gate

A **Gate** is a physical barrier (door, gate, or roadblock) that can be opened or closed via script.

### Gate Properties

| Property | Type | Description |
|----------|------|-------------|
| `Name` | string | Identifier |
| `Position` | Vector3 | World position |
| `State` | enum | `Open` or `Closed` (initial state) |
| `AutoClose` | bool | Close automatically after a delay |
| `AutoCloseDelay` | number | Seconds before auto-close |
| `LockedOnStart` | bool | Prevents scripted or manual opening until unlocked |

### Gate Methods

| Method | Description |
|--------|-------------|
| `gate:open()` | Open the gate |
| `gate:close()` | Close the gate |
| `gate:lock()` | Prevent the gate from being opened |
| `gate:unlock()` | Allow the gate to be opened again |
| `gate:isOpen() → bool` | Returns `true` if currently open |

### Gate Script Example

```lua
function onActivate(trigger, player)
    local gate = Gates.get("MainGate")
    if gate then
        gate:open()
        trigger:setTimer(10, "autoclose")
    end
end

function onTimer(trigger, timerID)
    if timerID == "autoclose" then
        local gate = Gates.get("MainGate")
        if gate then gate:close() end
    end
end
```

---

## Vehicle

A **Vehicle** is a spawnable land, sea, or air vehicle. Vehicles can be pre-placed on the map or spawned by script.

### Vehicle Types

| Type | Category | Description |
|------|----------|-------------|
| `Humvee` | Land | Light utility vehicle; 4 seats |
| `Truck` | Land | Transport; up to 8 seats |
| `LAV` | Land | Light armoured vehicle with roof gun |
| `Tank` | Land | Main battle tank |
| `Zodiac` | Sea | Inflatable assault boat |
| `MH-6` | Air | Light scout / extraction helicopter |
| `UH-60` | Air | Medium transport helicopter |
| `AH-64` | Air | Attack helicopter with rockets |
| `A-10` | Air | Fixed-wing close-air-support aircraft |

### Vehicle Properties (Editor)

| Property | Type | Description |
|----------|------|-------------|
| `Name` | string | Identifier |
| `Type` | enum | Vehicle type (see table above) |
| `Position` | Vector3 | Spawn location |
| `Orientation` | Vector3 | Initial facing direction |
| `Faction` | enum | `BLUFOR`, `OPFOR`, `Neutral` |
| `ActiveOnStart` | bool | Spawn at mission start |
| `Respawn` | bool | Respawn after destruction |
| `RespawnDelay` | number | Seconds before respawning |
| `Locked` | bool | If `true`, only AI crew can operate it |

### Vehicle Methods

| Method | Description |
|--------|-------------|
| `vehicle:spawn()` | Spawn the vehicle at its defined position |
| `vehicle:despawn()` | Remove the vehicle |
| `vehicle:isAlive() → bool` | Returns `true` if vehicle is not destroyed |
| `vehicle:setLocked(bool)` | Lock or unlock the vehicle for players |
| `vehicle:getPosition() → Vector3` | Current world position |

### Vehicle Script Example

```lua
function onActivate(trigger, player)
    local helo = Vehicles.get("ExtractionBlackhawk")
    if helo then
        helo:spawn()
        helo:setLocked(false)
        print("Extraction helicopter has arrived!")
    end
end
```

---

## Environmental Objects

### Weather & Time

These are controlled via the **Settings** tab or by script:

```lua
-- Change weather
Environment.setWeather("Rain")   -- "Clear", "Overcast", "Rain", "Fog", "Storm"

-- Change time of day (0–24 hour float)
Environment.setTime(22.5)        -- 10:30 PM

-- Toggle night-vision for all players
Environment.setNightVision(true)
```

### Props and Barriers

Placed via the **Objects** tab. Script interaction is limited; however, some named props support:

```lua
local prop = Props.get("RadioTower")
if prop then
    prop:destroy()
end
```

---

## See Also

- [RGE Overview](rge-overview.md)
- [Trigger Event Handlers](rge-triggers.md)
- [Full API Reference](rge-api-reference.md)
