extends Node3D

var dynamic_vertices = [
	Vector4(-1, -1, -1, -1), Vector4(-1, -1, -1,  1), Vector4(-1, -1,  1, -1), Vector4(-1, -1,  1,  1),
	Vector4(-1,  1, -1, -1), Vector4(-1,  1, -1,  1), Vector4(-1,  1,  1, -1), Vector4(-1,  1,  1,  1),
	Vector4( 1, -1, -1, -1), Vector4( 1, -1, -1,  1), Vector4( 1, -1,  1, -1), Vector4( 1, -1,  1,  1),
	Vector4( 1,  1, -1, -1), Vector4( 1,  1, -1,  1), Vector4( 1,  1,  1, -1), Vector4( 1,  1,  1,  1)
]


const CUBE_FACES = [
	[0, 1, 3, 2], [4, 5, 7, 6], [0, 1, 5, 4], 
	[2, 3, 7, 6], [0, 2, 6, 4], [1, 3, 7, 5]
]

const CUBES = [
		[0, 1, 2, 3, 4, 5, 6, 7],
		[8, 9, 10, 11, 12, 13, 14, 15],
		[0, 1, 4, 5, 8, 9, 12, 13],
		[2, 3, 6, 7, 10, 11, 14, 15],
		[0, 2, 4, 6, 8, 10, 12, 14],
		[1, 3, 5, 7, 9, 11, 13, 15],
		[0, 1, 2, 3, 8, 9, 10, 11],
		[4, 5, 6, 7, 12, 13, 14, 15]
	]

	
# Sert à choisir un mode de projection
enum ProjectionMode {
	PERSPECTIVE,
	STEREOGRAPHIC,
	ORTHOGONAL
}

# Sert à choisir un mode d'affichage
enum MeshMode {
	WIREFRAME,
	FULL,
	STYLISH
}

@export var is_rotate = false  # Activer la rotation
@export var is_double_rotate = false  # Activer la rotation double
@export var rotation_angle = 90  # Angle de rotation
@export var axe_a = 0 # x, y, z, w = 0, 1, 2, 3
@export var axe_b = 3 # x, y, z, w = 0, 1, 2, 3
@export var rotation_angle2 = 90
@export var axe2_a = 1
@export var axe2_b = 3
@export var mesh_mode: int = 0  # 0: Plein, 1: stylisé, 2: Filaire
@export var projection_mode: int = 0  # 0: Perspective, 1: Stéréographique, 2: Orthogonale
@export var dimension_selected : int = 0 #pour savoir quel est la dimension actuelle 
var is_up_to_date = true
var dimensions = [{
	"x" : 0, #Dimension XYZ
	"y":1,
	"z":2,
	"w":3,
	},
	{
	"x" : 0, #Dimension XYW
	"y":1,
	"z":3,
	"w":2,
	},
	{
	"x" : 0, #Dimensions XZW
	"y":2,
	"z":3,
	"w":1,
	},
	{
	"x" : 0, #Dimensions XWY
	"y":3,
	"z":1,
	"w":2,
	},
	{
	"x" : 0, #Dimensions XWZ
	"y":3,
	"z":2,
	"w":1,
	},
	{
	"x" : 0, #Dimensions XZY
	"y":2,
	"z":1,
	"w":3,
	},
	{
	"x" : 1, #Dimension YZW
	"y":2,
	"z":3,
	"w":0,
	},
	{
	"x" : 1, #Dimension YZX
	"y":2,
	"z":0,
	"w":3,
	},
	{
	"x" : 1, #Dimension YXW
	"y":0,
	"z":3,
	"w":2,
	},
	{
	"x" : 1, #Dimension YXZ
	"y": 0,
	"z":2,
	"w":3,
	},
	{
	"x" : 1,  #Dimension YWX
	"y":3,
	"z":0,
	"w":2,
	},
		{    #Dimension YWZ
	"x" : 1,
	"y":3,
	"z":2,
	"w":0,
	},
			{    #Dimension ZXY
	"x" : 2,
	"y":0,
	"z":1,
	"w":3,
	},
			{    #Dimension ZXW
	"x" : 2,
	"y":0,
	"z":3,
	"w":1,
	},
			{    #Dimension ZYX
	"x" : 2,
	"y":1,
	"z":0,
	"w":3,
	},
			{    #Dimension ZYW
	"x" : 2,
	"y":1,
	"z":3,
	"w":0,
	},
			{    #Dimension ZWX
	"x" : 2,
	"y":3,
	"z":0,
	"w":1,
	},
			{    #Dimension ZWY
	"x" : 2,
	"y":3,
	"z":1,
	"w":0,
	},
	{   	 #Dimension WXY
	"x" : 3,
	"y":0,
	"z":1,
	"w":2,
	},
		{   	 #Dimension WXZ
	"x" : 3,
	"y":0,
	"z":2,
	"w":1,
	},
	{   	 #Dimension WYX
	"x" : 3,
	"y":1,
	"z":0,
	"w":2,
	},
	{   	 #Dimension WYZ
	"x" : 3,
	"y":1,
	"z":2,
	"w":0,
	},
	{   	 #Dimension WZY
	"x" : 3,
	"y":2,
	"z":1,
	"w":0,
	},
	{   	 #Dimension WZX
	"x" : 3,
	"y":2,
	"z":0,
	"w":1,
	},


]
func set_rotate_plan(plan: String, single_rotate: bool):
	match plan:
		"XY":
			if single_rotate:
				axe_a = 0
				axe_b = 1
			else:
				axe2_a = 0
				axe2_b = 1
		"XZ":
			if single_rotate:
				axe_a = 0
				axe_b = 2
			else:
				axe2_a = 0
				axe2_b = 2
		"YZ":
			if single_rotate:
				axe_a = 1
				axe_b = 2
			else:
				axe2_a = 1
				axe2_b = 2
		"XW":
			if single_rotate:
				axe_a = 0
				axe_b = 3
			else:
				axe2_a = 0
				axe2_b = 3
		"YW":
			if single_rotate:
				axe_a = 1
				axe_b = 3
			else:
				axe2_a = 1
				axe2_b = 3
		"ZW":
			if single_rotate:
				axe_a = 2
				axe_b = 3
			else:
				axe2_a = 2
				axe2_b = 3
		

