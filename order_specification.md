# Ordering Specification

## World
- Solids: z=0
- Decorative layer on
-- behind: z=0
-- on above: z=2

## Character
- Characters
-- Sprites: z=1
-- Body: Physics;(Layer = 2 & Mask = 1)

- Weapons and consumables:
-- Body: Physics;(Layer = 2 & Mask = 1,2)
-- behind of characters: z=0
-- ahead of characters: z=1 (No necessarily 2)

- Bullets/Ammos Sprites: z=3 & Physics;(Layer = 2 & Mask = 1)
