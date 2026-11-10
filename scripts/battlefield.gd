extends Node3D
## WWII Commander — Eastern Front visual upgrade.
## Procedural low-poly 3D assets, designed as a lightweight Android prototype.

const WORLD_SIZE := 640.0
const CAMERA_MIN := 45.0
const CAMERA_MAX := 360.0

var camera: Camera3D
var camera_distance := 270.0
var camera_yaw_degrees := 0.0
var camera_target := Vector3.ZERO
var dragging := false
var last_pointer := Vector2.ZERO
var touch_points: Dictionary = {}

func _ready() -> void:
	_build_world()
	_build_camera()
	_build_battlefield()
	_build_extended_map()
	_build_hud()
	print("WWII COMMANDER: Eastern Front visual upgrade loaded.")

func _material(color: Color, roughness_value: float = 1.0) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness_value
	return material

func _box(label: String, pos: Vector3, size: Vector3, color: Color, parent: Node3D = null) -> MeshInstance3D:
	var part := MeshInstance3D.new()
	part.name = label
	var mesh := BoxMesh.new()
	mesh.size = size
	part.mesh = mesh
	part.position = pos
	part.material_override = _material(color)
	if parent == null:
		add_child(part)
	else:
		parent.add_child(part)
	return part

func _cylinder(label: String, pos: Vector3, radius: float, height: float, color: Color, parent: Node3D = null, rotation: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var part := MeshInstance3D.new()
	part.name = label
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = 12
	part.mesh = mesh
	part.position = pos
	part.rotation_degrees = rotation
	part.material_override = _material(color)
	if parent == null:
		add_child(part)
	else:
		parent.add_child(part)
	return part

func _sphere(label: String, pos: Vector3, scale_value: Vector3, color: Color, parent: Node3D = null) -> MeshInstance3D:
	var part := MeshInstance3D.new()
	part.name = label
	var mesh := SphereMesh.new()
	mesh.radius = 1.0
	mesh.height = 2.0
	mesh.radial_segments = 10
	mesh.rings = 6
	part.mesh = mesh
	part.position = pos
	part.scale = scale_value
	part.material_override = _material(color)
	if parent == null:
		add_child(part)
	else:
		parent.add_child(part)
	return part

func _build_world() -> void:
	var environment_node := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color(0.49, 0.56, 0.60)
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color(0.78, 0.79, 0.72)
	environment.ambient_light_energy = 0.8
	environment.fog_enabled = true
	environment.fog_light_color = Color(0.62, 0.64, 0.58)
	environment.fog_density = 0.0007
	environment_node.environment = environment
	add_child(environment_node)

	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-48.0, -32.0, 0.0)
	sun.light_energy = 1.25
	sun.shadow_enabled = true
	add_child(sun)

	var ground := _box("Base terrain", Vector3(0, -1.2, 0), Vector3(WORLD_SIZE, 2.0, WORLD_SIZE), Color(0.28, 0.31, 0.22))
	var ground_shader := Shader.new()
	ground_shader.code = "shader_type spatial;\nrender_mode diffuse_burley;\nvarying vec3 world_position;\nvoid vertex() { world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz; }\nfloat hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }\nvoid fragment() { vec2 p = world_position.xz * 0.075; float broad = sin(p.x * 0.7 + sin(p.y * 0.45)) * cos(p.y * 0.6); float grain = hash(floor(world_position.xz * 1.8)) * 0.12; float variation = clamp(0.48 + broad * 0.18 + grain, 0.0, 1.0); vec3 earth = vec3(0.20, 0.22, 0.15); vec3 grass = vec3(0.34, 0.34, 0.22); ALBEDO = mix(earth, grass, variation); ROUGHNESS = 0.98; }"
	var ground_material := ShaderMaterial.new()
	ground_material.shader = ground_shader
	ground.material_override = ground_material
	# Broad, irregular field plots.
	_box("West field", Vector3(-58, -0.02, -38), Vector3(76, 0.16, 64), Color(0.37, 0.37, 0.23))
	_box("South field", Vector3(48, -0.01, 54), Vector3(82, 0.18, 48), Color(0.39, 0.36, 0.22))
	_box("North field", Vector3(44, 0.00, -62), Vector3(74, 0.18, 42), Color(0.33, 0.36, 0.23))

	# Road network with shoulders.
	_box("Main road shoulder", Vector3(0, 0.05, 0), Vector3(13, 0.18, WORLD_SIZE), Color(0.31, 0.29, 0.23))
	_box("Main road surface", Vector3(0, 0.15, 0), Vector3(8, 0.12, WORLD_SIZE), Color(0.20, 0.20, 0.18))
	_box("Cross road shoulder", Vector3(12, 0.05, -24), Vector3(150, 0.18, 12), Color(0.31, 0.29, 0.23))
	_box("Cross road surface", Vector3(12, 0.15, -24), Vector3(150, 0.12, 7), Color(0.20, 0.20, 0.18))
	# Track marks on a muddy side track.
	_box("Farm track left", Vector3(-45, 0.08, 25), Vector3(1.3, 0.10, 70), Color(0.24, 0.22, 0.17))
	_box("Farm track right", Vector3(-41, 0.08, 25), Vector3(1.3, 0.10, 70), Color(0.24, 0.22, 0.17))

	# Low rolling terrain and shallow shell craters.
	_sphere("Low ridge west", Vector3(-83, 0.0, 6), Vector3(34, 4.0, 19), Color(0.32, 0.33, 0.24))
	_sphere("Low ridge east", Vector3(82, 0.0, -76), Vector3(35, 5.0, 22), Color(0.34, 0.34, 0.25))
	for crater_pos in [Vector3(16, 0.0, 28), Vector3(27, 0.0, 34), Vector3(-62, 0.0, -8), Vector3(68, 0.0, 16)]:
		_sphere("Shell crater rim", crater_pos, Vector3(3.0, 0.30, 2.4), Color(0.22, 0.23, 0.18))

