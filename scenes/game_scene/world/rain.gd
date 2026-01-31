extends Node2D

@export var raindrop_scene : PackedScene
var screen_size : Vector2

func _ready():
	screen_size = get_viewport_rect().size

func _on_rain_timer_timeout() -> void:
	var drop = raindrop_scene.instantiate()
	var spawn_loc = Vector2(randf_range(0, screen_size.x), 0)
	drop.init(spawn_loc)

	add_child(drop)
