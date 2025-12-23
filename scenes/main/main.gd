extends Node2D

const BLOB = preload("uid://b6chd6vkxeaaa")

var spawn_interval: int = 3

@onready var timer: Timer = $SpawnTimer
@onready var speed_burst_timer: Timer = $SpeedBurstTimer
@onready var right_line: Line2D = $RightLine
@onready var left_line: Line2D = $LeftLine
@onready var bottom_line: Line2D = $BottomLine


func _ready() -> void:
	timer.timeout.connect(_spawn_blob)
	timer.wait_time = spawn_interval

	speed_burst_timer.timeout.connect(_speed_burst)

	Signals.right_bar_color_changed.connect(_right_bar_color_changed)
	Signals.left_bar_color_changed.connect(_left_bar_color_changed)
	Signals.bottom_bar_color_changed.connect(_bottom_bar_color_changed)

	# Drop the first blob to avoid waiting.
	_spawn_blob()


func _spawn_blob() -> void:
	var blob = BLOB.instantiate()
	add_child(blob)


func _speed_burst() -> void:
	Signals.burst_started.emit()
	speed_burst_timer.stop()
	timer.wait_time = 1
	await get_tree().create_timer(5).timeout
	timer.wait_time = spawn_interval
	speed_burst_timer.start()
	Signals.burst_ended.emit()


func _right_bar_color_changed(index: int) -> void:
	right_line.modulate = Colors.LIST[index]


func _left_bar_color_changed(index: int) -> void:
	left_line.modulate = Colors.LIST[index]


func _bottom_bar_color_changed(index: int) -> void:
	bottom_line.modulate = Colors.LIST[index]
