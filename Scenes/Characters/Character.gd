extends KinematicBody

const PROJECTILE_SPEED = 50

onready var projectile_preload = load("res://Projectiles/Projectile.tscn")

var can_fire = true


func fire():
	if can_fire:
		var projectile = projectile_preload.instance()
		
		add_child(projectile)
		projectile.set_as_toplevel(true)
		projectile.global_transform = $Forward.global_transform
		
		var character_forward = global_transform.basis.z.normalized()
		projectile.linear_velocity = character_forward * PROJECTILE_SPEED
		
		$ProjectileCooldown.start()
		can_fire = false


func _on_ProjectileCooldown_timeout():
	can_fire = true
