extends Node2D

var rotation_offset_degrees : float = 0

func get_screen_midpoint() -> Vector2:
	return get_viewport_rect().size / 2

func _process(delta: float) -> void:
	queue_redraw()
	rotation_offset_degrees += 0.2

func generate_circle_slices(position: Vector2, radius: float, slice_count: int) -> Array[PackedVector2Array]:
	var slices : Array[PackedVector2Array] = []
	var slice_degree : float = 360. / slice_count
	
	for i in slice_count:
		var slice : PackedVector2Array = PackedVector2Array([
			position,
			position + Vector2.UP.rotated(deg_to_rad(slice_degree * i + rotation_offset_degrees)) * radius,
			position + Vector2.UP.rotated(deg_to_rad(slice_degree * (i + 1) + rotation_offset_degrees)) * radius
		])
		slices.append(slice)
	
	return slices

func _draw() -> void:
	const slice_count : int = 20
	var colors_base : PackedColorArray = PackedColorArray([Color.RED, Color.BLUE])
	var colors : PackedColorArray = PackedColorArray([])
	for i in range (slice_count / len(colors_base)):
		colors += colors_base
	
	var slices = generate_circle_slices(get_screen_midpoint(), 200., slice_count)
	for i in range(slice_count):
		var slice : PackedVector2Array = slices[i]
		draw_polygon(slice, PackedColorArray([colors[i]]))
