extends Spatial

var materials_list = {}
var current_material = 0
var current_player


func _ready():
	materials_list = file_grabber.get_files("res://Models/Players/PlayerMaterials/")
	current_player = 'Male'
	# hide other armatures that are selectable


func _on_CharacterSelect_item_selected(ID):
	$ArmatureM.hide()
	
	match ID:
		0:
			current_player = 'Male'
			$ArmatureM.show()


func change_material(direction):
	var materials_count = materials_list.size() - 1
	
	select_material(direction, materials_count)
	
	var Male = $ArmatureM/Mesh
	# do the same for other armatures
	
	Male.set_surface_material(0, load(materials_list[current_material]))
	# do the same for other armatures


func select_material(direction, materials_count):
	if direction == 'Right':
		if current_material == materials_list.size() - 1:
			current_material = 0
		else:
			current_material += 1
	else:
		if current_material == 0:
			current_material = materials_list.size() - 1
		else:
			current_material -= 1


func _on_StartButton_pressed():
	get_tree().change_scene("res://Level/Level1.tscn")
