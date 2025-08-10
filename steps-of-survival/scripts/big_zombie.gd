extends CharacterBody2D

var target = null  # Переменная для хранения цели преследования
var speed = 800     # Скорость движения NPC
var wander_timer = 0.0  # Таймер для смены направления случайного блуждания
var random_time_interval = {"min": 1.0, "max": 3.0}  # Интервал между сменой направлений

@export var detectable_layer_mask = 1 << 0  # Маска слоя обнаружения игрока

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if target != null:
		chase_target()
	else:
		wander_around(delta)

func chase_target() -> void:
	# Если цель обнаружена, двигаемся к игроку
	look_at(target.position)
	velocity = Vector2().rotated(rotation)
	move_and_slide()

func wander_around(delta):
	# Случайное блуждание NPC
	wander_timer += delta
	if wander_timer >= random_time_interval["min"] + randf() * (random_time_interval["max"] - random_time_interval["min"]):
		rotation = deg_to_rad(randf_range(-180, 180))  # Меняем направление вращения случайно
		wander_timer = 0.0
	velocity = Vector2(speed * delta, 0).rotated(rotation)
	move_and_slide()

func _on_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target == body

func _on_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and target == body:
		target = null
