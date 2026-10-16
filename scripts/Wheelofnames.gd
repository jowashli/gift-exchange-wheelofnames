extends Node2D

@export var wheel_radius : float = 400.0
@export var wheel_colors : PackedColorArray = PackedColorArray([Color.DIM_GRAY, Color.WEB_GRAY, Color.DARK_GRAY, Color.LIGHT_GRAY])
@export_multiline() var wheel_names_string : String = "item1\nitem2\nitem3"
var wheel_names : PackedStringArray
var wheel_sector_count : int = len(wheel_names)

const CENTER_CIRCLE_RADIUS : float = 50.0
const CENTER_CIRCLE_COLOR : Color = Color.WHITE
const WHEEL_PADDING : int = 20

func _ready() -> void:
	wheel_names = PackedStringArray(wheel_names_string.split("\n"))
	wheel_sector_count = len(wheel_names)
	print(wheel_names)
	position = get_viewport_rect().size / 2
	create_wheel_labels(Vector2.ZERO, wheel_radius, wheel_sector_count, 0.0, wheel_names)

func _process(_delta: float) -> void:
	queue_redraw()

func create_wheel_labels (offset_position: Vector2, radius: float, sector_count: int, rotation_offset: float, names: PackedStringArray) -> void:
	var wheel_labels : Array[Label] = []
	var sector_radians : float = (2.0 * PI) / sector_count
	for i in range(sector_count):
		var new_label : Label = Label.new()
		new_label.text = names[i]
		new_label.rotation = sector_radians * (i+0.5) + PI * 1.5
		new_label.position = offset_position + Vector2.UP.rotated(sector_radians * (i+0.5) + rotation_offset) * radius # sector edge 
		new_label.position += Vector2.UP.rotated(new_label.rotation) * new_label.size.y/2. # height offset
		new_label.position += Vector2.LEFT.rotated(new_label.rotation) * (new_label.size.x + WHEEL_PADDING) # width_offset
		wheel_labels.append(new_label)
	
	for wheel_label in wheel_labels:
		add_child(wheel_label)

func _draw() -> void:
	rotation += PI/360.0
	draw_wheel(wheel_sector_count, wheel_radius, 0.0, wheel_colors)

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
	draw_circle(Vector2.ZERO, CENTER_CIRCLE_RADIUS, CENTER_CIRCLE_COLOR)
