# Grid Inventory Coordinate Fix

## Problem

When the `SubViewportContainer` node is moved away from the scene root's origin, grid snapping breaks — the preview is offset and items snap to incorrect positions.

## Root Cause

Two layers of issues:

1. **Grid-relative snapping**: Snapping and bounds calculations were done relative to world origin (0,0) instead of relative to the inventory grid's position.
2. **Coordinate space mismatch**: `InventoryItem` and `Inventory` live inside a `SubViewport`, which has its own coordinate system. `Item` nodes live in the main scene. When the `SubViewportContainer` is at (0,0), these spaces align by coincidence, but diverge at any other position.

## Fixes

### InventoryItem.gd — Coordinate Space Conversion

Added `scene_to_viewport()` and `viewport_to_scene()` helpers to convert between main scene coordinates (where Items live) and SubViewport coordinates (where the grid/preview live). The offset is the `SubViewportContainer`'s global position, captured on `_ready`:

```gdscript
var container_position: Vector2

func _ready() -> void:
    container_position = get_viewport().get_parent().global_position

func scene_to_viewport(pos: Vector2) -> Vector2:
    return pos - container_position

func viewport_to_scene(pos: Vector2) -> Vector2:
    return pos + container_position
```

### InventoryItem.gd — Snapping

`snapped(pos.x, 128)` snaps to the nearest multiple of 128 from world origin. Fixed by first converting the item position from scene space to viewport space, then snapping relative to the grid origin:

```gdscript
var grid_origin = %Inventory.global_position
var pos = scene_to_viewport(parent_item.get_grid_origin())
var local_pos = pos - grid_origin
var snapped_local = Vector2(snapped(local_pos.x, snap), snapped(local_pos.y, snap))
global_position = grid_origin + snapped_local + (parent_item.get_item_sprite_size() / 2)
```

### InventoryItem.gd — Item Drop Placement

When placing the item on drop, `global_position` is in viewport space but the item lives in scene space. Convert back with `viewport_to_scene()`:

```gdscript
parent_item.global_position = viewport_to_scene(global_position)
```

### InventoryItem.gd — Bounds Check

`get_origin_offset()` returns scene-space coordinates, so convert to viewport space before passing to `Inventory.in_bounds()`:

```gdscript
var item_origin = scene_to_viewport(parent_item.get_origin_offset())
```

### Inventory.gd — Bounds Check

`max_bounds = grid_size * cell_size` produced bounds relative to (0,0). Since `position` and `max_pos` are in global coordinates, `max_bounds` must be too:

```gdscript
var max_bounds = origin + grid_size * cell_size
```

### Inventory.gd — global_to_grid

Was dividing global position directly by cell size without subtracting the grid's origin:

```gdscript
func global_to_grid(position: Vector2) -> Vector2i:
    return Vector2i((position - global_position) / cell_size)
```
