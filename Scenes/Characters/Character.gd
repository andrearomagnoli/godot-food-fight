extends KinematicBody

const PROJECTILE_SPEED = 50

var can_fire = true
var food_types = {}


func _ready():
	food_types = file_grabber.get_files("res://Projectiles/Food_Types/")
	randomize()


func try_to_fire():
	if can_fire:
		fire()
		can_fire = false
		$ProjectileCooldown.start()


func fire():
	var random_food = food_types[randi() % food_types.size()]
	var projectile = load(random_food).instance()
	
	add_child(projectile)
	projectile.set_as_toplevel(true)
	projectile.global_transform = $Forward.global_transform
	
	var character_forward = global_transform.basis.z.normalized()
	projectile.linear_velocity = character_forward * PROJECTILE_SPEED


func _on_ProjectileCooldown_timeout():
	can_fire = true
