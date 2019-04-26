extends Node2D

# INIT #####################
const wallPrototype = preload("res://scenes/Wall.tscn")
var currentIterationPosition = Vector2(0,0)
# PARAMS ###################
var spawnIterations = 3								# number of walls spawned simultaneously
export var spawnMarginY = 300						# offset by which walls will spawn outside viewport
export var spawnRange = Vector2(500, 600)
#export var spawnRange = Vector2(100, 1920-100-360)	# range in X axis for gap to randomly appear
export var wallDistance = 800						# distance between the walls

func _ready():
	# settings first wall to be outside viewport
#	self.position = Vector2(0, -spawnMarginY)
	initializeSpawn()
	for i in range(spawnIterations):
		revolverSpawn()
	pass

func initializeSpawn():
	# this func only runs once at start
	randomize()
	var randomPosition = rand_range(spawnRange.x, spawnRange.y)
	currentIterationPosition = (Vector2(randomPosition, -spawnMarginY))
	pass

func revolverSpawn():
	# revolverSpawn iterates over the global var currentIterationPosition
	# the walls destroy themselves, a signal connects the destruction with this moethod
	#	and hence, revolverSpawn is automatically called again when a wall gets removed
	spawn()
	iterateSpawn()
	pass

func iterateSpawn():
	randomize()
	var randomPosition = rand_range(spawnRange.x, spawnRange.y)
	currentIterationPosition.y -= wallDistance
	currentIterationPosition.x = randomPosition
	pass
	
func spawn():
	# this func spawns a wall at a certain position
	var newWall = wallPrototype.instance()
	newWall.position = currentIterationPosition
	# connect signal to call revolverSpawn again when the wall destroys itself:
	newWall.connect("tree_exited", self, "revolverSpawn")
	$Walls.add_child(newWall)
	pass