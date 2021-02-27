extends KinematicBody

const SPEED = 10
const UP = Vector3(0,1,0)
const MIN_BLEND_SPEED = 0.125  #  min movem before we start blending animations
const BLEND_TO_RUN = 0.075
const BLEND_TO_IDLE = 0.1

var motion = Vector3()
var movement_state = 0  # idle:0, run:1


func _physics_process(_delta):
	move()
	animate()


func move():
	var x = Input.get_action_strength("forward") - Input.get_action_strength("back")
	var z = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	motion = Vector3(x,0,z)
	
	if not motion == Vector3(0,0,0):
		face_forward(x,z)
	
	move_and_slide(motion * SPEED, UP)


func face_forward(x, z):
	rotation.y = atan2(x,z)


func animate():
	if (motion * SPEED).length() > MIN_BLEND_SPEED:
		movement_state += BLEND_TO_RUN
	else:
		movement_state -= BLEND_TO_IDLE
	movement_state = clamp(movement_state, 0, 1)

	$Armature/AnimationTree.set("parameters/Move/blend_amount", movement_state)
