extends BaseEntity

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_sfx: AudioStreamPlayer = $HitSfx

# ======================
# CONFIG DAÑO
# ======================
@export var KNOCKBACK_FORCE: float = 200.0
@export var KNOCKBACK_TIME: float = 0.18
@export var INVULNERABLE_TIME: float = 0.6

# ======================
# CONFIG ROLL
# ======================
@export var ROLL_SPEED: float = 700.0
@export var ROLL_COOLDOWN: float = 0.5

# ======================
# ESTADO
# ======================
var is_rolling: bool = false
var can_roll: bool = true

var is_knockback: bool = false
var invulnerable: bool = false


# ======================
# HELPERS
# ======================
func play_anim(anim: String) -> void:
	if sprite.animation != anim:
		sprite.play(anim)


func is_anim_locked() -> bool:
	return is_knockback or is_rolling


# ======================
# DAÑO / KNOCKBACK
# ======================
func on_damage_received(source: BaseEntity) -> void:
	if invulnerable or is_dead:
		return

	invulnerable = true
	is_knockback = true
	
	hit_sfx.stream = preload("res://music/playerhit.ogg")
	hit_sfx.volume_db = -8
	play_anim("Hit")
	hit_sfx.play()

	var dir: float = sign(global_position.x - source.global_position.x)
	if dir == 0:
		dir = -1 if sprite.flip_h else 1

	velocity.x = dir * KNOCKBACK_FORCE
	velocity.y = JUMP_VELOCITY * 0.6

	await get_tree().create_timer(KNOCKBACK_TIME).timeout
	is_knockback = false
	velocity = Vector2.ZERO

	await get_tree().create_timer(INVULNERABLE_TIME).timeout
	invulnerable = false

# ======================
# ROLL
# ======================
func roll() -> void:
	if not can_roll or is_rolling or is_knockback or is_dead:
		return

	is_rolling = true
	can_roll = false

	var dir: int = -1 if sprite.flip_h else 1
	sprite.flip_h = dir < 0
	play_anim("Roll")

	velocity.x = dir * ROLL_SPEED

	await sprite.animation_finished
	is_rolling = false
	velocity.x = 0
	print("🏁 ROLL END")

	await get_tree().create_timer(ROLL_COOLDOWN).timeout
	can_roll = true
	print("🔄 ROLL COOLDOWN END")


# ======================
# MUERTE
# ======================
func die() -> void:
	if is_dead:
		return

	is_dead = true
	print("☠️ PLAYER DIE")

	set_physics_process(false)
	set_collision_layer(0)
	set_collision_mask(0)

	play_anim("Die")

	await sprite.animation_finished
	get_tree().change_scene_to_file("res://scenes/ui/Main_Menu.tscn")


# ======================
# FÍSICA / INPUT
# ======================
func _physics_process(delta: float) -> void:
	# ─────────────────────────
	# 🔒 KNOCKBACK
	# ─────────────────────────
	if is_knockback:
		super._physics_process(delta)
		return

	# ─────────────────────────
	# 🔒 ROLL
	# ─────────────────────────
	if is_rolling:
		super._physics_process(delta)
		return

	var moving := false

	# ───────── INPUT NORMAL
	if Input.is_action_pressed("ui_left"):
		move_left()
		sprite.flip_h = true
		moving = true

	elif Input.is_action_pressed("ui_right"):
		move_right()
		sprite.flip_h = false
		moving = true

	else:
		stop_horizontal()

	if Input.is_action_just_pressed("ui_accept"):
		jump()

	if Input.is_action_just_pressed("ui_roll") and can_roll:
		roll()

	# ───────── ANIMACIONES
	if is_anim_locked():
		super._physics_process(delta)
		return

	if moving:
		play_anim("Walk")
	elif is_on_floor():
		play_anim("Idle")

	super._physics_process(delta)
