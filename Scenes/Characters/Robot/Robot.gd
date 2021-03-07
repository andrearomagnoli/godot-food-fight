extends "res://Scenes/Characters/Character.gd"


signal remove_enemy


func _ready():
	character_type = CHARACTER_TYPE.npc
	var gamestate = get_parent().get_parent()
	connect('remove_enemy', gamestate, 'remove_enemy')


func _physics_process(delta):
	if $RayCast.is_colliding():
		try_to_fire(INF)


func update_lives():
	if lives > 0:
		var animation = $Lives.get_child(0).get_child(0)
		animation.play("Lose Life")


func die():
	emit_signal('remove_enemy')
	queue_free()
