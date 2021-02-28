extends RigidBody


func _on_Projectile_body_shape_entered(body_id, body, body_shape, local_shape):
	if body.has_method('hurt'):
		body.hurt()
		queue_free()
