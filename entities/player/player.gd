extends CharacterBody2D

@export var speed = 100
@export var jump_strength = 1000
@export var rotation_speed = 2.5
@export var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var rot := 0
var screen_size : Vector2
var rotation_direction = 0
const TERM_VEL := 600

func _ready():
	screen_size = get_viewport_rect().size

func get_input():
	rotation_direction = Input.get_axis("left", "right")
	velocity = transform.x * speed

func _physics_process(delta: float) -> void:
	get_input()
	rotation += rotation_direction * rotation_speed * delta	
		
	if Input.is_action_just_pressed("up"):
		velocity.y = -jump_strength

	if not is_on_floor():
		velocity.y += gravity * delta

	if velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
	
	move_and_slide()
