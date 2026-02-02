extends RigidBody2D
class_name FallingMagma

const magma_texture := preload("res://assets/magma/magma.png")
const hot_magma_texture := preload("res://assets/magma/hot_magma.png")
const cool_magma_texture := preload("res://assets/magma/cooled_magma.png")
const EROSION_TIME := 5
var is_falling := true

func _ready() -> void:
	$ErosionTimer.connect("timeout", _on_erosion)

func on_water_entered() -> void:
	print('magma in water')
	is_falling = false
	self.gravity_scale = 0
	self.linear_velocity = Vector2.ZERO
	$Sprite2D.texture = cool_magma_texture
	$ErosionTimer.start(EROSION_TIME)
	
func _on_erosion() -> void:
	self.queue_free()
