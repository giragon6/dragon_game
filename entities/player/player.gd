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
const TERM_VEL := 600

func _ready():
	screen_size = get_viewport_rect().size


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
	
	move_and_slide()
	raindrop_in = null
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print(collision)
		var collider = collision.get_collider()
		if collider is Raindrop:
			raindrop_in = collider
			# get sucked into the raindrop because of surface tension or something
			position = raindrop_in.position
			print(raindrop_in)
