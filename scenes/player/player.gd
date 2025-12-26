extends StaticBody2D

var current_color: int = 0
var _max_colors: int = 0

@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var left_click: AudioStreamPlayer2D = $LeftClick
@onready var right_click: AudioStreamPlayer2D = $RightClick


func _ready() -> void:
	player_sprite.modulate = Colors.LIST[0]
	_max_colors = Colors.LIST.size()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"left_button"):
		left_click.play()
		current_color = wrapi(current_color + 1, 0, _max_colors)
	elif event.is_action_pressed(&"right_button"):
		right_click.play()
		current_color = wrapi(current_color - 1, 0, _max_colors)

	_change_color(player_sprite, current_color)
	_change_neighbouring_colors()


func _change_color(sprite: Sprite2D, color_index: int) -> void:
	sprite.modulate = Colors.LIST[color_index]
	Signals.bottom_bar_color_changed.emit(color_index)


func _change_neighbouring_colors() -> void:
	var left_index: int = wrapi(current_color + 1, 0, _max_colors)
	var right_index: int = wrapi(current_color - 1, 0, _max_colors)
	Signals.right_bar_color_changed.emit(right_index)
	Signals.left_bar_color_changed.emit(left_index)
