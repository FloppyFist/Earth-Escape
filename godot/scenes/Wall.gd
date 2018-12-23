extends Node2D

export var gapSize = 360	#	Gap size between walls


func _ready():
	$rightWall.position = (Vector2(gapSize,0))
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func setGap(newGapSize):
	$rightWall.position = (Vector2(newGapSize,0))
	pass