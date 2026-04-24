# RGE Triggers — Event Handlers & Properties

Triggers are the core scripting primitive in the RGE. Each trigger is a 3-D volume (box or sphere) that fires Lua event handlers when conditions are met. Scripts are attached directly to the trigger object inside the editor.

The trigger system has two layers:
1. **Console commands** — used in the in-game console to create trigger groups, assign objects to them, and configure their behaviour.
2. **Trigger scripts (Lua)** — Lua code that runs automatically when a trigger fires an event.

---

## Console Commands — Setting Up Triggers

These commands are entered in the RGE console. `[world]` is the world slice (e.g. `w1`), `[UID | %variableName]` is the object identifier, and `[Trigger Group Name]` is a string you choose.

| Command | Function | Usage |
|---------|----------|-------|
| `trigger add` / `trigger remove` | Adds or removes a trigger volume from an object | `trigger [add\|remove] [world] [UID\|%name]` |
| `trigger addbutton` / `trigger removebutton` | Adds or removes an interaction button (press **E**) to a trigger object | `trigger [addbutton\|removebutton] [world] [UID\|%name]` |
| `trigger set` | Assigns a trigger object to a Trigger Group | `trigger set [world] [UID\|%name] [Group] [true\|false]` |
| `trigger activate` / `trigger reset` | Activates or resets a Trigger Group | `trigger [activate\|reset] [world] [Group]` |
| `trigger create` / `trigger delete` | Creates or deletes a Trigger Group | `trigger [create\|delete] [world] [Group]` |
| `trigger color` | Sets the display colour of a Trigger Group wireframe | `trigger color [world] [Group] [0–255] [0–255] [0–255]` |
| `trigger whitelist` | Sets which entity types can interact with a Trigger Group | `trigger whitelist [world] [Group] [Players\|Bots\|Helicopters\|Ground] [true\|false]` |
| `trigger whitelist IsLooping` | Makes the trigger continuously repeat (loop) upon loading in | `trigger whitelist [world] [Group] IsLooping [true\|false]` |
| `trigger executable` | ⛔ **DO NOT USE** — see [Discord warning](https://discord.com/channels/553917324340625424/1154567586948849735/1490605944390942810) | — |

### Trigger Whitelist Entity Types

| Value | Who can activate |
|-------|-----------------|
| `Players` | Human players |
| `Bots` | AI soldier units |
| `Helicopters` | Helicopter vehicles |
| `Ground` | Ground vehicles |

### IsLooping

Setting `IsLooping true` on a Trigger Group makes it re-fire automatically and continuously. Use with care — looping triggers cannot be reset with the `reset` script command.

---

## Trigger Script Commands (inside Lua scripts)

Two special commands are available inside trigger Lua scripts in addition to the full Lua API:

| Command | Description | Usage |
|---------|-------------|-------|
| `wait` | Pauses script execution for the specified number of seconds | `wait(seconds)` |
| `reset` | Resets the trigger group; **does not work on looping triggers** — must be the last executed line | `reset` |

---

## Trigger Properties (Editor Panel)

| Property | Type | Description |
|----------|------|-------------|
| `Name` | string | Unique identifier; used to reference this trigger from other scripts |
| `Shape` | enum | `Box` or `Sphere` |
| `Size` | Vector3 | Dimensions of the trigger volume |
| `Position` | Vector3 | World-space position |
| `Orientation` | Vector3 | Rotation (Euler angles) |
| `Team Filter` | enum | `Any`, `BLUFOR`, `OPFOR` — which team can activate it |
| `Single Use` | bool | If `true`, the trigger fires once then deactivates permanently |
| `Cooldown` | number | Seconds before the trigger can fire again after activation |
| `Visible in Play` | bool | Show/hide the trigger zone wireframe during play mode |
| `Active on Start` | bool | If `false`, the trigger starts dormant and must be activated by script |

---

## Event Handler Functions

Define these functions at the top level of the trigger's script. RGE calls them automatically when the corresponding event occurs.

### `onInit(trigger)`

Called once when the mission starts or the trigger is first loaded. Use it for one-time setup.

```lua
function onInit(trigger)
    print(trigger.Name .. " initialised")
end
```

---

### `onEnter(trigger, character)`

Called when a player's character walks into the trigger volume.

| Parameter | Type | Description |
|-----------|------|-------------|
| `trigger` | Trigger | The trigger object itself |
| `character` | Model | The Roblox character model that entered |

```lua
function onEnter(trigger, character)
    local player = game.Players:GetPlayerFromCharacter(character)
    if player then
        print(player.Name .. " entered " .. trigger.Name)
    end
end
```

---

### `onExit(trigger, character)`

Called when a player's character leaves the trigger volume.

```lua
function onExit(trigger, character)
    local player = game.Players:GetPlayerFromCharacter(character)
    if player then
        print(player.Name .. " left " .. trigger.Name)
    end
end
```

---

### `onActivate(trigger, player)`

Called when the trigger is manually activated — either by a player pressing the interact key (default **E**) or by another script calling `trigger:activate()`.

```lua
function onActivate(trigger, player)
    print((player and player.Name or "Script") .. " activated " .. trigger.Name)
    trigger:setTimer(10, "countdown")
end
```

---

### `onDeactivate(trigger, player)`

Called when the trigger is deactivated — either by a player interaction or by `trigger:deactivate()`.

```lua
function onDeactivate(trigger, player)
    print(trigger.Name .. " deactivated")
end
```

---

### `onTimer(trigger, timerID)`

Called when a timer started with `trigger:setTimer()` expires.

| Parameter | Type | Description |
|-----------|------|-------------|
| `trigger` | Trigger | The trigger object |
| `timerID` | string | The ID string passed to `setTimer` |

```lua
function onTimer(trigger, timerID)
    if timerID == "countdown" then
        print("Countdown complete!")
    end
end
```

---

### `onDamage(trigger, character, amount, source)`

Called when the trigger object receives damage (useful for destructible props linked to a trigger).

| Parameter | Type | Description |
|-----------|------|-------------|
| `trigger` | Trigger | The trigger |
| `character` | Model | Character that dealt the damage |
| `amount` | number | Damage amount |
| `source` | Instance | The weapon/part that caused the damage |

```lua
function onDamage(trigger, character, amount, source)
    print(trigger.Name .. " took " .. amount .. " damage")
end
```

---

### `onMissionEnd(trigger, result)`

Called when the mission ends. `result` is `"win"` or `"lose"`.

```lua
function onMissionEnd(trigger, result)
    print("Mission ended: " .. result)
end
```

---

## Trigger Methods (Callable from Script)

These methods are available on the `trigger` object passed to every event handler, and can also be called from other triggers that have a reference to this trigger.

| Method | Signature | Description |
|--------|-----------|-------------|
| `activate` | `trigger:activate()` | Manually activate the trigger (fires `onActivate`) |
| `deactivate` | `trigger:deactivate()` | Manually deactivate the trigger |
| `isActive` | `trigger:isActive() → bool` | Returns `true` if the trigger is currently active |
| `setTimer` | `trigger:setTimer(seconds: number, id: string)` | Start a countdown; fires `onTimer(trigger, id)` on expiry |
| `cancelTimer` | `trigger:cancelTimer(id: string)` | Cancel a running timer before it fires |
| `getPlayers` | `trigger:getPlayers() → {Player}` | Returns all players currently inside the trigger volume |
| `destroy` | `trigger:destroy()` | Remove the trigger from the world |
| `setVisible` | `trigger:setVisible(bool)` | Show or hide the trigger wireframe in play mode |
| `setTeamFilter` | `trigger:setTeamFilter(team: string)` | Change the team filter at runtime (`"Any"`, `"BLUFOR"`, `"OPFOR"`) |

---

## Debounce Pattern

Prevent `onEnter` from firing multiple times in rapid succession:

```lua
local entered = false

function onEnter(trigger, character)
    if entered then return end
    entered = true

    local player = game.Players:GetPlayerFromCharacter(character)
    if player then
        print(player.Name .. " triggered the area!")
    end

    trigger:setTimer(2, "reset")
end

function onTimer(trigger, timerID)
    if timerID == "reset" then
        entered = false
    end
end
```

---

## Chaining Triggers

Triggers can reference each other by name using a global lookup function (exact API may vary by RGE version; adjust if needed):

```lua
-- In TriggerA's onActivate:
function onActivate(trigger, player)
    local triggerB = Triggers.get("TriggerB")
    if triggerB then
        triggerB:activate()
    end
end
```

---

## Team Filtering Example

Only BLUFOR players entering the zone will trigger the event:

```lua
function onInit(trigger)
    trigger:setTeamFilter("BLUFOR")
end

function onEnter(trigger, character)
    print("BLUFOR soldier entered the zone")
end
```

---

## See Also

- [RGE Overview](rge-overview.md)
- [Placeable Objects Reference](rge-objects.md)
- [Full API Reference](rge-api-reference.md)
- [Tutorial: Proximity Hunter](tutorial-proximity-hunter.md)
