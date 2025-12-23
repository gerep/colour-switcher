extends Area2D

var current_color: int

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	body_entered.connect(_collision)

	position.x = randf_range(36.0, 700.0)

	current_color = randi_range(0, Colors.LIST.size() - 1)
	sprite_2d.modulate = Colors.LIST[current_color]


func _process(delta: float) -> void:
	position.y += 200 * delta


func _collision(body: Node2D) -> void:
	if body.current_color == current_color:
		Game.player_score += 1
		Signals.score_updated.emit(Game.player_score)
	else:
		pass

	call_deferred(&"queue_free")
