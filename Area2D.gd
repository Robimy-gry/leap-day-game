extends Area2D

const SPEED = 400
var predkosc =  Vector2()
var kierunek = 1

func ustaw_kierunek_strzaly(dir):
	kierunek = dir
	if dir == -1:
		$Sprite.flip_h = true 

func _physics_process(delta):
	predkosc.x = SPEED * delta * kierunek
	translate(predkosc)
	
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Arrow_body_entered(body):
	if "Enemy" in body.name:
		body.hurt()
	queue_free()
