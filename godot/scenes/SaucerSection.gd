extends RigidBody2D

onready var PlayerNode = get_parent()


func _ready():
	# parent available on _ready
	PlayerNode = get_parent()
	pass

#func _process(delta):
#	pass

func _integrate_forces(state):
	state.integrate_forces()
	# first attempt stabilizing relative velocities without wobble. needs physics override
#	state.set_angular_velocity(state.angular_velocity + (angularVelocityOffset/state.get_step()))
	# another attempt could be tracking the parent node's rotation from this node.
	pass
