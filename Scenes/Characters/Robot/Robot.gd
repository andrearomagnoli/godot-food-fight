extends "res://Scenes/Characters/Character.gd"

func _ready():
	character_type = CHARACTER_TYPE.npc


func _physics_process(delta):
	if $RayCast.is_colliding():
		try_to_fire(INF)
