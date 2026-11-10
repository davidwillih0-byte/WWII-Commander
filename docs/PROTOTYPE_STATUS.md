# Phase 3 — Realistic Visual Upgrade Status

## Phase 2 phone feedback
The owner confirmed the Phase 2 map is wider than the first build, but still does not feel wide enough for friendly and enemy formations to manoeuvre. The next design target is a substantially more convincing operational battlefield.

## Phase 3 visual changes on branch `phase-3-realistic-visuals`
- Added world-space procedural ground colour variation to reduce the appearance of a single flat terrain colour.
- Added restrained distance fog for atmospheric depth.
- Changed tree crowns from rounded spheres to layered conifer silhouettes.
- Changed village roofs from flat blocks to pitched roof planes.
- Added `docs/VISUAL_BENCHMARK.md` defining the owner's US Conflict-inspired stylized-realistic visual target and Android performance acceptance checks.
- The proposed 8 km × 8 km operational area remains a design target; the current 640-unit world is not yet a verified 8 km map.

## Not yet verified
- Phase 3 has not yet passed the Android build or owner phone test.
- Procedural models remain placeholders and are not yet equivalent to US Conflict's production art.
- Map scale, two-sided deployment space, performance, memory and frame rate still require measurement.

## Next validation steps
1. Confirm Godot headless import/runtime and Android export succeed.
2. Install the new APK and inspect close and wide views.
3. Confirm no rendering errors, crashes or unacceptable slowdown.
4. Only then continue with terrain detail, asset quality and operational map layout.

---

# Phase 2 — Expanded Battlefield Prototype Status

## Working baseline
The owner installed and launched the previous Android debug APK on an Android phone. The owner confirmed that the scene opened, the battlefield rendered, the tank and infantry were visible, the camera controls worked, and there was no grey screen or crash. This is the verified baseline to preserve.

## Phase 2 changes on branch `phase-2-large-battlefield`
- Expanded the procedural terrain footprint from 240 to 640 world units.
- Increased the tactical camera's maximum zoom distance and adjusted its initial view for the wider area.
- Added a camera target/pivot so panning moves the viewed area across the expanded map instead of only shifting the camera around the origin.
- Extended the road network with secondary east-west and north-south routes.
- Added additional agricultural field plots, woodland belts, ridgelines, field-edge farmsteads, defensive trenches, and three small settlements.
- Kept the procedural low-poly approach and Compatibility renderer to limit Android asset and rendering costs.

## Not yet verified
- This Phase 2 branch has not yet been run through Godot import/runtime validation or exported to a new APK.
- The expanded battlefield has not yet been tested on the owner's phone.
- Actual map traversal, frame rate, memory use, and touch camera behaviour across the full map remain to be checked.
- No real-time unit movement, command orders, combat simulation, pathfinding, enemy AI, division roster, or campaign system is implemented yet.
- Models remain procedural placeholders, not historically accurate production assets.

## Next validation steps
1. Run the Android debug workflow from this branch.
2. Confirm the exported APK artifact contains the expected APK.
3. Install the new APK on the target phone and test launch, pan, pinch zoom, and performance.
4. If the larger map is stable, proceed to selectable formations and real-time movement orders.

## Controls
- One-finger drag: pan camera.
- Two-finger pinch: zoom.
- Desktop left-drag: pan.
- Desktop mouse wheel: zoom.

Do not describe Phase 2 as phone-tested until the owner reports a successful test of the new APK.
