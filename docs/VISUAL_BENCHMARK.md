# Visual Benchmark — US Conflict-inspired realism

## Reference and intent
Use *US Conflict – Tank Battles* as the visual/performance reference approved by the owner. The target is stylized realism: recognisable historical equipment and believable terrain, lighting and atmosphere, without pursuing photorealism that would compromise Android performance. This is a visual benchmark, not a request to copy its maps, assets, UI, or proprietary content.

## Required battlefield presentation
- Natural-looking ground with visible variation in soil, grass and field surfaces; avoid one flat green/brown plane.
- Distinct tree silhouettes and grouped woodland rather than repeated spherical foliage.
- Villages with pitched roofs, varied building footprints, yards and connecting lanes.
- Readable roads, tracks, field boundaries, ridges, trenches and defensive positions.
- Directional sunlight, grounded shadows, restrained atmospheric distance haze and a coherent Eastern Front colour palette.
- Detailed silhouettes for tanks, guns, trucks and infantry; replace primitive placeholders progressively with optimised, historically researched models.
- Tactical camera must support a wide operational overview and close inspection.

## Scale and performance target
- Proposed design target: 8 km × 8 km operational area (64 km²), subject to a scale/layout pass before implementation. The current 640-unit prototype is not yet a verified 8 km map.
- Both opposing formations need deployment depth, manoeuvre space, reserve routes, flanking corridors, retreat routes and meaningful terrain objectives.
- Use level of detail, visibility ranges, instancing/multimesh vegetation, batched materials and mobile-friendly shadows where supported.
- Keep the Godot Compatibility renderer and Android-first profiling. Do not increase draw calls or real-time lights without measuring.
- Target smooth performance on the owner's Android handset; actual frame rate and memory must be measured on-device.

## Current visual pass
- Added procedural world-space ground colour variation and subtle distance fog.
- Replaced rounded tree crowns with layered conifer silhouettes.
- Replaced flat roof blocks with pitched roof planes.
- These are incremental procedural improvements, not yet equivalent to the reference game's production assets or polish.

## Acceptance checks
1. Godot headless import and runtime complete without errors.
2. Android debug APK exports successfully.
3. Owner confirms the APK launches and renders on the phone.
4. Inspect close and wide camera views for terrain readability, model silhouette and visual artefacts.
5. Check pan/zoom responsiveness and performance on the target handset before adding dense formations.
6. Keep the previous known-good APK available until the new build passes owner testing.
