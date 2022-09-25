extends TileMap

var cell_under_cursor: int
var hovered_tile: Vector2
export var hover_tile_texture: Texture

var hover_sprite: Sprite
var selection_polygon: Polygon2D

var selection_start
var selection_end

var selection_changed = false

func _ready():
	hover_sprite = Sprite.new()
	add_child(hover_sprite)
	hover_sprite.texture = hover_tile_texture
	selection_polygon = Polygon2D.new()
	add_child(selection_polygon)
	selection_polygon.polygon = PoolVector2Array([Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO])
	selection_polygon.color = Color(1, 1, 1, 0.4)
	pass

func _draw_polygon():
	if selection_start == null:
		selection_polygon.polygon = PoolVector2Array()
		return
	selection_polygon.polygon = PoolVector2Array([
		selection_start,
		Vector2(selection_end.x, selection_start.y),
		selection_end,
		Vector2(selection_start.x, selection_end.y)
	])
	pass

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	hover_sprite.position = map_to_world(world_to_map(mouse_pos)) + cell_size * 0.5
	hovered_tile = world_to_map(mouse_pos)
	if selection_start:
		selection_end = get_global_mouse_position()
		_draw_polygon()

func _input(event):
	if event is InputEventMouseMotion and selection_start != null:
		selection_changed = true
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if selection_start == null:
				selection_start = get_global_mouse_position()
				selection_changed = false
		elif event.button_index == BUTTON_LEFT and not event.pressed:
			if selection_changed:
				commit_selection(selection_start, selection_end)
			else:
				EventBus.emit_signal("target_set", get_global_mouse_position())
			selection_start = null
			selection_end = null
			_draw_polygon()

func commit_selection(start, end):
	EventBus.emit_signal("pickable_map_selection_changed", start, end)
	pass
