extends "res://Scenes/Characters/Character.gd"

const SPEED = 10
const UP = Vector3(0,1,0)
const MIN_BLEND_SPEED = 0.125  #  min movem before we start blending animations
const BLEND_TO_RUN = 0.075
const BLEND_TO_IDLE = 0.1
const BLEND_TO_RELOAD = 0.1
const BLEND_TO_FIRE = 0.4
const ACTION_RESET_RATE = 0.05

var motion = Vector3()
var movement_state = 0  # idle:0, run:1
var action_state = 0 # throw:-1, idle/move:0, reload:+1
var ammo = 0
var can_refill = false
var is_firing = false

export var mouse_sensitivity = 1200
export var max_ammo = 5


func _ready():
	character_type = CHARACTER_TYPE.player
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Customisation.Player_materials != null:
		$Armature/Mesh.set_surface_material(0, Customisation.Player_materials)
	update_lives()


func _physics_process(_delta):
	move()
	animate()
	refresh_refill_counter()


func _input(event):
	if event is InputEventMouseMotion:
		rotation = h_camera_rotation(-event.relative.x/mouse_sensitivity)
		$Camera.rotation = v_camera_rotation(-event.relative.y/mouse_sensitivity)
	
	if Input.is_action_just_pressed("fire"):
		ammo = try_to_fire(ammo)
		is_firing = true
		$FireTImer.start()
		update_gui()


func move():
	var movement_2d_dir = get_2d_movement_dir()
	var direction = Vector3.ZERO
	var camera_xform = $Camera.global_transform
	
	direction -= camera_xform.basis.z.normalized() * movement_2d_dir[0]
	direction += camera_xform.basis.x.normalized() * movement_2d_dir[1]
	direction.y = 0
	
	motion = direction

	move_and_slide(motion * SPEED, UP)


func get_2d_movement_dir():
	var x = Input.get_action_strength("forward") - Input.get_action_strength("back")
	var y = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	var movement_dir = Vector2(x,y)
	
	if not movement_dir == Vector2.ZERO:
		face_forward(x,y)
	
	return movement_dir.normalized()


func face_forward(x, y):
	$Armature.rotation.y = atan2(x,y) - PI/2


func animate():
	if (motion * SPEED).length() > MIN_BLEND_SPEED:
		movement_state += BLEND_TO_RUN
	else:
		movement_state -= BLEND_TO_IDLE
	movement_state = clamp(movement_state, 0, 1)
	
	if is_firing:
		action_state -= BLEND_TO_FIRE
	elif can_refill:
		action_state += BLEND_TO_RELOAD
	action_state = clamp(action_state, -1, 1)
	action_state = lerp(action_state, 0, ACTION_RESET_RATE)

	$Armature/AnimationTree.set("parameters/Move/blend_amount", movement_state)
	$Armature/AnimationTree.set("parameters/Action/blend_amount", action_state)


func h_camera_rotation(camera_rotation):
	return rotation + Vector3(0,camera_rotation,0)


func v_camera_rotation(camera_rotation):
	var rot = $Camera.rotation + Vector3(camera_rotation,0,0)
	rot.x = clamp(rot.x, -PI/8, PI/8)
	return rot


func _on_RefillTimer_timeout():
	ammo += 1
	update_gui()
	if check_ammo():
		$RefillTimer.start()


func _on_FireTImer_timeout():
	is_firing = false


func check_ammo():
	if ammo < max_ammo:
		return true


func refill_enter():
	if check_ammo():
		$RefillTimer.start()
		can_refill = true
		$Harp.play()


func refill_exit():
	$RefillTimer.stop()
	can_refill = false
	$Harp.stop()


func update_gui():
	get_tree().call_group('GUI', 'refresh_AmmoCount', ammo)


func refresh_refill_counter():
	if can_refill:
		var refill_time_left = 1 - $RefillTimer.get_time_left()
		get_tree().call_group('GUI', 'Refill', refill_time_left)
	else:
		get_tree().call_group('GUI', 'Refill', 0.0)


func update_lives():
	if character_type == CHARACTER_TYPE.player:
		get_tree().call_group('GUI', 'update_lives', lives)


func die():
	get_tree().change_scene("res://Scenes/GUI/GameOver/GameOver.tscn")
