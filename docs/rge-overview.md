# RGE Overview — Real-time Game Editor

## What is the RGE?

The **Real-time Game Editor (RGE)** is an in-game map and mission creation tool built into **Blackhawk Rescue Mission 5 (BRM5)** on Roblox. It allows players to design custom scenarios, place objects and AI units, define objectives, and — since the **GEN 4 / RGE 2** update — write Lua scripts attached to **Trigger** objects.

The editor runs live inside the game world, meaning changes are reflected instantly without leaving the server.

> **Disclaimer:** This documentation is not an official document by Platinum 5.

---

## Accessing the RGE

1. Launch **Blackhawk Rescue Mission 5** on Roblox.
2. Press **P** to open the RGE editor panel.
3. The RGE toolbar appears at the top/side of the screen with all editing tabs.

> **Note:** You must have the appropriate game pass or permissions to access mission-editing features on a private server.

---

## Editor Interface

### Tabs

| Tab | Purpose |
|-----|---------|
| **Objects** | Place terrain, props, buildings, barriers, crates, and other static assets |
| **Entities** | Spawn AI soldiers, vehicle crew, and enemy units |
| **Triggers** | Create scriptable zones and interactive objects |
| **Vehicles** | Spawn land, sea, and air vehicles on the map |
| **AI** | Enable/disable Custom Navmesh and open the Navmesh editor |
| **Settings** | Mission-wide settings: name, description, team caps, weather, time-of-day |

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

## Controls & Camera

### Camera Movement

| Key | Action |
|-----|--------|
| **W** | Move camera forward |
| **S** | Move camera backward |
| **A** | Move camera left |
| **D** | Move camera right |
| **E** | Move camera up *(Cinematic and Studio camera only)* |
| **Q** | Move camera down *(Cinematic and Studio camera only)* |
| **Shift** | Slow camera movement |
| **Ctrl** | Disable camera movement *(used in hotkey combinations)* |
| **Mouse Wheel** | Zoom in/out (Cinematic & Topdown), or dolly forward/backward (Studio) |

### Hotkeys

| Hotkey | Action |
|--------|--------|
| **F** | Focus camera on selected object |
| **L** | Toggle fullscreen |
| **Delete / Backspace** | Delete selected object(s) |
| **Ctrl + Place** | Keep the object in hand after placing (place multiple copies) |
| **Ctrl + D** | Duplicate selected object |
| **Ctrl + Z** | Undo last action *(does **not** work on Delete)* |
| **Ctrl + G** | Group selected objects *(Parts only)* |
| **Ctrl + L** | Toggle World Space (global vs local transform handles) |
| **2** | Select Move tool |
| **3** | Select Scale tool |
| **4** | Select Rotate tool |
| **Double-click Console** | Move the console panel to the bottom of the screen |

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
- **Use the BRM5 Command Editor** ([triple-alt.github.io/brm5-command-editor](https://triple-alt.github.io/brm5-command-editor/editor.html)) to help build complex console commands.

---

## Known Bugs & Fixes

### Bug: Unable to Load Map — Stuck at "Baking Navmesh Data"

**Cause:** Loading a map on private server startup when the save includes a Custom Navmesh.

**Fix** *(untested — may not work in all cases)*:
1. Set the default private server map to `OW_Ronograd` or `OW_Blank` depending on what map your save was created on.
2. Load the private server and open the RGE.
3. Go to the **AI** tab and enable the Custom Navmesh.
4. Load your map through the console or the Load button.

---

### Bug *(FIXED)*: Unable to Enter Studio+ Camera / Trigger "Ghosts" on Parts

**Cause:** Saving a Custom Model that contains parts with **isTrigger** enabled. The saved model carries the trigger data, which corrupts camera mode and creates ghost trigger objects when the model is inserted.

**Fix:**
1. Search your Custom Model list for models that include trigger parts.
2. Delete any such model, or re-save it after turning **isTrigger** off on every part.

---

### Bug *(FIXED)*: Non-Owner Admins Cannot Use `savecopy` / `loadcopy`

**Cause:** Unknown.  
**Fix:** Unknown — this has been marked as fixed in a later update.

---

## Version History (Key Milestones)

| Version | Notable Change |
|---------|---------------|
| RGE 1.0 | Basic object placement, no scripting |
| RGE 2.0 (GEN 4) | Trigger objects and Lua scripting introduced |
| RGE 2.2 | Additional trigger event types, improved entity tab; Custom Navmesh editor added |

---

## Next Steps

- [Trigger Event Handlers & Properties →](rge-triggers.md)
- [Placeable Objects (SpawnGroup, Objective, Gate, Vehicle) →](rge-objects.md)
- [Full Scripting API Reference →](rge-api-reference.md)
- [Tutorial: Proximity Hunter (model that chases solo players) →](tutorial-proximity-hunter.md)
