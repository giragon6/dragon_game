extends TileMapLayer
class_name Magma

const falling_tile_packed := preload("res://entities/falling_magma/falling_magma.tscn")
@onready var world_size_tiles := Vector2i(get_parent().texture.get_size()) / self.tile_set.tile_size
@onready var magma_spawn_max_tile_row := world_size_tiles.y / 2

func _ready() -> void:
	SignalBus.fall_tile.connect(_on_fall_tile)

func _on_fall_tile(tile_pos: Vector2i) -> void:
	self.erase_cell(tile_pos)
	var falling_tile = falling_tile_packed.instantiate()
	get_tree().current_scene.call_deferred("add_child", falling_tile)
	falling_tile.global_position = self.map_to_local(tile_pos)

func _on_magma_spawn_timer_timeout() -> void:
	var coords = Vector2i(randi() % world_size_tiles.x, randi() % magma_spawn_max_tile_row)
	self.set_cell(coords, 0, Vector2(0,0))
