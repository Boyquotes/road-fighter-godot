extends Node

export(NodePath) onready var player = get_node(player) as Player
export(NodePath) onready var ui = get_node(ui) as Control
export(NodePath) onready var border = get_node(border) as Area2D
export(NodePath) onready var bg = get_node(bg) as Sprite

var screen_height : float

func _ready() -> void:
	screen_height = get_tree().root.size.y
	border.set_meta("type", "border")
	player.connect("update_velocity", ui, "_on_update_velocity")
	player.connect("update_velocity_level", ui, "_on_update_velocity_level")

func _process(_delta: float) -> void:
	if bg.global_position.y >= screen_height:
		bg.global_position.y = 0
		border.global_position.y -= screen_height
