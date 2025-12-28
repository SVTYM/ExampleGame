extends Area2D

var triggered := false

func _ready() -> void:
	monitoring = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if triggered:
		return

	print("☠️ FALL ZONE:", body.name)

	# Player → reiniciar nivel
	if body.is_in_group("player"):
		triggered = true
		monitoring = false
		call_deferred("_restart_level")
		return

	# Enemigos → destruir
	if body is BaseEntity:
		body.queue_free()

func _restart_level() -> void:
	print("🔄 Restarting level")

	# Esperar a salir del frame actual
	await get_tree().process_frame

	var scene := get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(scene)
