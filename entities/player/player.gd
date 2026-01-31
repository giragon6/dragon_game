extends CharacterBody2D

@export var speed = 100
@export var jump_strength = 1000
@export var rotation_speed = 2.5
var rot := 0
var screen_size : Vector2
var rotation_direction = 0
const GRAVITY := 50
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
	velocity.y += GRAVITY

	if velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
	
	move_and_slide()
