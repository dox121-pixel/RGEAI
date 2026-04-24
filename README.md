# RGEAI — AI-Assisted Scripting for BRM5 RGE

A community resource for using AI tools to build, code, and document missions in the **Blackhawk Rescue Mission 5 (BRM5)** [Real-time Game Editor (RGE)](https://www.roblox.com/games/920587237). This repo collects everything known about the RGE scripting system, documents trigger events and API functions, and provides ready-to-use Lua script templates you can paste directly into the in-game editor.

---

## What is BRM5 RGE?

**Blackhawk Rescue Mission 5** is a military-simulation Roblox game. Its built-in **Real-time Game Editor (RGE)** lets players create custom maps and missions without leaving the game. After the GEN 4 / RGE 2 update, scripted **Triggers** were introduced — small Lua programs attached to areas or objects that react to players and game state.

The RGE editor contains several tabs:

| Tab | Purpose |
|-----|---------|
| **Objects** | Place props, buildings, barriers, and terrain |
| **Entities** | Spawn NPC soldiers, vehicles, and AI units |
| **Triggers** | Create scriptable zones / interactive objects |
| **Settings** | Mission name, team limits, weather, time-of-day |

---

## Repository Layout

```
RGEAI/
├── README.md                   ← You are here
├── docs/
│   ├── rge-overview.md         ← RGE editor overview and getting started
│   ├── rge-triggers.md         ← Trigger types, event handlers, and properties
│   ├── rge-objects.md          ← Placeable objects: SpawnGroup, Objective, Gate, Vehicle
│   └── rge-api-reference.md    ← Full scripting API reference
└── scripts/
    └── examples/
        ├── basic-trigger.lua          ← Minimal "player enters zone" example
        ├── mission-flow.lua           ← Multi-stage mission sequence
        └── spawn-and-objective.lua    ← Spawn enemies and track objective
```

---

## Quick Start

1. Open BRM5 on Roblox and enter the **Real-time Game Editor**.
2. Switch to the **Triggers** tab and place a trigger volume on the map.
3. Click the trigger, open its **Script** panel, and paste one of the example scripts from `scripts/examples/`.
4. Press **Play** to test — use `print()` statements to see debug output in the console.

---

## Documentation

- [RGE Overview](docs/rge-overview.md)
- [Triggers & Event Handlers](docs/rge-triggers.md)
- [Placeable Objects Reference](docs/rge-objects.md)
- [Full API Reference](docs/rge-api-reference.md)

---

## Contributing

This repo is a living document — the RGE scripting system is updated frequently. If you discover new functions, properties, or trigger types:

1. Fork the repo and add your findings to the relevant `docs/` file.
2. Add a matching example under `scripts/examples/` if applicable.
3. Open a pull request with a short description of the change.

---

## Resources

- [BRM5 on Roblox](https://www.roblox.com/games/920587237)
- [BRM5 Fandom Wiki – RGE page](https://roblox-blackhawk-rescue-mission-5.fandom.com/wiki/Real-time_Game_Editor)
- Community Discord: search "BRM5" or "Project Lazarus 5" on Discord for active scripting channels
- YouTube: search "BRM5 RGE trigger tutorial" for video walkthroughs
