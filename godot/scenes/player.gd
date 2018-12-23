extends KinematicBody2D

# SaucerSection ist separated to let some funky jiggle happen.
# Player.mode is set to 'character' to disable rotation by contacts/collisions.
# Instead, a regular rotation is introduced by script (allowed when in character Mode)
# A revolute joint allows "physic engine rotation" between main player node and SaucerSection
# A linear spring allows for some dynamics to happen in the joint. This looks funny
	# and allows to squeeze through the obstacles
	# ultimatively, you can actually flip the saucer in certain situations. that's a feature!

# INIT #####################
onready var worldNode = get_tree().get_root().get_node("/root/World")
onready var animator = $AnimationPlayer
var steering = Vector2(0,0)
var keyboardVal = 0
var gamepadVal = 0
var collisionsDetected = 0
var gameOverCount = 0
var collisionRelease = 0
var gameOverFlag = false
signal gameOverSignal
# PARAMS ###################
# exporting some parameters so they can be changed in the editor
export var collisionGameOver = 45		# 0.75 second of collisions until game is over
export var thereminMode = true			# special controller settings for theremin
export var thereminSmoothing = 10.0/60	# smoothing of character movements in theremin mode
export var playerDamp = 0.5				# damping (if ridigbody version of player)
export var angularChangeRate = 0.05		# speed at which player can rotate, used for keyboard controls
export var angularMaximum = 30			# max. steering angle of player (superimposed by dynamics)
export var playerAgility = 2;			# multiplier of left/right acceleration
export var playerVelocity = 300			# vertical acceleration 'speed' ( game difficulty)


func _ready():
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
#	Input.add_joy_mapping("03000000412300003680000000000000,Arduino Leonardo,platform:Windows,leftstick:a1,",true)
	Input.add_joy_mapping("03000000412300003680000000000000,Arduino Leonardo,a:b0,b:b1,back:b6,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,dpup:h0.1,guide:b10,leftshoulder:b4,leftstick:b8,lefttrigger:a2,leftx:a0,lefty:a1,rightshoulder:b5,rightstick:b9,righttrigger:a5,rightx:a3,righty:a4,start:b7,x:b2,y:b3,",true)
	pass

#func _process(delta):
#	pass

#func _on_joy_connection_changed(device_id, connected):
#	if connected:
#		print(Input.get_joy_name(device_id))
#	else:
#		print("Keyboard")

func _physics_process(delta):	# process is faster than _physics_process, so I will handle some indepentent stuff here:
	var thrustAngle = get_transform().get_rotation()
	steer(thrustAngle, delta)
	collisionsDetected = get_slide_count()
	if (gameOverFlag == false):
		move_and_slide(steering);
		collisionHandling()
	pass

func collisionHandling():
	if (collisionsDetected > 0):
		gameOverCount += 1
	elif (collisionsDetected == 0 and gameOverCount > 0):
		collisionRelease += 1
		if (collisionRelease > collisionGameOver):
			gameOverCount = 0
			collisionRelease = 0
	if(gameOverCount > collisionGameOver):
		gameOver()
	print(gameOverCount)
	pass

#func _integrate_forces(state):
#	# since in _physics_process, only add_forces() can be applied, it is set manually here
#	set_applied_force(steering)
#	pass

func _input(event):
	if (event is InputEventJoypadMotion):
		if(event.axis == JOY_AXIS_0):
			if(!thereminMode):
				gamepadVal = event.axis_value * angularMaximum
			else:
				gamepadVal = event.axis_value
	if (event is InputEventKey):
		if (event.scancode == KEY_RIGHT):
			keyboardVal = 1
		if (event.scancode == KEY_LEFT):
			keyboardVal = -1
	else:
		keyboardVal = 0
	pass

func steer(thrustAngle, delta):
	var thrustAngleDeg = thrustAngle*360/(2*PI)
	if (thereminMode):
		var screenSizeX = get_viewport().get_visible_rect().size.x
		var currentPos = self.get_transform().origin.x
		# in theremin mode, the position of the player is directly set by the control value
		# since move_and_slide uses a speed [pixel/sec], it must be devided by delta to directly jump within one frame
		steering = Vector2((screenSizeX/2 - currentPos + gamepadVal * screenSizeX / 2 ) / delta * thereminSmoothing, -playerVelocity)
	if (!thereminMode):
		if (keyboardVal < 0):
			# check, if angle already too large:
			if (thrustAngleDeg > -angularMaximum):
				# rotate counter clockwise:
				self.rotate(-angularChangeRate)
		# same for right key:
		if (keyboardVal > 0):
			if (thrustAngleDeg < angularMaximum):
				self.rotate(angularChangeRate);
		if (keyboardVal == 0):
			self.rotate((gamepadVal - thrustAngleDeg)*2*PI/360)
		# the faster the game goes, the more maneuverable it must be! hence multiplying agility with acceleration
		steering = Vector2(sin(thrustAngle) * playerAgility * playerVelocity, -playerVelocity)
		
	pass

func gameOver():
	# the game over screen is handled by the animation:
	$AnimationPlayer.play("gameOver")
	# a state is change to prevent movement after game over:
	gameOverFlag = true
	pass




func _on_AnimationPlayer_animation_finished(gameOver):
	worldNode.gameOver()
	pass # replace with function body
