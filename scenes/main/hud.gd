extends CanvasLayer

var burst_bb_text: String = "[center][shake rate={0} level={0} connected=1]BURST TIME x{1}[/shake][/center]"
var min_rate_level: float = 5.0
var max_rate_level: float = 35.0
var current_rate_level: float = 5.0
var burst_counter: int = 0

@onready var points_label: Label = %PointsLabel
@onready var burst_time_label: RichTextLabel = %BurstTimeLabel
@onready var chromatic_aberration: ColorRect = $ChromaticAberration


func _ready() -> void:
	Signals.score_updated.connect(_update_score)
	Signals.burst_started.connect(_burst_started)
	Signals.burst_ended.connect(_burst_ended)


func _burst_started() -> void:
	chromatic_aberration.visible = true
	if current_rate_level == max_rate_level:
		burst_counter = 0
		current_rate_level = min_rate_level

	burst_counter += 1
	# Increment max_rate_level because that value is exclusive in the wrapf function.
	current_rate_level = wrapf(current_rate_level + 5.0, min_rate_level, max_rate_level + 1)

	burst_time_label.text = burst_bb_text.format([current_rate_level, burst_counter])
	burst_time_label.visible = true


func _burst_ended() -> void:
	chromatic_aberration.visible = false
	burst_time_label.visible = false


func _update_score(value: int) -> void:
	points_label.text = str(value)
