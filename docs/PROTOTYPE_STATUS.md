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
