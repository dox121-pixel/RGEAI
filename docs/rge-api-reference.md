# RGE Scripting API Reference

This is the most complete community-sourced reference for the Lua scripting API available inside BRM5 trigger scripts. Functions and objects marked ⚠️ are unconfirmed or may vary by RGE version — test in-game before relying on them.

---

## Global Namespaces

| Namespace | Description |
|-----------|-------------|
| `Triggers` | Lookup and manage trigger objects |
| `SpawnGroups` | Lookup and manage NPC spawn groups |
| `Objectives` | Lookup and manage mission objectives |
| `Gates` | Lookup and manage gate objects |
| `Vehicles` | Lookup and manage vehicle objects |
| `Props` | Lookup named prop objects ⚠️ |
| `Environment` | Control weather, time, and global effects |
| `Mission` | Mission-level control (win, lose, messages) |
| `Players` | Iterate or query players in the server |

---

## Triggers Namespace

```lua
Triggers.get(name: string) → Trigger | nil
```
Returns the trigger with the given name, or `nil` if not found.

```lua
Triggers.getAll() → {Trigger}
```
Returns all triggers in the mission. ⚠️

```lua
Triggers.create(properties: table) → Trigger
```
Dynamically create a new trigger at runtime. ⚠️

---

## Trigger Object

### Properties

| Property | Type | Read | Write | Description |
|----------|------|------|-------|-------------|
| `Name` | string | ✓ | — | Trigger name set in editor |
| `Position` | Vector3 | ✓ | ✓ | World position |
| `Size` | Vector3 | ✓ | ✓ | Volume dimensions |
| `Active` | bool | ✓ | — | Is the trigger currently active |

### Methods

```lua
trigger:activate()
```
Manually fires `onActivate` on this trigger.

```lua
trigger:deactivate()
```
Manually fires `onDeactivate` on this trigger.

```lua
trigger:isActive() → bool
```
Returns `true` if the trigger is currently in an active state.

```lua
trigger:setTimer(seconds: number, id: string)
```
Starts a countdown timer. When it expires, `onTimer(trigger, id)` fires. Multiple timers with different IDs can run simultaneously.

```lua
trigger:cancelTimer(id: string)
```
Cancels a running timer before it fires.

```lua
trigger:getPlayers() → {Player}
```
Returns all Roblox `Player` instances currently inside the trigger volume.

```lua
trigger:destroy()
```
Permanently removes the trigger from the world.

```lua
trigger:setVisible(visible: bool)
```
Shows or hides the trigger zone wireframe during play mode.

```lua
trigger:setTeamFilter(team: string)
```
Restricts which team's players can activate this trigger.  
Valid values: `"Any"`, `"BLUFOR"`, `"OPFOR"`

---

## SpawnGroups Namespace

```lua
SpawnGroups.get(name: string) → SpawnGroup | nil
```

### SpawnGroup Object

```lua
group:spawn()
```
Spawn all units in the group at the group's defined position.

```lua
group:despawn()
```
Instantly remove all living units in the group from the world.

```lua
group:isAlive() → bool
```
Returns `true` if at least one unit in the group is still alive.

```lua
group:getUnits() → {Unit}
```
Returns a table of unit references currently spawned by this group.

```lua
group:setPosition(position: Vector3)
```
Move the spawn origin before calling `spawn()`. ⚠️

### SpawnGroup Events (Signal-style)

```lua
group.Eliminated:Connect(function()
    -- all units are dead
end)

group.Spawned:Connect(function(units)
    -- group just spawned; units = list of spawned NPCs
end)
```

---

## Objectives Namespace

```lua
Objectives.get(name: string) → Objective | nil
```

### Objective Object

```lua
obj:activate()
```
Makes the objective visible and active in the HUD.

```lua
obj:complete()
```
Marks the objective as complete (green checkmark in HUD).

```lua
obj:fail()
```
Marks the objective as failed (red cross in HUD).

```lua
obj:setTitle(text: string)
```
Updates the HUD display text at runtime.

```lua
obj:isComplete() → bool
```
Returns `true` if the objective has been completed.

```lua
obj:isFailed() → bool
```
Returns `true` if the objective has failed. ⚠️

---

## Gates Namespace

```lua
Gates.get(name: string) → Gate | nil
```

### Gate Object

