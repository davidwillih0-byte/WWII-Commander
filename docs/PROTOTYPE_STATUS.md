# First 3D Battlefield Prototype — Status

## Files added
- `project.godot`: Godot 4 project settings using the Compatibility renderer.
- `scenes/main.tscn`: main scene.
- `scripts/battlefield.gd`: procedural 3D battlefield blockout, environment, placeholder vehicles/infantry, HUD, and camera input.

## Included in this milestone
- Large flat terrain blockout with field clearings.
- Roads, low terrain mounds, tree belts, and a small settlement.
- Simple original placeholder tank silhouettes and infantry figures.
- Elevated tactical camera.
- Mouse drag and wheel zoom for editor/desktop testing.
- One-finger touch drag and two-finger pinch zoom for mobile testing.
- Basic battlefield identification HUD.

## Not included yet
- Historically accurate 3D vehicle or soldier models.
- Verified 7th Panzer Division order of battle or exact troop strengths.
- Moving units, command orders, combat, pathfinding, or enemy AI.
- Final terrain sculpting, animations, effects, sound, or campaign systems.
- A built APK or verified on-device performance test.

## How to test
1. Open the repository in a Godot 4.3-or-newer editor.
2. Import the project by selecting the folder containing `project.godot`.
3. Run the project (F6/F5 as appropriate; use F6 for the main scene if needed).
4. On a touch device, drag with one finger to pan and pinch with two fingers to zoom.
5. On desktop, drag with the left mouse button to pan and use the mouse wheel to zoom.

## Validation status
The files have been committed to GitHub, but this environment has not run the Godot editor or Android export. Treat the prototype as an initial code milestone pending an actual Godot import/run test and APK test on the owner's phone. Fix any engine/parser errors found during that test before expanding the game.
