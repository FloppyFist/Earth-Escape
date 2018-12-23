extends Node2D

# Referencing scenes
onready var player = $PlayerScene
onready var camera = $CameraNode
var verticalOffset = 0

func _ready():
	verticalOffset = camera.verticalOffset
	pass

func _physics_process(delta):
	var playerPosition = Vector2(player.get_transform().origin)
	camera.position = Vector2(960,playerPosition.y - verticalOffset)
	pass
	
func _input(event):
	if (event is InputEventKey):
		if (event.scancode == KEY_ESCAPE):
			get_tree().quit()
	if (event is InputEventKey):
		if (event.scancode == KEY_R):
			get_tree().reload_current_scene()
	pass
	
func gameOver():
	# 
	# finally, reloading everything from the beginning:
	get_tree().reload_current_scene()
	pass