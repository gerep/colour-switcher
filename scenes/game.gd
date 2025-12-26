extends Node2D

var player_score: int
var combo_counter: int = 1
var burst_interval: float = 10.0 # TODO: Should it be 11 to start at 10 on the first -1?
var min_burst_interval: float = 5.0
var burst_duration: float = 5.0
var blob_spawn_interval: float = 2.5
var min_blob_spawn_interval: float = 0.6
var burst_happening: bool

@onready var success_hit: AudioStreamPlayer2D = $SuccessHit
@onready var failure_hit: AudioStreamPlayer2D = $FailureHit


func _ready() -> void:
	Signals.burst_started.connect(func(): burst_happening = true)
	Signals.burst_ended.connect(func(): burst_happening = false)


func decrease_burst_interval() -> void:
	burst_interval = max(burst_interval - 1, min_burst_interval)
	if burst_interval < min_burst_interval:
		reset_burst_interval()


func reset_burst_interval() -> void:
	burst_interval = 10.0


func play_sucess() -> void:
	success_hit.play()


func play_failure() -> void:
	failure_hit.play()
