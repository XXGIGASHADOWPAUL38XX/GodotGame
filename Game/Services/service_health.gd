extends Node

const decalage = 35

func setBar(heros, healthBar: ProgressBar):
	healthBar.global_position = Vector2(
		heros.global_position.x - healthBar.size.x / 2, 
		heros.global_position.y - decalage
	)
	

