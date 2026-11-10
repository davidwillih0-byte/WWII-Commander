# German tank models

Place the imported source files in this folder once they have been added to the repository:

- `Pz-III-J.fbx`
- `colorAtlas.png`

Keep the FBX and its matching atlas together. Do not rename or replace the source files until the Godot import is checked.

## Godot import checklist
1. Open the project with Godot 4.7.2 and allow the FBX importer to finish.
2. Inspect the imported scene hierarchy and materials.
3. Confirm the model faces the intended forward direction and has a sensible scale.
4. Confirm the atlas is assigned and the model is not black, white, or untextured.
5. Check whether turret, gun, and track meshes are separate before attempting animation.
6. Create a test scene using the imported model alongside the existing procedural tank.
7. Build an Android debug APK and compare the result on the target phone before replacing the current tank.

The uploaded chat attachment cannot be committed through the available GitHub text-file action. This folder is a documented destination, not evidence that the model has already been imported.
