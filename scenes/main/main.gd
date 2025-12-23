extends Node2D

@onready var timer: Timer = $SpawnTimer
@onready var speed_burst_timer: Timer = $SpeedBurstTimer

const BLOB = preload("uid://b6chd6vkxeaaa")

var spawn_interval: int = 3

func _ready() -> void:
	timer.timeout.connect(_spawn_blob)
	timer.wait_time = spawn_interval

	speed_burst_timer.timeout.connect(_speed_burst)

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
