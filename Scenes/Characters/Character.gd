extends KinematicBody

const PROJECTILE_SPEED = 50

enum CHARACTER_TYPE {player, npc}

var character_type
var can_fire = true
var food_types = {}

var lives = 3


func _ready():
	character_type = CHARACTER_TYPE.player
	food_types = file_grabber.get_files("res://Projectiles/Food_Types/")
	randomize()


func try_to_fire(ammo):
	if can_fire and ammo > 0:
		fire()
		can_fire = false
		$ProjectileCooldown.start()
		ammo -= 1
	return ammo


func fire():
	var random_food = food_types[randi() % food_types.size()]
	var projectile = load(random_food).instance()
	
	add_child(projectile)
	projectile.set_as_toplevel(true)
	projectile.global_transform = $Forward.global_transform
	projectile.fired_by = character_type
	projectile.add_collision_exception_with(self)
	
	var character_forward = global_transform.basis.z.normalized()
	projectile.linear_velocity = character_forward * PROJECTILE_SPEED


func hurt(fired_by):
	if fired_by != character_type:
		lives -= 1
		$HurtSFX.play()
		check_lives()
	update_lives()


func check_lives():
	if lives < 1:
		die()


func update_lives():
	pass


func die():
	queue_free()


func _on_ProjectileCooldown_timeout():
	can_fire = true
