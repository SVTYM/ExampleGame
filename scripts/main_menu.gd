extends Control

@export var first_level_path: String = "res://levels/level_01.tscn"


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_play_pressed() -> void:
	print("▶ JUGAR")
	get_tree().change_scene_to_file(first_level_path)


func _on_options_pressed() -> void:
	print("⚙ OPCIONES (pendiente)")


func _on_exit_pressed() -> void:
	print("❌ SALIR")
	get_tree().quit()
