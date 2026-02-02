extends RigidBody2D
class_name Raindrop

func init(spawn_pos: Vector2) -> void:
	position = spawn_pos

func on_water_entered() -> void:
	self.queue_free()