```lua
gate:open()
gate:close()
gate:lock()
gate:unlock()
gate:isOpen() → bool
gate:isLocked() → bool  -- ⚠️
```

---

## Vehicles Namespace

```lua
Vehicles.get(name: string) → Vehicle | nil
```

### Vehicle Object

```lua
vehicle:spawn()
vehicle:despawn()
vehicle:isAlive() → bool
vehicle:setLocked(locked: bool)
vehicle:getPosition() → Vector3
vehicle:getOccupants() → {Player}   -- ⚠️
```

---

## Props Namespace ⚠️

```lua
Props.get(name: string) → Prop | nil
prop:destroy()
prop:setVisible(bool)   -- ⚠️
```

---

## Environment Namespace

```lua
Environment.setWeather(weather: string)
```
Valid values: `"Clear"`, `"Overcast"`, `"Rain"`, `"Fog"`, `"Storm"`

```lua
Environment.setTime(hour: number)
```
24-hour float. Example: `6.5` = 6:30 AM, `22.0` = 10:00 PM.

```lua
Environment.setNightVision(enabled: bool)    -- ⚠️
```
Enables or disables night-vision for all players.

```lua
Environment.setFogDensity(density: number)   -- ⚠️
```
Range 0–1. Higher = thicker fog.

---

## Mission Namespace

```lua
Mission.win()
```
Immediately end the mission with a victory screen.

```lua
Mission.lose()
```
Immediately end the mission with a defeat screen.

```lua
Mission.sendMessage(text: string, duration: number)
```
Display a temporary message to all players (centre of screen). Duration is in seconds.

```lua
Mission.sendObjectiveText(text: string)   -- ⚠️
```
Update the persistent objective text bar at the bottom of the HUD.

```lua
Mission.setRespawnEnabled(enabled: bool)   -- ⚠️
```
Enable or disable player respawning for the remainder of the mission.

```lua
Mission.getElapsedTime() → number   -- ⚠️
```
Returns seconds since the mission started.

---

## Players Namespace

```lua
Players.getAll() → {Player}
```
Returns all players currently in the server.

```lua
Players.getByName(name: string) → Player | nil
```
Look up a player by their Roblox username.

```lua
Players.getBlufor() → {Player}
Players.getOpfor() → {Player}
```
Returns players filtered by team. ⚠️

### Player Object (extended properties available in scripts)

```lua
player.Name        -- Roblox username (string)
player.Character   -- Character Model in workspace
player.Team        -- "BLUFOR" or "OPFOR"
```

### Teleport a Player

```lua
local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
if hrp then
    hrp.CFrame = CFrame.new(100, 10, -200)
end
```

---

## Utility Functions

These are available globally in every trigger script.

### `print(text: string)`

Outputs text to the RGE developer console. Useful for debugging.

```lua
print("Debug: player entered zone")
```

### `warn(text: string)`

Like `print()` but highlighted as a warning. ⚠️

### `wait(seconds: number)`

Yields the current script thread for the specified duration. Use sparingly in event handlers — prefer `trigger:setTimer()` for delays longer than a fraction of a second.

```lua
wait(1)
print("1 second later")
```

### `Vector3.new(x, y, z)`

Construct a Vector3 position or size value.

```lua
local pos = Vector3.new(100, 5, -200)
```

### `CFrame.new(x, y, z)`

Construct a CFrame (position + rotation).

```lua
local cf = CFrame.new(100, 5, -200)
```

### `Color3.fromRGB(r, g, b)`

Construct a colour value.

```lua
local red = Color3.fromRGB(255, 0, 0)
```

---

## Events / Signal Pattern

Several game objects expose Signal-style events. Connect a callback using `:Connect()`:

```lua
local group = SpawnGroups.get("Wave1")
group.Eliminated:Connect(function()
    Mission.win()
end)
```

Connections persist for the lifetime of the trigger script.

---

## Known Limitations

- Scripts run in a **sandboxed Lua 5.1 environment** — not all standard Lua libraries are available.
- The `require()` function is **not available** inside trigger scripts; each trigger is self-contained.
- Long `wait()` chains inside event handlers can cause lag; use `trigger:setTimer()` for delays instead.
- Some API functions marked ⚠️ are community-discovered and may not work in all RGE versions.
- The `tween` and `explosion` commands are **console commands** — they cannot be called directly from a trigger Lua script. Use them via the RGE console, or combine triggers with timed console sequences where needed.