func _build_camera() -> void:
	camera = Camera3D.new()
	add_child(camera)
	camera.far = 1200.0
	camera.fov = 52.0
	camera.current = true
	_update_camera()

func _update_camera() -> void:
	var yaw := deg_to_rad(camera_yaw_degrees)
	var horizontal_distance := camera_distance * 0.82
	var offset := Vector3(sin(yaw) * horizontal_distance, camera_distance * 0.72, cos(yaw) * horizontal_distance)
	camera.position = camera_target + offset
	camera.look_at(camera_target, Vector3.UP)

func _build_battlefield() -> void:
	# Mixed woodland belts and scattered trees.
	for i in range(18):
		_tree(Vector3(-100.0 + float(i) * 8.0, 0, -82.0 + sin(float(i) * 0.65) * 5.0), 0.85 + float(i % 4) * 0.12)
	for i in range(15):
		_tree(Vector3(77.0 + sin(float(i) * 0.7) * 12.0, 0, -40.0 + float(i) * 7.0), 0.9 + float(i % 3) * 0.15)
	for i in range(17):
		_tree(Vector3(-90.0 + float(i) * 10.0, 0, 82.0 + cos(float(i) * 0.8) * 7.0), 0.9 + float(i % 4) * 0.1)
	# Shrubs add visual density around the woodland edges.
	for i in range(20):
		_sphere("Field shrub", Vector3(-74.0 + float(i) * 7.0, 0.8, -58.0 + sin(float(i)) * 5.0), Vector3(1.8, 1.2, 1.7), Color(0.18, 0.24, 0.14))

	# Small Eastern European village.
	_house(Vector3(34, 0, -37), 0)
	_house(Vector3(47, 0, -32), 1)
	_house(Vector3(58, 0, -47), 2)
	_house(Vector3(34, 0, -53), 1)
	_box("Village yard wall", Vector3(48, 0.7, -52), Vector3(20, 1.4, 0.7), Color(0.37, 0.34, 0.27))

	# Defensive position: shallow trench, sandbag line and timber bunker.
	_box("Trench earthwork", Vector3(22, 0.20, 12), Vector3(22, 0.45, 2.4), Color(0.25, 0.24, 0.18))
	_box("Trench shadow", Vector3(22, 0.40, 12), Vector3(18, 0.12, 1.1), Color(0.12, 0.13, 0.11))
	for i in range(8):
		_box("Sandbag", Vector3(13.0 + float(i) * 2.5, 0.65, 9.7), Vector3(2.2, 0.65, 0.9), Color(0.49, 0.43, 0.31))
	_box("Timber bunker", Vector3(68, 1.4, 45), Vector3(8, 2.8, 6), Color(0.28, 0.25, 0.18))
	_box("Bunker roof", Vector3(68, 3.0, 45), Vector3(9, 0.55, 7), Color(0.22, 0.21, 0.17))

	# First imported German vehicle test: Panzer III J. Keep a procedural
	# fallback so the battlefield remains playable if an importer rejects the FBX.
	_spawn_panzer_iii(Vector3(-25, 0, 18), 0.0)
	_panzer_iv(Vector3(-39, 0, 32), -8.0)
	_panzer_iv(Vector3(-53, 0, 45), 6.0)
	_infantry_squad(Vector3(-7, 0, 44))
	_infantry_squad(Vector3(18, 0, -5))

