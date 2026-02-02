extends TileMapLayer
class_name Magma

const falling_tile_packed := preload("res://entities/falling_magma/falling_magma.tscn")

func _ready() -> void:
	SignalBus.fall_tile.connect(_on_fall_tile)

func _on_fall_tile(tile_pos: Vector2i) -> void:
	self.erase_cell(tile_pos)
	var falling_tile = falling_tile_packed.instantiate()
	get_tree().current_scene.call_deferred("add_child", falling_tile)
	falling_tile.global_position = self.map_to_local(tile_pos)
	
