extends Node2D

func get_viewport_midpoint() -> Vector2:
	return get_viewport_rect().size / 2

func _process(delta: float) -> void:
	queue_redraw()

func generate_circle_sectors(position: Vector2, radius: float, sector_count: int, rotation_offset: float) -> Array[PackedVector2Array]:
	var sector_polygons : Array[PackedVector2Array] = []
	var sector_radians : float = (2.0 * PI) / sector_count
	
	for i in sector_count:
		sector_polygons.append(PackedVector2Array([
			position,
			position + Vector2.UP.rotated(sector_radians * i + rotation_offset) * radius,
			position + Vector2.UP.rotated(sector_radians * (i+1) + rotation_offset) * radius
		]))
	
	return sector_polygons

func draw_wheel(sector_count: int, radius: float, rotation_offset: float, colors: PackedColorArray) -> void:
	var sector_polygons : Array[PackedVector2Array] = generate_circle_sectors(get_viewport_midpoint(), radius, sector_count, rotation_offset)
	for i in range(sector_count):
		draw_polygon(sector_polygons[i], PackedColorArray([colors[wrap(i, 0, len(colors))]]))

var wheel_rotation : float = 0.0

func _draw() -> void:
	wheel_rotation += PI/360.0
	var colors_rainbow : PackedColorArray = PackedColorArray([Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.BLUE, Color.INDIGO, Color.VIOLET])
	draw_wheel(3, 200.0, wheel_rotation, colors_rainbow)
