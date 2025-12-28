extends CharacterBody2D
class_name BaseEntity

# ======================
# CONFIG
# ======================
@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -400.0
@export var MAX_LIFE: int = 100

# ======================
# ESTADO
# ======================
var life: int
var is_dead: bool = false


# ======================
# READY
# ======================
func _ready() -> void:
	life = MAX_LIFE


# ======================
# MOVIMIENTO GENÉRICO
# ======================
func move_left() -> void:
	velocity.x = -SPEED


func move_right() -> void:
	velocity.x = SPEED


func stop_horizontal() -> void:
	velocity.x = 0


func jump() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY


# ======================
# COMBATE / DAÑO
# ======================
func on_take_damage(damage: int, source: BaseEntity) -> void:
	# 🔒 validaciones duras
	if damage <= 0:
		return

	if is_dead:
		return

	if life <= 0:
		return

	# aplicar daño
	life -= damage
	life = max(life, 0)

	print("❤️ LIFE:", life)

	# muerte tiene prioridad absoluta
	if life == 0:
		die()
		return

	# solo si SOBREVIVE
	on_damage_received(source)


# Hook para clases hijas (knockback, animaciones, etc.)
func on_damage_received(_source: BaseEntity) -> void:
	pass


func die() -> void:
	if is_dead:
		return

	is_dead = true
	print("☠️", name, "DIED")

	queue_free()


# ======================
# FÍSICA BASE
# ======================
func _physics_process(delta: float) -> void:
	if is_dead:
		return

	apply_gravity(delta)
	move_and_slide()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
