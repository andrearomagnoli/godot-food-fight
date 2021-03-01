extends Area


func _on_RefillArea_body_entered(body):
	if body.has_method('refill_enter'):
		body.refill_enter()


func _on_RefillArea_body_exited(body):
	if body.has_method('refill_exit'):
		body.refill_exit()
