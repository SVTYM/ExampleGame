@tool
extends Node2D
class_name CameraBounds

@export var bounds_size: Vector2 = Vector2(1024, 768):
	set(value):
		bounds_size = value
		_apply_size()

@onready var collision: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	_apply_size()


func _apply_size() -> void:
	if not collision:
		return
	if not collision.shape:
		return
	if collision.shape is RectangleShape2D:
		(collision.shape as RectangleShape2D).size = bounds_size
