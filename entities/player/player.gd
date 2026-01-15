extends Area2D

@export var speed = 400
var flipped: bool = false
var screen_size : Vector2

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO 
	if Input.is_action_pressed("right"):
		velocity.x += 1
		flipped = false
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		flipped = true
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
		
	if $AnimatedSprite2D.scale.x == 1 and flipped: 
		$AnimatedSprite2D.scale.x = -1
	elif $AnimatedSprite2D.scale.x == -1 and not flipped: 
		$AnimatedSprite2D.scale.x = 1
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
