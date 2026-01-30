extends Area2D

@export var speed = Vector2(400,600)
var flipped: bool = true
var rot := 0
var screen_size : Vector2
const GRAVITY := 300
const TERM_VEL := 600

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO 
	if Input.is_action_pressed("right"):
		velocity.x += speed.x
		flipped = true
	if Input.is_action_pressed("left"):
		velocity.x -= speed.x
		flipped = false
		
	if Input.is_action_just_pressed("up"):
		velocity.y = -10000
		rot = 315

	if velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
	else:
		# if grounded: $AnimatedSprite2D.play("idle")
		# $AnimatedSprite2D.play("idle")
		$AnimatedSprite2D.play("idle")
	velocity.y += GRAVITY
	rot += 1
	if rot >= 360: rot = 0
	if rot < 315 and rot > 45: rot = 45
	$AnimatedSprite2D.rotation_degrees = rot
	
	if $AnimatedSprite2D.scale.x == 1 and flipped: 
		$AnimatedSprite2D.scale.x = -1
	elif $AnimatedSprite2D.scale.x == -1 and not flipped: 
		$AnimatedSprite2D.scale.x = 1
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	print($AnimatedSprite2D.rotation_degrees)
