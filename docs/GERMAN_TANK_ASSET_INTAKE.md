# German tank asset intake — November 2026

## Files inspected
The supplied Unity package, Blender archive, and FBX archive contain the same three German tank models:
- Leichttraktor
- Panzer III J
- Panzer VI Tiger

The FBX archive contains binary FBX exports and a matching `colorAtlas.png` beside each model. The Unity package is a valid gzip-compressed Unity asset package and includes FBX assets, metadata, and 128×128 preview renders. The Blender archive contains corresponding `.blend` source files.

## Visual review
The Unity package preview renders show the models as low-poly vehicles with simplified geometry and muted/dark materials. They are usable as an initial prototype asset set, but they do not by themselves meet the intended US Conflict: Tank Battles visual benchmark. In particular, these previews do not establish that the model materials will import into Godot with the intended colours or that moving tracks/turrets are independently rigged.

## Recommended first test
Use the Panzer III J as the first candidate for the Eastern Front 1941 prototype. Keep the Tiger as a later/heavier unit and the Leichttraktor out of the 1941 frontline roster unless a historically appropriate scenario calls for it.

## Import and verification still required
- Import the FBX and its matching atlas into Godot 4.
- Verify scale, orientation, material assignment, texture mapping, and visible colours.
- Inspect mesh hierarchy to see whether hull, turret, gun, and tracks can be animated independently.
- Replace the current procedural tank only after the imported model is visible and stable in an Android APK.
- Measure APK size and frame rate on the user's phone before adding more models.

## Provenance and licence
The supplied files do not include a clearly identified licence document in the inspected archive contents. Do not redistribute the models in a public build until the original creator and licence/usage terms are confirmed. Keep the source archives intact.

## Status
Asset intake reviewed; **not yet integrated into the Godot project**. The current GitHub text-file workflow cannot transfer the user's binary FBX/BLEND files from the chat upload into the repository. No model import or Android visual test is claimed here.
