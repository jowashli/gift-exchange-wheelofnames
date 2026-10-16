extends Node2D

@export var wheel_sector_count : int = 7
@export var wheel_radius : float = 400.0

func _ready() -> void:
	position = get_viewport_rect().size / 2

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	rotation += PI/360.0
	var colors_rainbow : PackedColorArray = PackedColorArray([Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.BLUE, Color.INDIGO, Color.VIOLET])
	draw_wheel(wheel_sector_count, wheel_radius, 0.0, colors_rainbow)

func generate_circle_sectors(offset_position: Vector2, radius: float, sector_count: int, rotation_offset: float) -> Array[PackedVector2Array]:
	var sector_polygons : Array[PackedVector2Array] = []
	var sector_radians : float = (2.0 * PI) / sector_count
	var sector_arc_resolution : int = clamp(ceil(90.0 / sector_count), 2, 180)
	for i in sector_count:
		var sector : PackedVector2Array = PackedVector2Array([offset_position])
		for j in range(sector_arc_resolution):
			sector.append(offset_position + Vector2.UP.rotated(sector_radians * lerp(i, i+1, j/(sector_arc_resolution-1.0)) + rotation_offset) * radius)
		sector_polygons.append(sector)
	return sector_polygons

func draw_wheel(sector_count: int, radius: float, rotation_offset: float, colors: PackedColorArray) -> void:
	var sector_polygons : Array[PackedVector2Array] = generate_circle_sectors(Vector2.ZERO, radius, sector_count, rotation_offset)
	for i in range(sector_count):
		draw_polygon(sector_polygons[i], PackedColorArray([colors[wrap(i, 0, len(colors))]]))
