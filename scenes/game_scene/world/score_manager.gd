extends Node

var play_time := 0.0
var score := 0

func _ready() -> void:
	SignalBus.game_over.connect(_on_game_over)

func _process(delta: float) -> void:
	play_time += delta
	
func _on_game_over() -> void:
	score += int(play_time)
	SignalBus.set_final_score.emit(score)
