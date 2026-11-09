extends Node3D
## First WWII Commander 3D battlefield blockout.
## Procedural placeholder geometry only; not final historical art.

const WORLD_SIZE := 240.0
const CAMERA_MIN := 24.0
const CAMERA_MAX := 150.0

var camera: Camera3D
var camera_pivot: Node3D
var camera_distance := 92.0
var dragging := false
var last_pointer := Vector2.ZERO
var touch_points: Dictionary = {}

var mat_ground: StandardMaterial3D
var mat_field: StandardMaterial3D
var mat_road: StandardMaterial3D
var mat_tree: StandardMaterial3D
var mat_trunk: StandardMaterial3D
var mat_building: StandardMaterial3D
var mat_german: StandardMaterial3D
var mat_track: StandardMaterial3D
var mat_dark: StandardMaterial3D

func _ready() -> void:
	_create_materials()
	_create_world()
	_create_camera()
	_create_hud()
	_create_battlefield_features()
	_create_armour(Vector3(-28, 0, 18), "Panzergruppe A")
	_create_armour(Vector3(-44, 0, 31), "Panzergruppe B")
	_create_infantry_group(Vector3(-10, 0, 42))
	_create_infantry_group(Vector3(22, 0, -32))
	print("WWII Commander: battlefield blockout loaded.")

func _create_materials() -> void:
	mat_ground = _mat(Color(0.31, 0.34, 0.25))
	mat_field = _mat(Color(0.39, 0.40, 0.27))
	mat_road = _mat(Color(0.22, 0.22, 0.19))
	mat_tree = _mat(Color(0.12, 0.20, 0.12))
	mat_trunk = _mat(Color(0.25, 0.18, 0.12))
	mat_building = _mat(Color(0.42, 0.39, 0.32))
	mat_german = _mat(Color(0.25, 0.30, 0.22))
	mat_track = _mat(Color(0.12, 0.13, 0.12))
	mat_dark = _mat(Color(0.08, 0.09, 0.08))

func _mat(color: Color) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = 1.0
	return m

func _create_world() -> void:
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-52, -28, 0)
	sun.light_energy = 1.15
	sun.shadow_enabled = true
	add_child(sun)

	var env := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	var sky_mat := ProceduralSkyMaterial.new()
	sky_mat.sky_top_color = Color(0.22, 0.31, 0.39)
	sky_mat.sky_horizon_color = Color(0.62, 0.65, 0.59)
	sky.sky_material = sky_mat
	environment.sky = sky
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.62, 0.65, 0.59)
	environment.ambient_light_energy = 0.65
	env.environment = environment
	add_child(env)

	_add_box(Vector3(0, -1.2, 0), Vector3(WORLD_SIZE, 2.0, WORLD_SIZE), mat_ground)

func _create_camera() -> void:
	camera_pivot = Node3D.new()
	camera_pivot.position = Vector3.ZERO
	add_child(camera_pivot)
	camera = Camera3D.new()
	camera.position = Vector3(0, camera_distance * 0.72, camera_distance * 0.72)
	camera.look_at(Vector3.ZERO, Vector3.UP)
	camera.fov = 48.0
	camera.current = true
	camera_pivot.add_child(camera)
	_update_camera()

func _update_camera() -> void:
	camera.position = Vector3(0, camera_distance * 0.72, camera_distance * 0.72)
	camera.look_at(Vector3.ZERO, Vector3.UP)

func _create_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var title := Label.new()
	title.text = "WWII COMMANDER  //  EASTERN FRONT  //  1941"
	title.position = Vector2(22, 18)
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(0.91, 0.89, 0.78))
	layer.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "FIELD EXERCISE 01  |  PANZER DIVISION  |  BATTLEFIELD PROTOTYPE"
	subtitle.position = Vector2(24, 51)
	subtitle.add_theme_font_size_override("font_size", 13)
	subtitle.add_theme_color_override("font_color", Color(0.76, 0.78, 0.68))
	layer.add_child(subtitle)

	var help := Label.new()
	help.text = "DRAG: PAN CAMERA     •     SCROLL / PINCH: ZOOM     •     Prototype terrain and unit placeholders"
	help.position = Vector2(22, 680)
	help.add_theme_font_size_override("font_size", 14)
	help.add_theme_color_override("font_color", Color(0.92, 0.90, 0.82))
	layer.add_child(help)

func _create_battlefield_features() -> void:
	# Broad agricultural clearings and a long road crossing the operational area.
	_add_box(Vector3(-48, -0.08, -24), Vector3(72, 0.12, 52), mat_field)
	_add_box(Vector3(52, -0.07, 42), Vector3(68, 0.13, 58), mat_field)
	_add_box(Vector3(0, -0.02, 0), Vector3(9, 0.08, WORLD_SIZE), mat_road)
	_add_box(Vector3(0, 0.01, -18), Vector3(120, 0.08, 7), mat_road)
	_add_box(Vector3(42, 0.05, -52), Vector3(7, 0.08, 64), mat_road)

	# Low ridges represented by broad earth-coloured mounds.
	_add_mound(Vector3(62, 0, -64), Vector3(32, 5, 22))
	_add_mound(Vector3(-72, 0, 68), Vector3(38, 4, 25))

	# Tree belts and scattered woodland.
	for i in range(18):
		_create_tree(Vector3(-88 + float(i) * 8.5, 0, -76 + sin(float(i) * 0.7) * 7.0), 1.0)
	for i in range(14):
		_create_tree(Vector3(72 + sin(float(i) * 0.8) * 13.0, 0, -4 + float(i) * 6.0), 0.9)
	for i in range(12):
		_create_tree(Vector3(-78 + float(i) * 10.0, 0, 78 + cos(float(i)) * 6.0), 1.1)

	# Small rural settlement.
	for p in [Vector3(38, 0, -34), Vector3(49, 0, -30), Vector3(57, 0, -43), Vector3(34, 0, -48)]:
		_create_house(p)

