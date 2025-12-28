extends BaseEntity
class_name Enemy

enum State { PATROL, CHASE, ATTACK, HIT }
var state: State = State.PATROL

@export var MOVE_SPEED := 80.0
@export var TURN_COOLDOWN := 0.2

var direction := -1
var can_turn := true
var target: BaseEntity = null

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var ledge_ray: RayCast2D = $LedgeRay


func _ready() -> void:
	assert(ledge_ray != null, "❌ LedgeRay no existe en Enemy")
	assert(detection_area != null, "❌ DetectionArea no existe en Enemy")

	detection_area.body_entered.connect(_on_detect)
	detection_area.body_exited.connect(_on_lost)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	match state:
		State.PATROL:
			patrol()
		State.CHASE:
			chase()


func patrol() -> void:
	sprite.play("Walk")
	velocity.x = direction * MOVE_SPEED

	if is_on_wall() or not has_ground_ahead():
		stop_walk_on_first_frame()
		turn_around()


func chase() -> void:
	if not target or target.is_dead:
		clear_target()
		return

	var dx := target.global_position.x - global_position.x
	direction = -1 if dx < 0 else 1
	sprite.flip_h = direction > 0

	sprite.play("Walk")
	velocity.x = direction * MOVE_SPEED


func has_ground_ahead() -> bool:
	if not ledge_ray:
		return true  # fallback seguro

	ledge_ray.target_position.x = direction * abs(ledge_ray.target_position.x)
	ledge_ray.force_raycast_update()
	return ledge_ray.is_colliding()


func stop_walk_on_first_frame() -> void:
	sprite.play("Walk")
	sprite.stop()
	sprite.frame = 0


func turn_around() -> void:
	if not can_turn:
		return

	can_turn = false
	direction *= -1
	sprite.flip_h = direction > 0

	await get_tree().create_timer(TURN_COOLDOWN).timeout
	can_turn = true


func clear_target() -> void:
	target = null
	state = State.PATROL


func _on_detect(body: Node) -> void:
	if body.is_in_group("player") and body is BaseEntity:
		var entity := body as BaseEntity
		if entity.is_dead:
			return
		target = entity
		state = State.CHASE


func _on_lost(body: Node) -> void:
	if body == target and state != State.ATTACK:
		clear_target()
