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

func _draw() -> void:
	
	draw_circle(get_screen_midpoint(), 220., Color.BLUE, true)
	draw_polygon(generate_circle_points(get_screen_midpoint(), 200., 10), PackedColorArray([Color.RED]))
