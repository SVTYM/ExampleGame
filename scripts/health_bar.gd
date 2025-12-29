extends Control
class_name HealthBar

@export var smooth_speed := 8.0

@onready var bar: TextureProgressBar = $TextureProgressBar

var target_value := 100
var max_value := 100


func bind(entity: BaseEntity) -> void:
	max_value = entity.MAX_LIFE
	bar.max_value = max_value
	bar.value = entity.life
	target_value = entity.life

	entity.life_changed.connect(_on_life_changed)
	entity.died.connect(_on_died)


func _on_life_changed(current: int, max_life: int) -> void:
	max_value = max_life
	bar.max_value = max_life
	target_value = current


func _on_died() -> void:
	if bar:
		bar.value = 0
		target_value = 0

	# ⛔ detener cualquier actualización futura
	set_process(false)

	hide()



func _process(delta: float) -> void:
	bar.value = lerp(
		float(bar.value),
		float(target_value),
		delta * smooth_speed
	)
