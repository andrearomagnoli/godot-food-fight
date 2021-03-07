extends Spatial

var enemies_left


func _ready():
	enemies_left = find_node('Robots', true, true).get_child_count()


func remove_enemy():
	enemies_left -= 1
	if enemies_left < 1:
		get_tree().change_scene("res://Scenes/GUI/GameOver/Victory.tscn")
