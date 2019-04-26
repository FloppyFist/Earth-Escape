extends Node2D

# This is a wall prototype, will be called by ther wall spawner.
# Every wall will destroy itself automatically if it's outside the view.

# INIT #####################
onready var cameraNode = get_tree().get_root().get_node("/root/World/CameraFixture/Camera2D")
# PARAMS ###################
export var gapSize = 360	# Gap size between walls
var destroyMargin = 100		# Wait this margin outside the camera to destroy the wall

func _ready():
	$RightWall.position = (Vector2(gapSize,0))
	pass

func _process(delta):
	# skip if this scene is started without world and camera not available:
	if cameraNode == null: return
	# since our camera is centered, we have to add half of the screen size:
	var cameraBorder = cameraNode.get_camera_position().y + get_viewport_rect().size.y/2 + destroyMargin
	# check if this wall is out of view, then it can be destroyed:
	if (self.position.y > cameraBorder):
		# Godot function to destroy this node:
		queue_free()
	pass

func setGap(newGapSize):
	# Function to be used if gap shall close during runtime
	$RightWall.position = (Vector2(newGapSize,0))
	pass