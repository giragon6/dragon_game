extends CharacterBody2D
class_name Player

@export var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var screen_size : Vector2

var raindrop_in : Raindrop = null
var is_under_water := false
var is_diving := false

var score := 0
const DROWN_TIME := 2.0

var speed = 0
var acceleration = 200
var rotation_speed = 1.5
var speed_max = 1000
var rotation_direction = 0

func _ready():
	$AnimatedSprite2D.play("fly")
	
	screen_size = get_parent().texture.get_size()
	$Camera2D.limit_left = 0
	$Camera2D.limit_top = 0
	$Camera2D.limit_right = screen_size.x
	$Camera2D.limit_bottom = screen_size.y
	
	$DrownTimer.connect("timeout", _on_drown)

func _physics_process(delta: float) -> void:	
	if raindrop_in:
		velocity.x = 0
		velocity.y = raindrop_in.linear_velocity.y
	else:
		rotation_direction = Input.get_axis("left", "right")
		speed += Input.get_axis("down", "up") * acceleration * delta
		clamp(speed,0,speed_max)
		velocity = transform.x * speed
		rotation += rotation_direction * rotation_speed * delta
		print(rotation)
		if abs(rotation) > 1.0:
			$AnimatedSprite2D.flip_v = true
		else:
			$AnimatedSprite2D.flip_v = false
		velocity.y += gravity * delta
		
	_update_drown()
	move_and_slide()
	_handle_collisions()
	position = position.clamp(Vector2.ZERO, screen_size)
	
func _update_drown() -> void:
	if is_under_water:
		$DrownLabel.text = str(ceili($DrownTimer.time_left))
	else:
		$DrownLabel.text = ""

func _handle_collisions() -> void:
	raindrop_in = null
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is Raindrop:
			raindrop_in = collider
			# get sucked into the raindrop because of surface tension or something
			position = raindrop_in.position
		elif collider is Magma:
			var world_pos = collision.get_position()
			world_pos -= collision.get_normal() # offset
			var local_pos = collider.to_local(world_pos)
			var tile_coords = collider.local_to_map(local_pos)
			if collider.get_cell_source_id(tile_coords) == 0: # magma
				SignalBus.fall_tile.emit(tile_coords)	

func on_water_entered() -> void:
	is_under_water = true
	speed = 0
	$DrownTimer.start(DROWN_TIME)

func on_water_exited() -> void:
	is_under_water = false
	$DrownTimer.stop()
	
func _on_drown() -> void:
	SignalBus.game_over.emit()
