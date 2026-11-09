# WWII Commander

A historically grounded, real-time WWII command simulation for Android, built with Godot 4.

## First playable target
- Theatre: Eastern Front, 1941
- Branch: German Army (Heer)
- Formation: German Panzer division (exact division and dated order of battle to be confirmed)
- Camera: elevated tactical view, zooming from a wide battlefield to close observation
- Graphics: detailed 3D battlefield balanced for Android performance
- Core experience: issue formation orders and observe the battle unfold in real time

## Design principles
1. Historical accuracy: date-specific commanders, formations, equipment, and command relationships must be researched and sourced.
2. Uncertain historical strengths and inventories must be labelled estimates until verified.
3. Command-first gameplay, not direct action control.
4. Android-first performance and offline-first core gameplay.
5. Free resources only unless the owner explicitly approves otherwise.
6. Record provenance and licences for all external assets.

## Development stages
1. 3D battlefield foundation.
2. Camera, terrain, roads, vegetation, and structures.
3. Unit representation and real-time movement.
4. Command interface and order execution.
5. Combat, morale, suppression, casualties, and logistics.
6. Historical campaign and persistence.
7. Air and naval branches.
8. Optimisation, Android testing, and release.

## Repository structure
- `docs/` — design, technical decisions, historical research, asset provenance.
- `scenes/` — Godot scenes.
- `scripts/` — gameplay and simulation code.
- `assets/` — licensed models, textures, audio.
- `tests/` — test plans and automated checks.

The repository currently starts with project documentation. A playable Godot project must be added and tested in subsequent commits; documentation alone is not a playable game.
