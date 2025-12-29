extends Node2D

@onready var bounds: CollisionShape2D = $CameraBounds/CollisionShape2D
@onready var music: AudioStreamPlayer = $BackgroundMusic
@onready var hud: CanvasLayer = $HUD

var cam: Camera2D
var player: BaseEntity


func _ready() -> void:
	# ─────────────────────────
	# 🎵 MÚSICA DE FONDO
	# ─────────────────────────
	if not music.playing:
		music.stream = preload("res://music/bg_lvl_01.ogg")
		music.volume_db = -8
		music.play(2)

	# ─────────────────────────
	# 📷 CÁMARA
	# ─────────────────────────
	var cams := get_tree().get_nodes_in_group("main_camera")
	if cams.is_empty():
		push_warning("⚠️ No main camera found")
		return

	cam = cams[0] as Camera2D
	if cam == null:
		push_warning("⚠️ Node in group main_camera is not Camera2D")
		return

	apply_camera_limits()

	# ─────────────────────────
	# ❤️ HUD + PLAYER
	# ─────────────────────────
	find_and_bind_player()


func find_and_bind_player() -> void:
	var players := get_tree().get_nodes_in_group("player")
	if players.is_empty():
		push_warning("⚠️ No player found in group 'player'")
		return

	player = players[0] as BaseEntity
	if player == null:
		push_warning("⚠️ Node in group 'player' is not BaseEntity")
		return

	# 🔗 Enlace limpio
	if hud.has_method("bind_player"):
		hud.bind_player(player)
	else:
		push_warning("⚠️ HUD has no method bind_player()")


# ─────────────────────────
# 📷 CAMERA LIMITS
# ─────────────────────────
func apply_camera_limits() -> void:
	var shape := bounds.shape as RectangleShape2D
	if shape == null:
		push_error("❌ CameraBounds no tiene RectangleShape2D")
		return

	var size := shape.size
	var pos: Vector2 = bounds.global_position - (size * 0.5)
	set_camera_limits_from_rect(Rect2(pos, size))


func set_camera_limits_from_rect(rect: Rect2) -> void:
	cam.limit_left   = int(rect.position.x)
	cam.limit_top    = int(rect.position.y)
	cam.limit_right  = int(rect.position.x + rect.size.x)
	cam.limit_bottom = int(rect.position.y + rect.size.y)