# pour la translation
@export var is_translate = false # Activer la translation
@export var vect_translate = Vector4(0, 0, 0, 0) # Vecteur de translation
var collision_shape = Node


@onready var camera = $"../CharacterView/Camera3D"
@onready var area = $ZoneAffichage # La variable de la zone

# Mesh de l'hypercube
var mesh_instance: MeshInstance3D

func _ready():
	collision_shape = $Area3D/CollisionShape3D
	# On créer un Mesh3D
	mesh_instance = MeshInstance3D.new()
	# On l'ajoute en enfant du noeud HyperCube
	add_child(mesh_instance)
	# On créer un autre Mesh pour la zone
	# Donc si on veut faire que la zone soit optionnel, il faut modifier ici sans oublier les méthodes build_ et une partie de update_hypercube
	var bounds_mesh = area.create_area_mesh()
	# Et on l'ajoute en enfant du noeud HyperCube
	add_child(bounds_mesh)
	update_hypercube()
	

func _process(delta):
	if !is_up_to_date:
		return
	# On incrémente l'angle de rotation pour avoir une figur qui tourne en continu
	if is_rotate:
		rotation_angle += delta
		# La même chose si on a une double rotation
		if is_double_rotate:
			rotation_angle2 += delta
	# On appel en continu la méthode update_hypercube pour que la rotation prenne effet et aussi pour la projection perspective
	update_hypercube()


func update_hypercube():
	# On supprime les enfants du Mesh de l'hypercube à cause de la manière dont je construit l'hypercube STYLISH
	for child in mesh_instance.get_children():
		child.queue_free()
	
	# Dans ce bloque, on applique les transformations sur les sommets
	# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	var new_vertices = []
	if is_translate: # Transformation pour la translation
		print("ARRAY : " + str(dynamic_vertices))
		for vertex in dynamic_vertices:
			var new_vect = translate_4d(vertex, vect_translate)
			new_vertices.append(new_vect)
		print("NEW ARRAY : " + str(new_vertices))
		dynamic_vertices = new_vertices	
		apply_translation(vect_translate)
	elif is_rotate: # Transformation pour la rotation
		for vertex in dynamic_vertices:
			new_vertices.append(rotate_4d(vertex, rotation_angle, axe_a, axe_b, rotation_angle2, axe2_a, axe2_b))
	else : # Transformation pour la projection perspective
		for vertex in dynamic_vertices:
			new_vertices.append(vertex)
	# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	# Cette partie est liée à la zone, si le cube n'est pas dans la zone alors on ne l'affiche pas
	# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if not is_hypercube_visible(new_vertices):
		mesh_instance.visible = false
		return
	else:
		mesh_instance.visible = true
	# /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	
	# Ici on génère le maillage, lorsque je l'ai fait, je n'ai pas trouvé de moyen de faire quelque chose de générique
	# Parce que la méthode qui fait le STYLISH renvoie un Node3D qui contient les sommets et les arêtes alors que les deux autres méthodes renvoient un Mesh
	# Alors c'est séparé en deux partie, la première lorsqu'on génère le maillaige STYLISH et la deuxième pour les deux autres modes d'affichage
	var mesh
	# Ainsi, si on fait du STYLISH, on ajoute le build en enfant du Mesh de l'hypercube d'où le fait que je supprime ses enfants au début de la méthode
	if mesh_mode==2:
		mesh = apply_build(new_vertices)
		mesh_instance.add_child(mesh)
	else: # Sinon, le Mesh de l'hypercube devient le Mesh du build
		mesh = apply_build(new_vertices)
		mesh_instance.mesh = mesh

	if is_translate:
		is_translate = false

