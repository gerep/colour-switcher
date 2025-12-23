extends CanvasLayer

@onready var points_label: Label = %PointsLabel
@onready var burst_time_label: RichTextLabel = %BurstTimeLabel


func _ready() -> void:
	Signals.score_updated.connect(_update_score)
	Signals.burst_started.connect(func(): burst_time_label.visible = true)
	Signals.burst_ended.connect(func(): burst_time_label.visible = false)


func _update_score(value: int) -> void:
	points_label.text = str(value)
