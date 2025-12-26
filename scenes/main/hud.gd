extends CanvasLayer

var burst_bb_text: String = "[center][shake rate={0} level={0} connected=1]BURST TIME x{1}[/shake][/center]"
var menu_bb_text: String = "[center][wave]{0}[/wave][/center]"
var game_over_points_text: String = "[center][wave]{0} POINTS[/wave][/center]"
var min_rate_level: float = 5.0
var max_rate_level: float = 35.0
var current_rate_level: float = 5.0
var burst_counter: int = 0

@onready var points_label: Label = %PointsLabel
@onready var burst_time_label: RichTextLabel = %BurstTimeLabel
@onready var chromatic_aberration: ColorRect = $ChromaticAberration
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var start_button: Button = $Control/MenuContainer/CenterContainer/VBoxContainer/StartButton
@onready var retry_button: Button = $Control/GameOverContainer/CenterContainer/VBoxContainer/RetryButton
@onready var score_container: PanelContainer = %ScoreContainer
@onready var menu_container: PanelContainer = %MenuContainer
@onready var game_over_label: RichTextLabel = %GameOverLabel
@onready var game_over_container: PanelContainer = %GameOverContainer
@onready var combo_label: RichTextLabel = %ComboLabel
@onready var tutorial_label: Label = %TutorialLabel


func _ready() -> void:
	Signals.score_updated.connect(_update_score)
	Signals.combo_updated.connect(_update_combo)
	Signals.burst_started.connect(_burst_started)
	Signals.burst_ended.connect(_burst_ended)
	Signals.start_game.connect(_start_game)
	Signals.game_over.connect(_game_over)
	Signals.first_click.connect(func(): tutorial_label.visible = false)

	start_button.pressed.connect(func(): Signals.start_game.emit())
	retry_button.pressed.connect(func(): Signals.start_game.emit())

	var menu = "COLOR SWITCHER"
	var colored_text: String = ""

	for letter in menu:
		colored_text += "[color={0}]{1}[/color]".format([Colors.LIST.pick_random().to_html(), letter])

	rich_text_label.text = menu_bb_text.format([colored_text])
	score_container.visible = false
	game_over_container.visible = false
	menu_container.visible = true


func _game_over():
	score_container.visible = false
	menu_container.visible = false
	game_over_container.visible = true
	tutorial_label.visible = false
	combo_label.text = ""
	game_over_label.text = game_over_points_text.format([Game.player_score])


func _start_game():
	menu_container.visible = false
	game_over_container.visible = false
	score_container.visible = true
	tutorial_label.visible = true


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


func _update_combo(value: int) -> void:
	var text: String = ""
	if value < 5:
		text = "[wave][color=579c7aff]x%d[/color][/wave]" % value
	elif value < 10:
		text = "[wave][color=a66b45ff]x%d[/color][/wave]" % value
	else:
		text = "[wave][color=d96361ff]x%d[/color][/wave]" % value

	combo_label.text = text
