extends KinematicBody2D

const GRAVITY = 10
const SPEED = 30
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var direction = 1
var is_hurt = false
var is_dead = false

func _ready():
	add_to_group("enemy")
	
func hurt():
	is_hurt = true
	velocity = Vector2(0, 0)
	$AnimatedSprite.play("hurt")
	$Timer2.start()

func dead():
	if is_hurt == true:
		is_dead = true
		velocity = Vector2(0, 0)
		$AnimatedSprite.play("dead")
		$CollisionShape2D.call_deferred("set_disabled", true)
		$Timer.start()

func _physics_process(delta):
	if is_dead == false and is_hurt == false:
		movement()
	
			
func movement():
	velocity.x = SPEED * direction
	
	if direction == 1:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	$AnimatedSprite.play("walk")
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)

	
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1

func _on_Timer_timeout():
	queue_free()


func _on_Timer2_timeout():
	is_hurt = false
