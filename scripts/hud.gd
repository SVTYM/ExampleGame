extends CanvasLayer


@onready var health_bar: HealthBar = $HealthBar

func bind_player(player: BaseEntity) -> void:
	health_bar.bind(player)

func _ready() -> void:
	pass
