extends Node

@export var inventory_menu_packed : PackedScene
@export var focused_viewport : Viewport

var inventory_menu : Node

func _unhandled_input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if inventory_menu.visible: return
	if event.is_action_pressed("inventory"):
		print("Inventory opened")
		if inventory_menu.visible: return
		if not focused_viewport:
			focused_viewport = get_viewport()
		var _initial_focus_control = focused_viewport.gui_get_focus_owner()
		inventory_menu.show()
		if inventory_menu is CanvasLayer:
			await inventory_menu.visibility_changed
		else:
			await inventory_menu.hidden
		if is_inside_tree() and _initial_focus_control:
			_initial_focus_control.grab_focus() 

func _ready() -> void:
	inventory_menu = inventory_menu_packed.instantiate()
	inventory_menu.hide()
	get_tree().current_scene.call_deferred("add_child", inventory_menu)
