extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# on met le nombre de coins à 0, pour l'initialisation et le reset
	Global.coins = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
