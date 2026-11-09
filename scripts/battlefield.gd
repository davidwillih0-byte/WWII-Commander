extends Node3D
## WWII Commander — Eastern Front visual upgrade.
## Procedural low-poly 3D assets, designed as a lightweight Android prototype.

const WORLD_SIZE := 240.0
const CAMERA_MIN := 30.0
const CAMERA_MAX := 125.0

var camera: Camera3D
var camera_distance := 104.0
var dragging := false
var last_pointer := Vector2.ZERO
var touch_points: Dictionary = {}

func _ready() -> void:
	_build_world()
	_build_camera()
	_build_battlefield()
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
	environment_node.environment = environment
	add_child(environment_node)

	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-48.0, -32.0, 0.0)
	sun.light_energy = 1.25
	sun.shadow_enabled = true
	add_child(sun)

	_box("Base terrain", Vector3(0, -1.2, 0), Vector3(WORLD_SIZE, 2.0, WORLD_SIZE), Color(0.28, 0.31, 0.22))
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
	camera.position = Vector3(0, camera_distance * 0.72, camera_distance * 0.82)
	camera.fov = 52.0
	camera.look_at(Vector3.ZERO, Vector3.UP)
	camera.current = true

func _update_camera() -> void:
	camera.position = Vector3(0, camera_distance * 0.72, camera_distance * 0.82)
	camera.look_at(Vector3.ZERO, Vector3.UP)

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

	# German armoured platoon: detailed procedural Panzer IV-style silhouettes.
	_panzer_iv(Vector3(-25, 0, 18), 0.0)
	_panzer_iv(Vector3(-39, 0, 32), -8.0)
	_panzer_iv(Vector3(-53, 0, 45), 6.0)
	_infantry_squad(Vector3(-7, 0, 44))
	_infantry_squad(Vector3(18, 0, -5))

func _tree(pos: Vector3, size_factor: float) -> void:
	var trunk_height := 4.2 * size_factor
	_cylinder("Tree trunk", pos + Vector3(0, trunk_height * 0.5, 0), 0.38 * size_factor, trunk_height, Color(0.25, 0.17, 0.11))
	_sphere("Lower foliage", pos + Vector3(0, 4.0 * size_factor, 0), Vector3(2.1, 2.8, 2.0) * size_factor, Color(0.12, 0.21, 0.12))
	_sphere("Upper foliage", pos + Vector3(0.2, 5.5 * size_factor, 0.1), Vector3(1.7, 2.3, 1.6) * size_factor, Color(0.16, 0.25, 0.14))

func _house(pos: Vector3, variant: int) -> void:
	var wall_colors := [Color(0.48, 0.43, 0.34), Color(0.43, 0.40, 0.33), Color(0.50, 0.46, 0.37)]
	var roof_colors := [Color(0.25, 0.17, 0.13), Color(0.30, 0.25, 0.19), Color(0.23, 0.22, 0.18)]
	var wall_color: Color = wall_colors[variant]
	var roof_color: Color = roof_colors[variant]
	_box("Village house walls", pos + Vector3(0, 2.0, 0), Vector3(8, 4, 7), wall_color)
	_box("Village roof", pos + Vector3(0, 4.35, 0), Vector3(9.2, 0.8, 8.2), roof_color)
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
	_box("Sloped front plate", Vector3(0, 1.75, -2.75), Vector3(3.8, 1.0, 0.35), dark_green, tank).rotation_degrees.x = -22
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
	subtitle.text = "GERMAN ARMOURED FORMATION  |  TERRAIN & VEHICLE VISUAL UPGRADE"
	subtitle.position = Vector2(24, 52)
	subtitle.add_theme_font_size_override("font_size", 14)
	subtitle.add_theme_color_override("font_color", Color(0.91, 0.91, 0.84))
	layer.add_child(subtitle)
	var controls := Label.new()
	controls.text = "DRAG: PAN CAMERA     •     PINCH: ZOOM"
	controls.position = Vector2(22, 680)
	controls.add_theme_font_size_override("font_size", 14)
	controls.add_theme_color_override("font_color", Color.WHITE)
	layer.add_child(controls)

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
	camera.position.x -= delta.x * pan_scale
	camera.position.z -= delta.y * pan_scale
	camera.position.x = clamp(camera.position.x, -85.0, 85.0)
	camera.position.z = clamp(camera.position.z, -85.0, 85.0)
	camera.look_at(Vector3.ZERO, Vector3.UP)
