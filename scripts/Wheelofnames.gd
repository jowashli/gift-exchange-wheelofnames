extends Node2D

func get_screen_midpoint() -> Vector2:
	return get_viewport_rect().size / 2

func _ready() -> void:
	print(generate_circle_points(get_screen_midpoint(), 200., true))

func _process(delta: float) -> void:
	queue_redraw()

func generate_circle_points(position: Vector2, radius: float, slices: int) -> PackedVector2Array:
	var points : PackedVector2Array = PackedVector2Array([])
	var slice_degree : float = 360. / slices
	var degree : float = 0
	for i in slices:
		var p : Vector2 = position + Vector2.UP.rotated(deg_to_rad(degree)) * radius
		points.append(p)
		degree += slice_degree
	return points

func generate_circle_slices(position: Vector2, radius: float, slice_count: int) -> Array[PackedVector2Array]:
	var slices : Array[PackedVector2Array] = []
	var slice_degree : float = 360. / slice_count
	
	for i in slice_count:
		var slice : PackedVector2Array = PackedVector2Array([
			position,
			position + Vector2.UP.rotated(deg_to_rad(slice_degree * i)) * radius,
			position + Vector2.UP.rotated(deg_to_rad(slice_degree * (i + 1))) * radius
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
