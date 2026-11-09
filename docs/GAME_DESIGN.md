# Game Design Foundation

## Player experience
WWII Commander is a real-time operational command simulation. The player selects a historical commander or headquarters-staff career path, assumes command of one service branch at a time, issues operational orders, and observes the battle unfold. The intended feel is closer to P.T.O. IV than a direct-control action game.

## First prototype
**Working scenario:** German Panzer division, Eastern Front, 1941.

The exact formation, commander, date, subordinate units, and equipment table must be selected from the owner's historical reference and independently verified before being presented as precise historical facts. The 7th Panzer Division is a possible candidate in the reference, but is not locked by this document.

### Prototype acceptance criteria
- Substantial 3D terrain, not a tiny arena.
- Elevated tactical camera with smooth zoom from operational overview to close observation.
- Roads, fields, forest, elevation, and a small settlement.
- Grounded military visual language; avoid cartoon styling and flat icon-only presentation.
- 3D placeholder units at meaningful distances.
- Android performance controls considered from the start.
- Do not claim functional combat or AI until implemented and tested.

## Command model
The player gives orders to formations rather than steering individual soldiers. Planned order concepts:
- Move to position
- Hold position
- Attack objective
- Defend objective
- Withdraw
- Reconnoitre

## Campaign framework
Planned countries: Germany, United Kingdom, France, Soviet Union, United States, Italy, and Japan. Planned years: 1937–1945, respecting each country's actual entry and mobilisation chronology.

Planned theatres: Western Europe, Eastern Front, North Africa, Mediterranean, Pacific, and Atlantic.

Campaign options:
- Strict Historical
- Alternate History

Historical commanders, unit designations, equipment, and command structures must be date-specific. Temporary attachments and losses should persist where campaign systems support them.

## Branches
- Land: battalions, regiments, divisions, corps, field armies.
- Air: squadrons, groups, wings.
- Naval: fleets, task forces, task groups, submarine and escort flotillas.

The player commands one branch at a time. Cross-branch support can be requested or assigned by campaign systems.

## Planned battlefield systems
Infantry, armour, artillery, anti-tank and anti-aircraft weapons; reconnaissance, air support, naval gunfire, amphibious support; supply, fuel, ammunition, maintenance, morale, suppression, casualties, retreat, encirclement, surrender; weather and time-of-day effects; high-command orders, allied support requests, reassignment, and career progression.

These are design targets, not implemented features.

## Visual direction
Mature, grounded military presentation. Prioritise readable silhouettes, terrain scale, lighting, material quality, and camera composition. Use scalable quality settings and level-of-detail strategies for Android. Owner approved balanced graphics/performance and wide-to-close tactical camera.

## Asset policy
Free resources only unless explicitly approved. Record source URL, creator, licence, attribution, date obtained, and modifications. Do not include assets with unclear redistribution rights. Prefer original placeholder geometry until suitable licensed assets are verified.

## Historical verification
The owner's 94-page Word reference is a starting source, not proof every date-specific number is correct. Verify commanders, order of battle, equipment, and strengths against reliable historical sources. Mark uncertain values as estimates; never silently invent exact counts.

## Device and delivery
Android-first, offline core gameplay. The owner tests APK builds on an Android phone. Do not assume a desktop computer. No paid service or asset costs without explicit approval.