# Cette méthode return true si au moins une partie de l'hypercube est dans la zone
# Elle utilise une méthode qui est dans zone_affichage
func is_hypercube_visible(vertices: Array) -> bool:
	for vertex in vertices:
		var projected_point = apply_projection(vertex)
		if area.is_point_in_area(projected_point):
			return true
	return false

# Cette méthode retourne le build choisi ou renvoie par défaut le mode wireframe
func apply_build(vertices):
	match mesh_mode:
		MeshMode.FULL:
			return build_solid_hypercube_mesh(vertices)
		MeshMode.WIREFRAME:
			return build_wireframe_hypercube_mesh(vertices)
		MeshMode.STYLISH:
			return build_stylish_hypercube_mesh(vertices)
		_:
			return build_wireframe_hypercube_mesh(vertices)

# Cette méthode build l'affichage wireframe
func build_wireframe_hypercube_mesh(vertices) -> Mesh:
	var mesh = ArrayMesh.new()
	var surface_tool = SurfaceTool.new() # SurfaceTool permet de générer et de modifier dynamiquement un maillage
	surface_tool.begin(Mesh.PRIMITIVE_LINES) # Ici on initialise la construction avec des lignes

	# On construit les arêtes
	# get_hypercube_edges est une méthodes qui renvoie les arêtes de l'hypercube
	# donc edge est un tableau qui contient chaque segment --> [[sommet1, sommet2], [sommet4, sommet6], []]
	for edge in get_hypercube_edges():
		# On applique la projection aux sommets
		var p1 = apply_projection(vertices[edge[0]])
		var p2 = apply_projection(vertices[edge[1]])
		# Si vous souhaitez que la zone soit optionnel alors il ne faut pas oublier de modifier ces lignes
		# Si l'arête est coupé par la zone alors on obtient de nouveaux points grâces à la méthode clip_edge
		var clipped_points = area.clip_edge(p1, p2)
		# Si il y a bien deux points alors on créer l'arêtes
		if clipped_points.size() == 2:
			surface_tool.add_vertex(clipped_points[0])
			surface_tool.add_vertex(clipped_points[1])

	surface_tool.commit(mesh)
	return mesh