func _build_extended_map() -> void:
	# A much wider operational area: separate farming districts, secondary roads,
	# wooded belts, settlements and defensive positions. Keep geometry lightweight.
	for x in [-220.0, -80.0, 80.0, 220.0]:
		for z in [-210.0, -60.0, 100.0, 235.0]:
			var field_color := Color(0.34, 0.35, 0.23) if int(abs(x + z)) % 2 == 0 else Color(0.39, 0.36, 0.24)
			_box("Distant agricultural field", Vector3(x, -0.02, z), Vector3(112, 0.14, 96), field_color)
	# Secondary road network links the villages and gives armour room to manoeuvre.
	for z in [-190.0, 145.0]:
		_box("Secondary road shoulder", Vector3(0, 0.04, z), Vector3(WORLD_SIZE, 0.16, 12), Color(0.31, 0.29, 0.23))
		_box("Secondary road surface", Vector3(0, 0.14, z), Vector3(WORLD_SIZE, 0.12, 7), Color(0.20, 0.20, 0.18))
	for x in [-190.0, 185.0]:
		_box("Cross-country road shoulder", Vector3(x, 0.04, 0), Vector3(12, 0.16, WORLD_SIZE), Color(0.31, 0.29, 0.23))
		_box("Cross-country road surface", Vector3(x, 0.14, 0), Vector3(7, 0.12, WORLD_SIZE), Color(0.20, 0.20, 0.18))
	# Additional woodland belts around the outer approaches and between fields.
	for i in range(34):
		var t := float(i)
		_tree(Vector3(-295.0 + t * 18.0, 0, -270.0 + sin(t * 0.42) * 12.0), 0.9 + float(i % 4) * 0.12)
		_tree(Vector3(-295.0 + t * 18.0, 0, 270.0 + cos(t * 0.38) * 10.0), 0.9 + float(i % 3) * 0.14)
	for i in range(22):
		var t := float(i)
		_tree(Vector3(-275.0 + sin(t * 0.55) * 16.0, 0, -210.0 + t * 19.0), 0.85 + float(i % 4) * 0.13)
		_tree(Vector3(275.0 + cos(t * 0.48) * 15.0, 0, -210.0 + t * 19.0), 0.9 + float(i % 3) * 0.12)
	# Three small settlements create distinct tactical objectives.
	_build_village(Vector3(-205, 0, -125), 5)
	_build_village(Vector3(190, 0, 155), 6)
	_build_village(Vector3(205, 0, -205), 5)
	# Isolated farmsteads and field-edge cover.
	for pos in [Vector3(-245, 0, 35), Vector3(245, 0, 35), Vector3(-45, 0, 245), Vector3(45, 0, -245)]:
		_house(pos, 1)
	# Distant low ridgelines and a few defensive earthworks.
	_sphere("Northern ridge", Vector3(0, 0, -285), Vector3(105, 5.0, 25), Color(0.31, 0.33, 0.24))
	_sphere("Southern ridge", Vector3(0, 0, 285), Vector3(115, 4.0, 24), Color(0.32, 0.33, 0.24))
	for i in range(3):
		var x := -150.0 + float(i) * 145.0
		_box("Distant defensive trench", Vector3(x, 0.22, -150), Vector3(34, 0.4, 2.6), Color(0.25, 0.24, 0.18))
		_box("Distant trench shadow", Vector3(x, 0.40, -150), Vector3(29, 0.1, 1.1), Color(0.12, 0.13, 0.11))

