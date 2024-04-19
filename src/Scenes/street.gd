extends BaseScene

@export_category("Scene_name")
@export var name_of_scene: String
@export var houses: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	super()

func save_scene():
	var scene = PackedScene.new()
	var result = scene.pack(self)
	if result == OK:
		var error = ResourceSaver.save(scene, Global.path_to_save_scenes + name_of_scene + ".tscn")
		if error != OK:
			push_error("An error occurred while saving the scene to disk.")