# Cette méthode build l'affichage stylish
func build_stylish_hypercube_mesh(vertices) -> Node3D:
	var parent_node = Node3D.new() # On créer le Node3D qui va contenir tout les éléments qui représentent l'hypercube (arêtes et sommets)

	# Ici on créer une sphère pour chaque sommet
	for vertex in vertices:
		# On applique la projection
		var projected_vertex = apply_projection(vertex)
		# Et on continue seulement si le point est toujours dans la zone /// Donc il faut modifier ça si vous souhaitez que la zone soit optionnel
		if area.is_point_in_area(projected_vertex):
			# Ensuite c'est seulement visuel, on créer la sphère et son matériau
			var point = MeshInstance3D.new()
			point.mesh = SphereMesh.new()
			point.scale = Vector3(0.2, 0.2, 0.2)
			point.transform.origin = apply_projection(vertex)
			var material = StandardMaterial3D.new()
			material.albedo_color = Color.BLUE
			material.roughness = 0.1
			material.metallic = 0.9
			point.mesh.material = material
			# On ajoute le mesh en enfant du Node3D
			parent_node.add_child(point)

	# Ici on créer un cylindre pour chaque arête
	# Pour rappel, get_hypercube_edges est une méthodes qui renvoie les arêtes de l'hypercube
	# donc edge est un tableau qui contient chaque segment --> [[sommet1, sommet2], [sommet4, sommet6], []]
	for edge in get_hypercube_edges():
		# On applique la projection aux sommets
		var p1 = apply_projection(vertices[edge[0]])
		var p2 = apply_projection(vertices[edge[1]])
		# Si vous souhaitez que la zone soit optionnel alors il ne faut pas oublier de modifier ces lignes
		# Si l'arête est coupé par la zone alors on obtient de nouveaux points grâces à la méthode clip_edge
		var clipped_points = area.clip_edge(p1, p2)
		# Si il y a bien deux points alors on créer l'arêtes
		if clipped_points.size() == 2:
			var cylinder = MeshInstance3D.new()
			# On créer le cylindre et on le paramètre correctement
			cylinder.mesh = CylinderMesh.new()
			cylinder.mesh.bottom_radius = 0.05
			cylinder.mesh.top_radius = 0.05
			# La hauteur du cylindre c'est la distance entre les deux sommets
			cylinder.mesh.height = (clipped_points[0] - clipped_points[1]).length()
			
			# On positionne le cylindre au centre de l'arête
			var mid_point = (clipped_points[0] + clipped_points[1]) / 2.0 # On calcule le milieu
			cylinder.transform.origin = mid_point # Et on le positionne
			
			# On oriente le cylindre dans la bonne direction
			var direction = (clipped_points[1] - clipped_points[0]).normalized()
			
			# On calcule l'axe de rotation pour qu'on puisse l'applqiuer au cylindre (j'ai pas trouvé d'autre moyen de faire)
			# Donc on compare le vecteur direction avec le vecteur UP qui est le vecteur de l'axe y
			# Pour schématiser, si direction ressemble à ça ---, on va calculer l'angle entre | et ---, dans ce cas on devrait trouver 90° puis on va appliquer cette angle au cylindre
			var axis = Vector3.UP.cross(direction).normalized()
			if axis.length() == 0:
				# Si les points sont parfaitement alignés avec l'axe Y
				axis = Vector3(1, 0, 0)

			# On calcule l'angle de rotation
			var angle = acos(Vector3.UP.dot(direction))
			
			# On créer la transformation
			var cylinder_transform = Transform3D()
			cylinder_transform.origin = mid_point
			cylinder_transform.basis = Basis(axis, angle) * cylinder_transform.basis

			# On applique la transformation au cylindre
			cylinder.transform = cylinder_transform

			# On créer le matériau
			var material = StandardMaterial3D.new()
			material.albedo_color = Color.WHITE
			material.roughness = 0.1
			material.metallic = 0.9
			cylinder.mesh.material = material
			# On ajoute le cylindre en enfant de Node3D
			parent_node.add_child(cylinder)
	return parent_node

# Cette méthode build l'affichage full
func build_solid_hypercube_mesh(vertices) -> Mesh:
	var mesh = ArrayMesh.new()
	var surface_tool = SurfaceTool.new() # SurfaceTool permet de générer et de modifier dynamiquement un maillage
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES) # Ici on initialise la construction avec des triangles

	# On créer le matériau
	var material = StandardMaterial3D.new()
	material.cull_mode = BaseMaterial3D.CULL_DISABLED # On le désactive pour pas que les faces arrières soient cachées
	material.albedo_color = Color(0.1, 0.2, 0.8, 0.3)
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED # On désactive l'effet de lumière
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA # On active la transparence

	# On applique le matériau
	surface_tool.set_material(material)

	# On construit les faces de l'hypercube
	# Donc on parcourt chaque cube
	for cube in CUBES:
		# Et chaque face du cube
		for face in CUBE_FACES:
			# On applique la projection à chaque sommet de la face
			var projected_vertices = [
				apply_projection(vertices[cube[face[0]]]),
				apply_projection(vertices[cube[face[1]]]),
				apply_projection(vertices[cube[face[2]]]),
				apply_projection(vertices[cube[face[3]]])
			]
			
			# On coupe les faces si elles sortent de la zone //// si vous souhaitez que la zone soit optionnel alors il ne faut pas oublier de modifier ces lignes
			var clipped_face = []
			for i in range(4):
				var start = projected_vertices[i]
				var end = projected_vertices[(i + 1) % 4]
				clipped_face += area.clip_edge(start, end)

			clipped_face = clipped_face.duplicate()
			# On construit la face s'il y a au moins 3 points
			if clipped_face.size() >= 3:
				for i in range(1, clipped_face.size() - 1):
					surface_tool.add_vertex(clipped_face[0])
					surface_tool.add_vertex(clipped_face[i])
					surface_tool.add_vertex(clipped_face[i + 1])

	surface_tool.commit(mesh)
	return mesh

