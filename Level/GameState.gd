extends Spatial

var enemies_left


func _ready():
	instance_playing_character()
	count_enemies()


func count_enemies():
	enemies_left = find_node('Robots', true, true).get_child_count()


func instance_playing_character():
	var Player
	
	if Customisation.Player_character == 'Male':
		Player = Customisation.male.instance()
	# add eventual other players
	
	add_child(Player)
	Player.transform = $PlayerStart.transform


func remove_enemy():
	enemies_left -= 1
	if enemies_left < 1:
		get_tree().change_scene("res://Scenes/GUI/GameOver/Victory.tscn")
