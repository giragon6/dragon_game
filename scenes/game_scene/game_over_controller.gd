extends Node

## Node for opening a pause menu when detecting a 'ui_cancel' event.

@export var game_over_menu_packed : PackedScene
@export var focused_viewport : Viewport

var game_over_menu : Node

func _ready() -> void:
	SignalBus.game_over.connect(_on_game_over)
	game_over_menu = game_over_menu_packed.instantiate()
	game_over_menu.set_score(0)
	SignalBus.set_final_score.connect(game_over_menu.set_score)
	game_over_menu.hide()
	get_tree().current_scene.call_deferred("add_child", game_over_menu)

func _on_game_over() -> void:
	if game_over_menu.visible: return
	if not focused_viewport:
		focused_viewport = get_viewport()
	var _initial_focus_control = focused_viewport.gui_get_focus_owner()
	game_over_menu.show()
	if game_over_menu is CanvasLayer:
		await game_over_menu.visibility_changed
	else:
		await game_over_menu.hidden
	if is_inside_tree() and _initial_focus_control:
		_initial_focus_control.grab_focus()
