extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 200
const JUMP_HEIGHT = -450
const ARROW = preload("res://Arrow.tscn")

var motion = Vector2()
var friction = false
var is_attacking = false

func _physics_process(delta):
	motion.y += GRAVITY
	movement()
	attack()
	jumping_attack()
	
func movement():
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		if is_attacking == false:
			$Sprite.flip_h = false
			$Sprite.play("Walk")
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x = 4.5
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		if is_attacking == false:
			$Sprite.flip_h = true
			$Sprite.play("Walk")
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x = -55
	else:
		$Sprite.play("Idle")
		friction = true
		
	if is_on_floor():
		if Input.is_action_pressed("ui_select"):
			motion.y = JUMP_HEIGHT
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2)	
	else:
		if motion.y < 0:
			$Sprite.play("Jump")
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
		$Sprite.play("Jump")
	motion = move_and_slide(motion, UP)
	pass
	
func attack():
	if Input.is_action_just_released("fire") && is_attacking == false:
		is_attacking = true
		var arrow = ARROW.instance()
		if sign($Position2D.position.x) == -1:
			arrow.ustaw_kierunek_strzaly(-1)
		get_parent().add_child(arrow)
		arrow.position = $Position2D.global_position	
		
func jumping_attack():
	$Raycasting/RayCast2D.force_raycast_update()
	if $Raycasting/RayCast2D.is_colliding():
		var collider = $Raycasting/RayCast2D.get_collider()
		if collider.is_in_group("enemy"):
			collider.dead()
			motion.y = JUMP_HEIGHT * 0.75
	
func _on_Sprite_animation_finished():
	is_attacking = false
	
