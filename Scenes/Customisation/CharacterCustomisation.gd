extends Spatial

var materials_list = {}
var current_material = 0
var current_player
var selected_material  # material passed to customisation.gd


func _ready():
	get_tree().paused = false
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
	
	selected_material = load(materials_list[current_material])
	
	Male.set_surface_material(0, selected_material)
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
	Customisation.Player_materials = selected_material
	Customisation.Player_character = current_player
	
	get_tree().change_scene("res://Level/Level1.tscn")
