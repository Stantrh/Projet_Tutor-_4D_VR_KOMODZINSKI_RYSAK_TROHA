extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		GameManager.play_sound_fx(load("res://assets/Sounds/FreeSFX/GameSFX/PickUp/Retro PickUp Coin 07.wav"))
		GameManager.coins += 1 
		GameManager.score += 100
		queue_free()