func _build_village(center: Vector3, house_count: int) -> void:
	for i in range(house_count):
		var row := int(i / 3)
		var col := i % 3
		var offset := Vector3(float(col) * 15.0 - 15.0, 0, float(row) * 17.0 - 8.0)
		_house(center + offset, i % 3)
	# A simple open village square and connecting lane.
	_box("Village square", center + Vector3(0, 0.02, 28), Vector3(34, 0.12, 18), Color(0.34, 0.32, 0.25))

func _tree(pos: Vector3, size_factor: float) -> void:
	var trunk_height := 4.2 * size_factor
	_cylinder("Tree trunk", pos + Vector3(0, trunk_height * 0.5, 0), 0.38 * size_factor, trunk_height, Color(0.25, 0.17, 0.11))
	_tree_crown(pos + Vector3(0, 3.6 * size_factor, 0), 2.5 * size_factor, 3.7 * size_factor, Color(0.10, 0.18, 0.10))
	_tree_crown(pos + Vector3(0, 5.5 * size_factor, 0), 1.9 * size_factor, 3.3 * size_factor, Color(0.14, 0.23, 0.12))

func _tree_crown(pos: Vector3, radius: float, height: float, tint: Color) -> void:
	var crown := MeshInstance3D.new()
	crown.name = "Layered conifer crown"
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.12 * (radius / 2.5)
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = 9
	crown.mesh = mesh
	crown.position = pos
	crown.material_override = _material(tint)
	add_child(crown)

func _house(pos: Vector3, variant: int) -> void:
	var wall_colors := [Color(0.48, 0.43, 0.34), Color(0.43, 0.40, 0.33), Color(0.50, 0.46, 0.37)]
	var roof_colors := [Color(0.25, 0.17, 0.13), Color(0.30, 0.25, 0.19), Color(0.23, 0.22, 0.18)]
	var wall_color: Color = wall_colors[variant]
	var roof_color: Color = roof_colors[variant]
	_box("Village house walls", pos + Vector3(0, 2.0, 0), Vector3(8, 4, 7), wall_color)
	var roof_left := _box("Pitched roof left", pos + Vector3(0, 5.0, -1.85), Vector3(9.6, 0.38, 4.7), roof_color)
	roof_left.rotation_degrees.x = -31.0
	var roof_right := _box("Pitched roof right", pos + Vector3(0, 5.0, 1.85), Vector3(9.6, 0.38, 4.7), roof_color)
	roof_right.rotation_degrees.x = 31.0
	_box("Front door", pos + Vector3(0, 1.0, -3.56), Vector3(1.2, 2.0, 0.12), Color(0.19, 0.14, 0.10))
	_box("Window", pos + Vector3(-2.3, 2.3, -3.58), Vector3(1.25, 1.0, 0.12), Color(0.12, 0.17, 0.18))

