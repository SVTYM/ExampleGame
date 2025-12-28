extends Enemy
class_name SlimeEnemy

@export var ATTACK_DAMAGE := 10
@export var ATTACK_COOLDOWN := 0.4
@export var HIT_START_TIME := 0.12
@export var HIT_DURATION := 0.08

@onready var attack_area: Area2D = $AttackArea

var can_attack := true
var hit_window_open := false
var hit_done := false


func _ready() -> void:
	super._ready()
	assert(attack_area != null, "❌ AttackArea no existe en SlimeEnemy")


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if hit_window_open and not hit_done:
		check_attack_overlap()


func chase() -> void:
	if not target or target.is_dead:
		clear_target()
		return

	var dx := target.global_position.x - global_position.x
	direction = -1 if dx < 0 else 1
	sprite.flip_h = direction > 0

	if can_attack and attack_area.has_overlapping_bodies():
		state = State.ATTACK
		attack()
		return

	sprite.play("Walk")
	velocity.x = direction * MOVE_SPEED


func attack() -> void:
	can_attack = false
	hit_done = false
	velocity.x = 0

	sprite.play("Attack")

	await get_tree().create_timer(HIT_START_TIME).timeout
	hit_window_open = true

	await get_tree().create_timer(HIT_DURATION).timeout
	hit_window_open = false

	await sprite.animation_finished
	state = State.CHASE

	await get_tree().create_timer(ATTACK_COOLDOWN).timeout
	can_attack = true


func check_attack_overlap() -> void:
	for body in attack_area.get_overlapping_bodies():
		if body is BaseEntity:
			var entity := body as BaseEntity
			if entity.is_dead:
				return

			hit_done = true
			entity.on_take_damage(ATTACK_DAMAGE, self)
			break
