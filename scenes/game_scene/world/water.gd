extends Area2D
class_name Water

const RISE_SPEED := 10

func _process(delta: float) -> void:
	if position.y > 0:
		position.y -= RISE_SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Raindrop or body is Player:
		body.on_water_entered()

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.on_water_exited()
