extends CharacterBody2D

@export var speed = 100 # Скорость перемещения игрока

# Получаем доступ к узлу AnimatedSprite2D
@onready var animated_sprite = $AnimatedSprite2D

var movement_velocity = Vector2.ZERO

func get_input():
	# Читаем текущее направление ввода
	var input_dir = Input.get_vector("left", "right", "up", "down").normalized()

	# Очищаем вектор скорости, если нет входящего сигнала
	if input_dir == Vector2.ZERO:
		movement_velocity = Vector2.ZERO
	else:
		# Устанавливаем новую скорость, если есть сигнал управления
		movement_velocity = input_dir * speed

	# Настраиваем анимацию исходя из направления движения
	if input_dir != Vector2.ZERO:
		if abs(input_dir.y) > abs(input_dir.x):
			# Основное направление — вертикально
			if input_dir.y > 0:
				animated_sprite.play("run_down")
			elif input_dir.y < 0:
				animated_sprite.play("run_up")
		else:
			# Основное направление — горизонтально
			if input_dir.x > 0:
				animated_sprite.play("run_front")
				animated_sprite.flip_h = true
			elif input_dir.x < 0:
				animated_sprite.play("run_front")
				animated_sprite.flip_h = false
	else:
		# Герой не двигается, используем состояние покоя
		if abs(movement_velocity.y) > abs(movement_velocity.x):
			if movement_velocity.y > 0:
				animated_sprite.play("idle_down")
			elif movement_velocity.y < 0:
				animated_sprite.play("idle_up")
		else:
			animated_sprite.play("idle_front")

func _physics_process(delta):
	# Передаем расчетную скорость в движке физику
	velocity = movement_velocity
	move_and_slide()
	get_input()