---

## Console Commands Quick Reference

The following commands are entered directly in the RGE console (not in trigger scripts). They are included here for completeness; see the RGE Guide for full syntax details.

> `[ ]` = placeholder — do not include the brackets in the final command.  
> `|` = separates alternative arguments.  
> `pX/pY/pZ` = position on each axis. `rX/rY/rZ` = rotation. `sX/sY/sZ` = size.

| Command | Short Description |
|---------|-------------------|
| `ban [player]` | Ban a named player from the private server |
| `compounds [enable\|disable]` | Enable/disable preset enemies on the Ronograd map |
| `create [world] [part\|wedge\|corner\|cylinder\|ball] [pX] [pY] [pZ]` | Create a part |
| `color [world] [UID\|%var] [r] [g] [b]` | Set object colour |
| `delete [world] [UID\|%var]` | Delete an object |
| `duplicate [world] [UID\|%var]` | Duplicate an object |
| `explosion [Radius] [Damage] [pX] [pY] [pZ] [Type]` | Create an explosion — see Explosion Types below |
| `file insertmodel [world] [name] [pX] [pY] [pZ] [r]` | Spawn a saved model |
| `file [savemodel\|deletemodel] [name]` | Save or delete a custom model |
| `file list` | List saved worlds |
| `file [save\|load\|delete] [name]` | Save, load, or delete a world file |
| `file [savecopy\|loadcopy] [name]` | Save/load a world file when not the server owner |
| `firstperson [lock\|unlock]` | Lock/unlock all players to first-person view |
| `friendlyfire [disable\|squad\|all]` | Control PVP friendly fire |
| `hud [disable\|enable]` | Forcefully show or hide the HUD for all players |
| `kick [player]` | Kick a named player |
| `material [world] [UID\|%var] [material]` | Set object material |
| `move [world] [UID\|%var] [pX] [pY] [pZ] [rX] [rY] [rZ]` | Teleport an object |
| `navmesh [enable\|disable\|editor\|confirm]` | Manage the custom navmesh |
| `respawn [all\|others]` | Respawn all players or all except self |
| `respawn [squad\|player] [name]` | Respawn a squad or a specific player |
| `revive [disable\|enable]` | Allow or prevent player revival |
| `serverlock [enable\|disable]` | Block/allow new players from joining |
| `size [world] [UID\|%var] [sX] [sY] [sZ]` | Resize an object |
| `squad [player] [none\|red\|blue\|orange\|yellow\|green]` | Set a player's squad |
| `squadchanging [disable\|enable]` | Lock or unlock squad-changing |
| `squadspawn [pX] [pY] [pZ] [r] [squad]` | Set a squad's spawnpoint |
| `teleport [player\|squad\|all] [name] [pX] [pY] [pZ] [r]` | Teleport a player, squad, or all |
| `time [start\|stop]` | Start or stop the day/night cycle |
| `time now` | Print current time to console |
| `time set [time]` | Set time of day |
| `transparency [world] [UID\|%var] [0–1]` | Set object transparency |
| `trigger ...` | See [rge-triggers.md](rge-triggers.md) for full trigger command reference |
| `tween [world] [UID\|%var] [Duration] [pX] [pY] [pZ] [rX] [rY] [rZ]` | Smoothly move an object |
| `world [list\|load] [name] [world]` | Deprecated — load saves from before RGE 2.0 |

---

## Explosion Types

Used with the `explosion` console command's `[Type]` argument:

| Type | Effect |
|------|--------|
| `None` | No visual effect or sound |
| `Grenade` | Grenade explosion effect |
| `Mine` | Mine explosion effect (as seen in Rono City / Fort) |
| `Motar` | Mortar round impact effect *(note: intentional in-game spelling)* |
| `ObjBig` | Large objective explosion (radar, planted explosive) |
| `GroundVehicle` | Ground vehicle destruction (jeep, SRTV) |
| `HelicopterVehicle` | Helicopter shot-down explosion |
| `C4` | C4 charge explosion |
| `RPG7v2` | Fired RPG projectile impact |
| `Flash` | Flashbang detonation effect |
| `Breach` | Breaching charge effect |
| `Igla` | Unused effect |

---

## See Also

- [RGE Overview](rge-overview.md)
- [Trigger Event Handlers](rge-triggers.md)
- [Placeable Objects Reference](rge-objects.md)