func _panzer_iv(pos: Vector3, heading: float) -> void:
	var tank := Node3D.new()
	tank.name = "Panzer IV style tank"
	tank.position = pos
	tank.rotation_degrees.y = heading
	add_child(tank)
	var green := Color(0.29, 0.34, 0.25)
	var dark_green := Color(0.20, 0.25, 0.19)
	var metal := Color(0.12, 0.14, 0.13)
	# Tracks and six road wheels on each side.
	_box("Left track belt", Vector3(-2.15, 0.72, 0), Vector3(0.55, 1.15, 7.4), metal, tank)
	_box("Right track belt", Vector3(2.15, 0.72, 0), Vector3(0.55, 1.15, 7.4), metal, tank)
	for side in [-1.0, 1.0]:
		for wheel_index in range(6):
			var wheel_z := -2.65 + float(wheel_index) * 1.05
			_cylinder("Road wheel", Vector3(side * 2.47, 0.72, wheel_z), 0.48, 0.28, Color(0.24, 0.25, 0.21), tank, Vector3(0, 0, 90))
			_cylinder("Wheel hub", Vector3(side * 2.64, 0.72, wheel_z), 0.16, 0.06, Color(0.43, 0.42, 0.34), tank, Vector3(0, 0, 90))
	# Hull, front glacis and rear deck.
	_box("Armoured hull", Vector3(0, 1.45, 0), Vector3(4.0, 1.45, 6.2), green, tank)
	var glacis := _box("Sloped front plate", Vector3(0, 1.75, -2.75), Vector3(3.8, 1.0, 0.35), dark_green, tank)
	glacis.rotation_degrees.x = -22
	_box("Engine deck", Vector3(0, 2.25, 2.05), Vector3(3.5, 0.35, 1.6), dark_green, tank)
	# Turret and long gun barrel.
	_box("Turret", Vector3(0, 2.55, -0.25), Vector3(2.7, 1.15, 2.8), green, tank)
	_cylinder("Turret cupola", Vector3(0.75, 3.22, 0.15), 0.48, 0.34, dark_green, tank)
	_box("Main gun barrel", Vector3(0, 2.65, -2.65), Vector3(0.28, 0.28, 3.5), metal, tank)
	_box("Muzzle brake", Vector3(0, 2.65, -4.35), Vector3(0.48, 0.42, 0.42), metal, tank)
	# Side skirts and small stowage details.
	_box("Left side skirt", Vector3(-2.0, 1.35, 0.1), Vector3(0.22, 0.85, 4.8), dark_green, tank)
	_box("Right side skirt", Vector3(2.0, 1.35, 0.1), Vector3(0.22, 0.85, 4.8), dark_green, tank)
	_box("Rear stowage", Vector3(0, 2.0, 3.15), Vector3(2.2, 0.7, 0.65), Color(0.34, 0.29, 0.20), tank)
	var marker := Label3D.new()
	marker.text = "PANZER"
	marker.position = Vector3(0, 4.1, 0)
	marker.font_size = 22
	marker.outline_size = 4
	marker.modulate = Color(0.96, 0.91, 0.72)
	tank.add_child(marker)

func _spawn_panzer_iii(pos: Vector3, heading: float) -> void:
	var imported_scene := load("res://assets/vehicles/german_tanks/Pz-III-J.fbx") as PackedScene
	if imported_scene == null:
		push_warning("Panzer III J FBX did not import as a PackedScene; using procedural fallback.")
		_panzer_iv(pos, heading)
		return
	var imported_tank := imported_scene.instantiate() as Node3D
	if imported_tank == null:
		push_warning("Panzer III J FBX root is not Node3D; using procedural fallback.")
		_panzer_iv(pos, heading)
		return
	imported_tank.name = "Imported Panzer III J"
	imported_tank.position = pos
	imported_tank.rotation_degrees.y = heading
	# FBX authoring units vary; start conservatively and tune after visual inspection.
	imported_tank.scale = Vector3.ONE
	add_child(imported_tank)
	print("WWII COMMANDER: Imported Panzer III J scene instantiated.")

func _infantry_squad(origin: Vector3) -> void:
	for i in range(8):
		var x := float(i % 4) * 2.0 - 3.0
		var z := float(i / 4) * 2.5
		var soldier := Node3D.new()
		soldier.position = origin + Vector3(x, 0, z)
		add_child(soldier)
		_cylinder("Boots", Vector3(0, 0.12, 0), 0.28, 0.24, Color(0.16, 0.17, 0.14), soldier)
		_sphere("Uniform body", Vector3(0, 0.95, 0), Vector3(0.43, 0.68, 0.30), Color(0.34, 0.37, 0.27), soldier)
		_sphere("Helmet", Vector3(0, 1.72, 0), Vector3(0.38, 0.25, 0.34), Color(0.25, 0.29, 0.22), soldier)
		_box("Rifle", Vector3(0.38, 1.0, -0.10), Vector3(0.12, 0.12, 1.0), Color(0.16, 0.13, 0.09), soldier)

