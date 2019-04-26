extends Node2D

# Referencing scenes
onready var player = $PlayerScene
onready var cameraTripod = $CameraFixture
onready var galaxy = $ParallaxBackground/ParallaxGalaxy
var mobileSwitch = false
var deviceAngle = Vector3()
var previousPlayerAngle = 0
var verticalOffset = 0

func _ready():

	pass
	
#warning-ignore:unused_argument
func _process(delta):
	# Get device angle and rotate nodes:

	
	pass
	
#warning-ignore:unused_argument
func _fixed_process(delta):
	pass

#warning-ignore:unused_argument
func _physics_process(delta):
	var deviceGravityVector = Input.get_gravity()
	if (deviceGravityVector != Vector3(0,0,0)):
		mobileSwitch = true
	var gravityVector = Vector2(deviceGravityVector.x, deviceGravityVector.y).rotated(PI/2)
	deviceAngle = gravityVector.angle()
	
	# Moving Camera to height of player:
	var playerPosition = player.get_transform().origin
	cameraTripod.position = Vector2(1080,playerPosition.y - verticalOffset)
	galaxy.motion_offset = Vector2(-playerPosition.x*0.2, -playerPosition.y*0.2 )
	#cameraTripod.position = Vector2(960,playerPosition.y - verticalOffset)
	$CanvasLayer/TextOut.set_text(String(player.gravitySteering))
	if (mobileSwitch) :
		cameraTripod.rotation = deviceAngle
		var playerAngle = 0.05*deviceAngle + 0.95*previousPlayerAngle
		player.rotation = playerAngle
		player.gravitySteering = sin(playerAngle)
		previousPlayerAngle = playerAngle
	pass
	
func _input(event):
	if (event is InputEventKey):
		if (event.scancode == KEY_ESCAPE):
			get_tree().quit()
	if (event is InputEventKey):
		if (event.scancode == KEY_R):
#warning-ignore:return_value_discarded
			get_tree().reload_current_scene()
	pass
	
func gameOver():
	# Handled by PlayerScene -> AnimationPlayer ends -> calls this function.
	# Currently not using the emitted gameOverSignal
	# finally, reloading everything from the beginning:
#warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	pass