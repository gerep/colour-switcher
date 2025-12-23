extends Node

var player_score: int
var burst_interval: float = 10.0 # TODO: Should it be 11 to start at 10 on the first -1?
var min_burst_interval: float = 5.0
var burst_duration: float = 5.0
var blob_spawn_interval: float = 3.0
var min_blob_spawn_interval: float = 1.0


func decrease_burst_interval() -> void:
	burst_interval = max(burst_interval - 1, min_burst_interval)
	if burst_interval < min_burst_interval:
		reset_burst_interval()


func reset_burst_interval() -> void:
	burst_interval = 10.0
