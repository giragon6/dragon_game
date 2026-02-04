extends Node

@onready var tutorial_nodes : Array[Control] = [$Tutorial1, $Tutorial2, $Tutorial3]
var curr_node := 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_continue()

func _ready() -> void:
	for t in tutorial_nodes:
		t.visible = false
	tutorial_nodes[curr_node].visible = true
	
func _continue() -> void:
	print(curr_node)
	print(tutorial_nodes.size())
	if curr_node == tutorial_nodes.size()-1:
		SceneLoader.load_scene("res://scenes/menus/main_menu/main_menu_with_animations.tscn")
		return
		
	tutorial_nodes[curr_node].visible = false
	curr_node += 1
	tutorial_nodes[curr_node].visible = true