func _build_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	var title := Label.new()
	title.text = "WWII COMMANDER  //  EASTERN FRONT  //  1941"
	title.position = Vector2(22, 18)
	title.add_theme_font_size_override("font_size", 23)
	title.add_theme_color_override("font_color", Color(0.96, 0.92, 0.80))
	layer.add_child(title)
	var subtitle := Label.new()
	subtitle.text = "GERMAN ARMOURED FORMATION  |  EXPANDED DIVISION-SCALE TEST AREA"
	subtitle.position = Vector2(24, 52)
	subtitle.add_theme_font_size_override("font_size", 14)
	subtitle.add_theme_color_override("font_color", Color(0.91, 0.91, 0.84))
	layer.add_child(subtitle)
	var controls := Label.new()
	controls.text = "DRAG: PAN     •     PINCH OR +/-: ZOOM     •     SLIDER: ORBIT CAMERA"
	controls.position = Vector2(22, 680)
	controls.add_theme_font_size_override("font_size", 14)
	controls.add_theme_color_override("font_color", Color.WHITE)
	layer.add_child(controls)

	var orbit_label := Label.new()
	orbit_label.text = "CAMERA ORBIT"
	orbit_label.position = Vector2(22, 720)
	orbit_label.add_theme_font_size_override("font_size", 15)
	orbit_label.add_theme_color_override("font_color", Color.WHITE)
	layer.add_child(orbit_label)

	var orbit_slider := HSlider.new()
	orbit_slider.name = "CameraOrbitSlider"
	orbit_slider.min_value = -180.0
	orbit_slider.max_value = 180.0
	orbit_slider.step = 1.0
	orbit_slider.value = camera_yaw_degrees
	orbit_slider.position = Vector2(150, 716)
	orbit_slider.size = Vector2(420, 36)
	orbit_slider.custom_minimum_size = Vector2(260, 36)
	orbit_slider.value_changed.connect(_on_orbit_slider_changed)
	layer.add_child(orbit_slider)

	var zoom_out := Button.new()
	zoom_out.text = "−"
	zoom_out.position = Vector2(590, 708)
	zoom_out.size = Vector2(58, 48)
	zoom_out.add_theme_font_size_override("font_size", 28)
	zoom_out.pressed.connect(_on_zoom_out_pressed)
	layer.add_child(zoom_out)

	var zoom_in := Button.new()
	zoom_in.text = "+"
	zoom_in.position = Vector2(654, 708)
	zoom_in.size = Vector2(58, 48)
	zoom_in.add_theme_font_size_override("font_size", 28)
	zoom_in.pressed.connect(_on_zoom_in_pressed)
	layer.add_child(zoom_in)

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
				var old_distance: float = previous.distance_to(other_position)
				var new_distance: float = event.position.distance_to(other_position)
				camera_distance = clamp(camera_distance - (new_distance - old_distance) * 0.12, CAMERA_MIN, CAMERA_MAX)
				_update_camera()
			else:
				_pan_camera(event.position - previous)
			touch_points[event.index] = event.position

func _on_orbit_slider_changed(value: float) -> void:
	camera_yaw_degrees = value
	_update_camera()

func _on_zoom_in_pressed() -> void:
	camera_distance = max(CAMERA_MIN, camera_distance - 18.0)
	_update_camera()

func _on_zoom_out_pressed() -> void:
	camera_distance = min(CAMERA_MAX, camera_distance + 18.0)
	_update_camera()

func _pan_camera(delta: Vector2) -> void:
	var pan_scale := camera_distance * 0.004
	var yaw := deg_to_rad(camera_yaw_degrees)
	var right := Vector3(cos(yaw), 0, -sin(yaw))
	var forward := Vector3(-sin(yaw), 0, -cos(yaw))
	camera_target += right * (-delta.x * pan_scale) + forward * (delta.y * pan_scale)
	var map_limit := WORLD_SIZE * 0.43
	camera_target.x = clamp(camera_target.x, -map_limit, map_limit)
	camera_target.z = clamp(camera_target.z, -map_limit, map_limit)
	_update_camera()
