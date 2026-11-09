# Technical Plan

## Engine
Godot 4.x. Pin the exact minor version and renderer when adding the first project files, after considering the target Android device.

## Architecture direction
- Scene-based 3D world.
- Separate battlefield presentation from simulation state.
- Data-driven unit and formation definitions.
- Command/order layer separated from movement and combat execution.
- Configurable mobile quality settings.
- Offline save data for campaign state.

## First implementation milestone
Create a minimal valid Godot project containing:
- `project.godot`
- Main 3D battlefield scene
- Camera rig with tactical zoom
- Terrain foundation and simple placeholder environment
- Run instructions and Android export notes

The milestone must open in Godot 4 and run before additional systems are layered on.

## Mobile constraints
Profile on the target phone early. Control draw calls, material complexity, shadow distance, and transparent effects. Use LODs and visibility ranges for vegetation and structures. Avoid many expensive real-time lights. Provide a low-quality fallback profile. APK testing on the target device is mandatory.

## Source control
Keep the default branch stable. Use feature branches for substantial work. Commit coherent increments. Inspect existing files before overwriting.

## Build pipeline
Add a cloud Android build workflow only after project structure and engine version are verified. Do not assume build minutes or external services are unlimited. Paid services require explicit approval.
