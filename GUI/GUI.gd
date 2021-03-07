extends CanvasLayer


func refresh_AmmoCount(ammo):
	$Refill/CenterContainer/AmmoCount.text = str(ammo)


func Refill(amount):
	$Refill.value = amount


func update_lives(lives):
	var heart = preload("res://gfx/heart.png")
	$Lives.clear()
	for i in lives:
		$Lives.add_icon_item(heart, false)
