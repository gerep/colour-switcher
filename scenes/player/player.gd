extends StaticBody2D

@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var left_neighbour: Sprite2D = $LeftSprite
@onready var right_neighbour: Sprite2D = $RightSprite

var current_color: int = 0
var _max_colors: int = 0


func _ready() -> void:
	player_sprite.modulate = Colors.list[0]
	_max_colors = Colors.list.size()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"left_button"):
		current_color = wrapi(current_color + 1, 0, _max_colors)
	elif event.is_action_pressed(&"right_button"):
		current_color = wrapi(current_color - 1, 0, _max_colors)

	_change_color(player_sprite, current_color)
	#_change_neighbouring_colors()


func _change_color(sprite: Sprite2D, color_index: int) -> void:
	sprite.modulate = Colors.list[color_index]


func _change_neighbouring_colors() -> void:
	var left_color: int  = wrapi(current_color + 1, 0, _max_colors)
	var right_color: int = wrapi(current_color - 1, 0, _max_colors)

	_change_color(left_neighbour, left_color)
	_change_color(right_neighbour, right_color)
