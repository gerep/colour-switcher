extends Area2D

const SPEED: float = 200.0

var current_color: int
var speed_multiplier: float = 1.0
var success_pitch: float = 1.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var gpu_particles_2d: GPUParticles2D = $CollisionParticle
@onready var burst_particle: GPUParticles2D = $BurstParticle


func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(_remove_from_scene)
	body_entered.connect(_collision)

	Signals.burst_started.connect(_burst_started)
	Signals.burst_ended.connect(_burst_ended)

	position.x = randf_range(36.0, 700.0)

	current_color = randi_range(0, Colors.LIST.size() - 1)
	sprite_2d.modulate = Colors.LIST[current_color]

	gpu_particles_2d.modulate = Colors.LIST[current_color]
	burst_particle.modulate = Colors.LIST[current_color]

	if Game.burst_happening:
		burst_particle.emitting = true
		speed_multiplier = 1.5


func _process(delta: float) -> void:
	position.y += SPEED * delta * speed_multiplier


func _collision(body: Node2D) -> void:
	if body.current_color == current_color:
		gpu_particles_2d.emitting = true
		sprite_2d.visible = false
		burst_particle.emitting = false
		Game.combo_counter += 1
		Game.player_score += 1 * Game.combo_counter
		Signals.score_updated.emit(Game.player_score)
		Signals.combo_updated.emit(Game.combo_counter)
		if Game.combo_counter % 10 == 0:
			Game.success_pitch = 1.0

		Game.success_pitch += 0.1
		Game.play_sucess()
	else:
		Game.combo_counter = 1
		Game.play_failure()
		Signals.game_over.emit()

	await gpu_particles_2d.finished
	call_deferred(&"queue_free")


func _burst_started() -> void:
	burst_particle.emitting = true
	speed_multiplier = 1.5


func _burst_ended() -> void:
	burst_particle.emitting = false
	speed_multiplier = 1.0


func _remove_from_scene() -> void:
	await gpu_particles_2d.finished
	call_deferred(&"queue_free")
