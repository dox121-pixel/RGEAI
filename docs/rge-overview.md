# RGE Overview — Real-time Game Editor

## What is the RGE?

The **Real-time Game Editor (RGE)** is an in-game map and mission creation tool built into **Blackhawk Rescue Mission 5 (BRM5)** on Roblox. It allows players to design custom scenarios, place objects and AI units, define objectives, and — since the **GEN 4 / RGE 2** update — write Lua scripts attached to **Trigger** objects.

The editor runs live inside the game world, meaning changes are reflected instantly without leaving the server.

---

## Accessing the RGE

1. Launch **Blackhawk Rescue Mission 5** on Roblox.
2. From the main lobby, open the **Settings / Mission** menu.
3. Select **Edit Mission** or **Create Mission** — this puts the server into editor mode.
4. The RGE toolbar appears at the top/side of the screen.

> **Note:** You must have the appropriate game pass or permissions to access mission-editing features on a private server.

---

## Editor Interface

### Tabs

| Tab | Icon | Purpose |
|-----|------|---------|
| **Objects** | Cube | Place terrain, props, buildings, barriers, crates, and other static assets |
| **Entities** | Person | Spawn AI soldiers, vehicle crew, and enemy units |
| **Triggers** | Lightning bolt | Create scriptable zones and interactive objects |
| **Vehicles** | Helicopter | Spawn land, sea, and air vehicles on the map |
| **Settings** | Gear | Mission-wide settings: name, description, team caps, weather, time-of-day |

### Toolbar Actions

- **Select (S)** — click objects to select and move them
- **Translate (G)** — drag-to-move a selected object
- **Rotate (R)** — rotate a selected object
- **Scale** — resize an object (some objects have fixed scale)
- **Delete (X)** — remove the selected object
- **Undo / Redo (Ctrl+Z / Ctrl+Y)** — step through your edit history
- **Save** — persist the current state of the mission to the cloud
- **Playtest** — switch into play mode to test the mission; editor changes are paused

---

## Creating a Trigger (Step-by-step)

1. Open the **Triggers** tab.
2. Choose a trigger shape: **Box** (rectangular zone) or **Sphere** (radial zone).
3. Click on the map to place it; resize with the Scale handle.
4. With the trigger selected, open its **Properties** panel on the right.
5. Set a **Name** — this is how other triggers and scripts refer to this trigger.
6. Click **Edit Script** to open the Lua scripting window.
7. Write your Lua code using the event handlers documented in [rge-triggers.md](rge-triggers.md).
8. Click **Apply / Save** in the script window.
9. Press **Playtest** to run the mission and walk into the trigger zone to test it.

---

## Mission Lifecycle

```
Server starts (or mission is loaded)
        │
        ▼
  onInit() fires on all triggers   ← optional setup
        │
        ▼
  Players join and play
        │
   ┌────┴────────────────────┐
   │  Triggers fire events:  │
   │  onEnter / onExit       │
   │  onActivate             │
   │  onTimer                │
   │  onDamage               │
   └────┬────────────────────┘
        │
        ▼
  Mission ends (win / lose condition)
        │
        ▼
  onMissionEnd() fires (if defined)
```

---

## Tips and Best Practices

- **Name every trigger** — unnamed triggers are hard to reference from other scripts.
- **Use debounce variables** to prevent an `onEnter` event from firing dozens of times per second.
- **Chain triggers** — one trigger's `onActivate` can call `otherTrigger:activate()` to build a sequence.
- **Print liberally while testing** — use `print()` to trace execution; output appears in the developer console.
- **Save often** — editor sessions can time out; save after every meaningful change.

---

## Version History (Key Milestones)

| Version | Notable Change |
|---------|---------------|
| RGE 1.0 | Basic object placement, no scripting |
| RGE 2.0 (GEN 4) | Trigger objects and Lua scripting introduced |
| RGE 2.2 | Additional trigger event types, improved entity tab |

---

## Next Steps

- [Trigger Event Handlers & Properties →](rge-triggers.md)
- [Placeable Objects (SpawnGroup, Objective, Gate, Vehicle) →](rge-objects.md)
- [Full Scripting API Reference →](rge-api-reference.md)
