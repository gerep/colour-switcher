extends Node2D

const BLOB = preload("uid://b6chd6vkxeaaa")

@onready var blob_spawn_timer: Timer = $BlobSpawnTimer
@onready var speed_burst_timer: Timer = $SpeedBurstTimer
@onready var right_line: Line2D = $RightLine
@onready var left_line: Line2D = $LeftLine
@onready var bottom_line: Line2D = $BottomLine
@onready var blobs: Node = $Blobs


func _ready() -> void:
	blob_spawn_timer.wait_time = Game.blob_spawn_interval
	speed_burst_timer.wait_time = Game.burst_interval

	blob_spawn_timer.timeout.connect(_spawn_blob)
	speed_burst_timer.timeout.connect(_speed_burst)

	Signals.right_bar_color_changed.connect(_right_bar_color_changed)
	Signals.left_bar_color_changed.connect(_left_bar_color_changed)
	Signals.bottom_bar_color_changed.connect(_bottom_bar_color_changed)
	Signals.start_game.connect(_start_game)
	Signals.game_over.connect(_game_over)


func _game_over() -> void:
	_clear_blobs()
	blob_spawn_timer.stop()
	speed_burst_timer.stop()
	# The game might end during a burst.
	Signals.burst_ended.emit()


func _start_game():
	# Drop the first blob to avoid waiting.
	_spawn_blob()
	blob_spawn_timer.start()
	speed_burst_timer.start()


func _spawn_blob() -> void:
	var blob = BLOB.instantiate()
	blobs.add_child(blob)


func _clear_blobs() -> void:
	for child in blobs.get_children():
		child.queue_free()


func _reset_blob_timer(interval: float) -> void:
	blob_spawn_timer.stop()
	blob_spawn_timer.wait_time = interval
	blob_spawn_timer.start()


func _speed_burst() -> void:
	# Stop it and start again after the burst period.
	speed_burst_timer.stop()

	Signals.burst_started.emit()

	_reset_blob_timer(Game.min_blob_spawn_interval)
	await get_tree().create_timer(Game.burst_duration).timeout
	_reset_blob_timer(Game.blob_spawn_interval)

	# Update the burst interval.
	Game.decrease_burst_interval()

	# Set the new burst duration.
	speed_burst_timer.wait_time = Game.burst_duration
	speed_burst_timer.start()

	Signals.burst_ended.emit()


func _right_bar_color_changed(index: int) -> void:
	right_line.modulate = Colors.LIST[index]


func _left_bar_color_changed(index: int) -> void:
	left_line.modulate = Colors.LIST[index]


func _bottom_bar_color_changed(index: int) -> void:
	bottom_line.modulate = Colors.LIST[index]