func _create_tree(pos: Vector3, scale_factor: float) -> void:
	var trunk := MeshInstance3D.new()
	var trunk_mesh := CylinderMesh.new()
	trunk_mesh.top_radius = 0.35 * scale_factor
	trunk_mesh.bottom_radius = 0.55 * scale_factor
	trunk_mesh.height = 4.0 * scale_factor
	trunk.mesh = trunk_mesh
	trunk.position = pos + Vector3(0, 2.0 * scale_factor, 0)
	trunk.material_override = mat_trunk
	add_child(trunk)

	var crown := MeshInstance3D.new()
	var crown_mesh := SphereMesh.new()
	crown_mesh.radius = 2.2 * scale_factor
	crown_mesh.height = 5.0 * scale_factor
	crown.mesh = crown_mesh
	crown.position = pos + Vector3(0, 5.0 * scale_factor, 0)
	crown.material_override = mat_tree
	add_child(crown)

func _create_house(pos: Vector3) -> void:
	_add_box(pos + Vector3(0, 2.0, 0), Vector3(8, 4, 7), mat_building)
	var roof_mat := _mat(Color(0.24, 0.20, 0.17))
	_add_box(pos + Vector3(0, 4.4, 0), Vector3(9, 1.0, 8), roof_mat)

func _add_mound(pos: Vector3, size: Vector3) -> void:
	var mound := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radius = 1.0
	mesh.height = 1.0
	mound.mesh = mesh
	mound.scale = size
	mound.position = pos
	mound.material_override = _mat(Color(0.34, 0.34, 0.27))
	add_child(mound)

func _create_armour(pos: Vector3, unit_name: String) -> void:
	var group := Node3D.new()
	group.position = pos
	add_child(group)
	# Simplified tank silhouette: hull, turret, gun barrel and track blocks.
	_add_box_local(group, Vector3(0, 1.2, 0), Vector3(7.0, 1.8, 4.0), mat_german)
	_add_box_local(group, Vector3(0, 2.35, 0), Vector3(3.4, 1.0, 2.8), mat_german)
	_add_box_local(group, Vector3(0, 2.3, -2.4), Vector3(0.55, 0.45, 3.4), mat_dark)
	_add_box_local(group, Vector3(0, 0.65, 0), Vector3(7.6, 0.8, 4.4), mat_track)
	_add_box_local(group, Vector3(0, 0.65, 2.3), Vector3(7.6, 0.8, 0.35), mat_dark)
	_add_box_local(group, Vector3(0, 0.65, -2.3), Vector3(7.6, 0.8, 0.35), mat_dark)
	_add_unit_label(group, unit_name)

func _create_infantry_group(pos: Vector3) -> void:
	var group := Node3D.new()
	group.position = pos
	add_child(group)
	for i in range(7):
		var soldier := MeshInstance3D.new()
		var mesh := CapsuleMesh.new()
		mesh.radius = 0.42
		mesh.height = 1.8
		soldier.mesh = mesh
		soldier.position = Vector3(float(i % 4) * 2.2 - 3.0, 0.9, float(i / 4) * 2.5)
		soldier.material_override = mat_german
		group.add_child(soldier)

func _add_unit_label(parent: Node3D, text_value: String) -> void:
	var label := Label3D.new()
	label.text = text_value
	label.position = Vector3(0, 5.0, 0)
	label.font_size = 32
	label.outline_size = 6
	label.modulate = Color(0.95, 0.91, 0.75)
	parent.add_child(label)

func _add_box(pos: Vector3, size: Vector3, material: Material) -> void:
	var instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	instance.mesh = mesh
	instance.position = pos
	instance.material_override = material
	add_child(instance)

func _add_box_local(parent: Node3D, pos: Vector3, size: Vector3, material: Material) -> void:
	var instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	instance.mesh = mesh
	instance.position = pos
	instance.material_override = material
	parent.add_child(instance)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			camera_distance = max(CAMERA_MIN, camera_distance - 8.0)
			_update_camera()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			camera_distance = min(CAMERA_MAX, camera_distance + 8.0)
			_update_camera()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			last_pointer = event.position
	elif event is InputEventMouseMotion and dragging:
		_pan_camera(event.position - last_pointer)
		last_pointer = event.position
	elif event is InputEventScreenTouch:
		if event.pressed:
			touch_points[event.index] = event.position
		else:
			touch_points.erase(event.index)
	elif event is InputEventScreenDrag:
		if touch_points.has(event.index):
			var previous: Vector2 = touch_points[event.index]
			var other_index := -1
			for key in touch_points.keys():
				if key != event.index:
					other_index = int(key)
					break
			if other_index >= 0:
				var other_position: Vector2 = touch_points[other_index]
				var old_distance := previous.distance_to(other_position)
				var new_distance := event.position.distance_to(other_position)
				camera_distance = clamp(camera_distance - (new_distance - old_distance) * 0.12, CAMERA_MIN, CAMERA_MAX)
				_update_camera()
			else:
				_pan_camera(event.position - previous)
			touch_points[event.index] = event.position

func _pan_camera(delta: Vector2) -> void:
	var pan_scale := camera_distance * 0.004
	camera_pivot.position.x -= delta.x * pan_scale
	camera_pivot.position.z -= delta.y * pan_scale
	camera_pivot.position.x = clamp(camera_pivot.position.x, -90.0, 90.0)
	camera_pivot.position.z = clamp(camera_pivot.position.z, -90.0, 90.0)