# Cette méthode retoune les arêtes de l'hypercube sous forme de liste --> [[sommet1, sommet4], [], []]
func get_hypercube_edges() -> Array:
	var edges = []
	for i in range(16):
		for j in range(i + 1, 16):
			if (dynamic_vertices[i] - dynamic_vertices[j]).length() == 2:
				edges.append([i, j])
	return edges

# Cette méthode retourne la projection choisie ou par défaut la projection perspective
func apply_projection(point_4d: Vector4) -> Vector3:
	match projection_mode:
		ProjectionMode.PERSPECTIVE:
			return project_perspective(point_4d)
		ProjectionMode.STEREOGRAPHIC:
			return project_stereographically(point_4d)
		ProjectionMode.ORTHOGONAL:
			return project_orthogonally(point_4d)
		_:
			return project_perspective(point_4d)

# Méthode de la projection perspective=
func project_perspective(point_4d: Vector4) -> Vector3:
	#print(ignored_axis)
	# On calcule la distance entre la caméra et la position de l'hypercube
	var d = camera.global_position.distance_to(global_position)
	return Vector3(point_4d[dimensions[dimension_selected].x]* d /(point_4d[dimensions[dimension_selected].w]+d),
	point_4d[dimensions[dimension_selected].y]* d /(point_4d[dimensions[dimension_selected].w]+d),
	point_4d[dimensions[dimension_selected].z]* d /(point_4d[dimensions[dimension_selected].w]+d))


# On crée une fonction pour la projection stéréographique
func project_stereographically(point_4d: Vector4):
	var projection_center : Vector4 = Vector4(0,0,0,0)
	projection_center[dimensions[dimension_selected].w]=2
	var t = 1.0 /(projection_center[dimensions[dimension_selected].w] - point_4d[dimensions[dimension_selected].w])
	return Vector3(t * point_4d[dimensions[dimension_selected].x],t*point_4d[dimensions[dimension_selected].y],t*point_4d[dimensions[dimension_selected].z])

# à rajouter plus tard, possibilité de choisir la coordonnée à exclure
func project_orthogonally(point_4d: Vector4)->Vector3:
	return Vector3(point_4d[dimensions[dimension_selected].x],point_4d[dimensions[dimension_selected].y],point_4d[dimensions[dimension_selected].z])
	#match  ignored_axis :
		#0 : return Vector3(point_4d.y, point_4d.z, point_4d.w)
		#1 : return Vector3(point_4d.x, point_4d.z, point_4d.w)
		#2 : return Vector3(point_4d.x, point_4d.y, point_4d.w)
		#3 : return Vector3(point_4d.x, point_4d.y, point_4d.z)
		#_ : return Vector3(point_4d.x, point_4d.y, point_4d.z)


func translate_4d(vect: Vector4, vect_translation: Vector4) -> Vector4:
	return vect + vect_translation

# on utilise cette méthode pour déplacer le node3d de sorte à ce qu'il soit au même endroit dans l'espace 3D
# que la projection de l'hypercube
func apply_translation(vect: Vector4):
	var vect_3d = Vector3(vect.x, vect.y, vect.z)
	collision_shape.global_transform.origin += vect_3d
	#global_transform.origin += vect_3d 
	#position += vect_3d
	

# Cette méthode applique une rotation ou une double rotation à un point
func rotate_4d(point: Vector4, angle1: float, axis1_a: int, axis1_b: int, angle2: float, axis2_a: int, axis2_b: int) -> Vector4:
	# On calcule cos et sin de la première rotation
	var cos_theta1 = cos(angle1)
	var sin_theta1 = sin(angle1)
	# On créer des variables temporaires
	var rotated_point = point
	var temp_a = point[axis1_a]
	var temp_b = point[axis1_b]
	# On applique la transformation
	rotated_point[axis1_a] = temp_a * cos_theta1 - temp_b * sin_theta1
	rotated_point[axis1_b] = temp_a * sin_theta1 + temp_b * cos_theta1
	
	# On refait la même chose dans le cas d'une double rotation
	if is_double_rotate:
		var cos_theta2 = cos(angle2)
		var sin_theta2 = sin(angle2)
		temp_a = point[axis2_a]
		temp_b = point[axis2_b]
		rotated_point[axis2_a] = temp_a * cos_theta2 - temp_b * sin_theta2
		rotated_point[axis2_b] = temp_a * sin_theta2 + temp_b * cos_theta2
	return rotated_point

#fonction pour changer le point qu'on ne projette pas
func change_dimension(new_dimension : int):
	is_up_to_date = false
	dimension_selected = new_dimension
	is_up_to_date = true
	
