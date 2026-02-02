extends CharacterBody2D
class_name Player

@export var speed = 100
@export var jump_strength = 1000
@export var rotation_speed = 2.5
@export var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var rot := 0
var screen_size : Vector2
var rotation_direction = 0
var raindrop_in : Raindrop = null
var is_under_water := false
const TERM_VEL := 600
const DROWN_TIME := 5.0

func _ready():
	screen_size = get_parent().texture.get_size()
	$Camera2D.limit_left = 0
	$Camera2D.limit_top = 0
	$Camera2D.limit_right = screen_size.x
	$Camera2D.limit_bottom = screen_size.y
	
	$DrownTimer.connect("timeout", on_drown)


func _physics_process(delta: float) -> void:
	if not raindrop_in:
		rotation_direction = Input.get_axis("left", "right")
		velocity = transform.x * speed
		rotation += rotation_direction * rotation_speed * delta	
		if not is_on_floor():
			velocity.y += gravity * delta
	else:
		velocity.x = 0
		velocity.y = raindrop_in.linear_velocity.y
		
	if Input.is_action_just_pressed("up"):
		velocity.y = -jump_strength

	if velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
		
	if is_under_water:
		$DrownLabel.text = str(int($DrownTimer.time_left))
	else:
		$DrownLabel.text = ""
	
	
	move_and_slide()
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
			
	position = position.clamp(Vector2.ZERO, screen_size)
	
func on_water_entered() -> void:
	is_under_water = true
	$DrownTimer.start(DROWN_TIME)

func on_water_exited() -> void:
	is_under_water = false
	$DrownTimer.stop()
	
func on_drown() -> void:
	pass
