extends Node3D
## Stable first-render test for WWII Commander.
## Uses simple built-in meshes so the Android GL Compatibility renderer
## can display the scene without external assets or shaders.

const WORLD_SIZE := 220.0

func _ready() -> void:
	_build_scene()
	print("WWII COMMANDER: 3D TEST SCENE READY")

func _build_scene() -> void:
	# Background and lighting.
	var world := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.42, 0.48, 0.50)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.78, 0.78, 0.72)
	env.ambient_light_energy = 0.8
	world.environment = env
	add_child(world)

	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-55.0, -25.0, 0.0)
	sun.light_energy = 1.3
	add_child(sun)

	# Camera: deliberately close enough to make the ground fill the view.
	var cam := Camera3D.new()
	add_child(cam)
	cam.position = Vector3(0.0, 92.0, 112.0)
	cam.fov = 55.0
	cam.look_at(Vector3.ZERO, Vector3.UP)
	cam.current = true

	# Large ground slab.
	_box("Ground", Vector3(0, -1.0, 0), Vector3(WORLD_SIZE, 2.0, WORLD_SIZE), Color(0.30, 0.34, 0.23))

	# Visible field plots and roads.
	_box("North Field", Vector3(-48, 0.03, -42), Vector3(72, 0.12, 48), Color(0.39, 0.40, 0.25))
	_box("East Field", Vector3(55, 0.04, 35), Vector3(62, 0.14, 55), Color(0.43, 0.40, 0.26))
	_box("Main Road", Vector3(0, 0.12, 0), Vector3(10, 0.16, WORLD_SIZE), Color(0.19, 0.19, 0.17))
	_box("Cross Road", Vector3(0, 0.14, -22), Vector3(140, 0.16, 8), Color(0.19, 0.19, 0.17))

	# Woodland belts.
	for i in range(13):
		_tree(Vector3(-88.0 + float(i) * 9.0, 0, -72.0))
	for i in range(11):
		_tree(Vector3(72.0, 0, -48.0 + float(i) * 9.0))
	for i in range(12):
		_tree(Vector3(-78.0 + float(i) * 10.0, 0, 76.0))

	# Village.
	for p in [Vector3(35, 0, -36), Vector3(48, 0, -34), Vector3(57, 0, -47), Vector3(34, 0, -52)]:
		_house(p)

	# Clearly visible placeholder armour and infantry.
	_tank(Vector3(-26, 0, 20), Color(0.25, 0.31, 0.22))
	_tank(Vector3(-43, 0, 34), Color(0.25, 0.31, 0.22))
	for i in range(7):
		_soldier(Vector3(-8.0 + float(i % 4) * 2.5, 0, 43.0 + float(i / 4) * 3.0))

	# Screen-space title proves the scene and script are running.
	var hud := CanvasLayer.new()
	add_child(hud)
	var title := Label.new()
	title.text = "WWII COMMANDER  |  EASTERN FRONT  |  1941"
	title.position = Vector2(24, 20)
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", Color(1.0, 0.94, 0.78))
	title.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 1))
	title.add_theme_constant_override("shadow_offset_x", 2)
	title.add_theme_constant_override("shadow_offset_y", 2)
	hud.add_child(title)

	var status := Label.new()
	status.text = "3D RENDER TEST  •  TERRAIN  •  WOODLAND  •  VILLAGE  •  ARMOUR"
	status.position = Vector2(26, 56)
	status.add_theme_font_size_override("font_size", 15)
	status.add_theme_color_override("font_color", Color.WHITE)
	hud.add_child(status)

func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 1.0
	return material

func _box(label: String, pos: Vector3, size: Vector3, color: Color) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = label
	var mesh := BoxMesh.new()
	mesh.size = size
	mesh_instance.mesh = mesh
	mesh_instance.position = pos
	mesh_instance.material_override = _material(color)
	add_child(mesh_instance)

func _tree(pos: Vector3) -> void:
	var trunk := MeshInstance3D.new()
	var trunk_mesh := CylinderMesh.new()
	trunk_mesh.top_radius = 0.35
	trunk_mesh.bottom_radius = 0.55
	trunk_mesh.height = 4.0
	trunk.mesh = trunk_mesh
	trunk.position = pos + Vector3(0, 2.0, 0)
	trunk.material_override = _material(Color(0.25, 0.16, 0.10))
	add_child(trunk)

	var crown := MeshInstance3D.new()
	var crown_mesh := SphereMesh.new()
	crown_mesh.radius = 2.4
	crown_mesh.height = 5.0
	crown.mesh = crown_mesh
	crown.position = pos + Vector3(0, 5.0, 0)
	crown.material_override = _material(Color(0.10, 0.20, 0.11))
	add_child(crown)

func _house(pos: Vector3) -> void:
	_box("Village House", pos + Vector3(0, 2.0, 0), Vector3(8, 4, 7), Color(0.48, 0.43, 0.34))
	_box("House Roof", pos + Vector3(0, 4.5, 0), Vector3(9, 1.0, 8), Color(0.25, 0.18, 0.14))

func _tank(pos: Vector3, color: Color) -> void:
	_box("Tank Hull", pos + Vector3(0, 1.2, 0), Vector3(7.0, 1.8, 4.0), color)
	_box("Tank Turret", pos + Vector3(0, 2.35, 0), Vector3(3.4, 1.0, 2.8), color.darkened(0.12))
	_box("Tank Gun", pos + Vector3(0, 2.3, -2.5), Vector3(0.5, 0.5, 3.8), Color(0.10, 0.11, 0.10))
	_box("Tank Tracks", pos + Vector3(0, 0.55, 0), Vector3(7.8, 0.7, 4.5), Color(0.10, 0.11, 0.10))

func _soldier(pos: Vector3) -> void:
	var body := MeshInstance3D.new()
	var capsule := CapsuleMesh.new()
	capsule.radius = 0.42
	capsule.height = 1.8
	body.mesh = capsule
	body.position = pos + Vector3(0, 0.9, 0)
	body.material_override = _material(Color(0.25, 0.31, 0.22))
	add_child(body)
