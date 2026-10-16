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
	create_wheel_labels()

func _process(_delta: float) -> void:
	queue_redraw()

func create_wheel_labels ( radius: float=wheel_radius, sector_count: int=wheel_sector_count, position_offset: Vector2=Vector2.ZERO, rotation_offset: float=0.0, names: PackedStringArray=wheel_names ) -> void:
	var wheel_labels : Array[Label] = []
	var sector_radians : float = (2.0 * PI) / sector_count
	for i in range(sector_count):
		var new_label : Label = Label.new()
		new_label.text = names[i]
		new_label.rotation = sector_radians * (i+0.5) + PI * 1.5
		new_label.position = position_offset + Vector2.UP.rotated(sector_radians * (i+0.5) + rotation_offset) * radius # sector edge 
		new_label.position += Vector2.UP.rotated(new_label.rotation) * new_label.size.y/2. # height offset
		new_label.position += Vector2.LEFT.rotated(new_label.rotation) * (new_label.size.x + WHEEL_PADDING) # width_offset
		wheel_labels.append(new_label)
	
	for wheel_label in wheel_labels:
		add_child(wheel_label)

func _draw() -> void:
	rotation += PI/360.0
	draw_wheel()

func generate_wheel_sector_polygons(radius: float=wheel_radius, sector_count: int=wheel_sector_count, position_offset: Vector2=Vector2.ZERO, rotation_offset: float=0.0) -> Array[PackedVector2Array]:
	var sector_polygons : Array[PackedVector2Array] = []
	var sector_radians : float = (2.0 * PI) / sector_count
	var sector_arc_resolution : int = clamp(ceil(90.0 / sector_count), 2, 180)
	for i in sector_count:
		var sector : PackedVector2Array = PackedVector2Array([position_offset])
		for j in range(sector_arc_resolution):
			sector.append(position_offset + Vector2.UP.rotated(sector_radians * lerp(i, i+1, j/(sector_arc_resolution-1.0)) + rotation_offset) * radius)
		sector_polygons.append(sector)
	return sector_polygons

func draw_wheel(radius: float=wheel_radius, sector_count: int=wheel_sector_count, position_offset: Vector2=Vector2.ZERO, rotation_offset: float=0.0, colors: PackedColorArray=wheel_colors) -> void:
	var sector_polygons : Array[PackedVector2Array] = generate_wheel_sector_polygons()
	for i in range(sector_count):
		draw_polygon(sector_polygons[i], PackedColorArray([colors[wrap(i, 0, len(colors))]]))
	draw_circle(Vector2.ZERO, CENTER_CIRCLE_RADIUS, CENTER_CIRCLE_COLOR)
