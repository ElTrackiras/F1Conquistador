extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var player_hitbox : CollisionShape2D = $AttackArea/Hitbox_shape
@export var DAMAGE : int = 20
@export var HEALTH : int = 100

var movement_state : String = "Idling"
var attack_delay : int = 0
var last_pos : String = "right_pos"
var attack_combo : int = 1

func _physics_process(delta):
	if $Running.playing == false:
		$Running.play()
	$Running.volume_db = -100
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if is_on_floor() && attack_delay <= 0:
		movement_state = "Idling"
		
	
	if Input.is_action_just_pressed("f1jumppress") or  $"../CanvasLayer/JumpButton".is_pressed(): 
		if is_on_floor() and attack_delay <= 0:
			$Jump.play()
			velocity.y = JUMP_VELOCITY
			movement_state = "Jumping"
		
	elif Input.is_action_just_pressed("f1attackpress") or bool($"../CanvasLayer/AttackButton".is_pressed() and attack_delay <= 0):
		$"../CanvasLayer/AttackButton".scale.x = 5
		if attack_delay <= 0:
			$AttackMiss.play()
			player_hitbox.disabled = false
			movement_state = "Attack"
			attack_delay = 80
			anim.play("attack2")
			attack_combo += 1
			if attack_combo > 2:
				attack_combo = 1
			if attack_combo == 1:
				anim.play("attack2")
			elif attack_combo == 2:
				anim.play("attack3")

	else:
		player_hitbox.disabled = true
	
	
	attack_delay -= 3.1
	if movement_state == "Jumping":
		anim.play("jumping")
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction && invul <= 0:
		if is_on_floor():
			$Running.volume_db = 20
		#Only change x axis when jump attacking not attacking on floor
		if attack_delay >= 0 && is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			velocity.x = direction * SPEED
			
		if attack_delay <= 0:
			if direction < 0:
				anim.flip_h = true
				last_pos = "left_pos"
				player_hitbox.position.x = -30.375
			elif direction > 0:
				anim.flip_h = false
				last_pos = "right_pos"
				player_hitbox.position.x = 30.375
			if movement_state != "Jumping":
				anim.play("running")
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if movement_state == "Idling":
			if invul <= 0:
				anim.play("idle")
	

	move_and_slide()
	get_hit()
	check_health()
	button_pressed_sign()
	
var invul : int = 0
func get_hit():
	invul -= 1
	var enemy_hitting =  $DamageArea.get_overlapping_areas()
	if invul <= 0:
		for i in enemy_hitting:
			if i.name == "HitBox":
				$GotHit.play()
				HEALTH -= i.get_parent().DAMAGE
				invul = 30
				print(HEALTH)
				$"../Camera2D".shake(3, "PLAYER_DAMAGED")
				anim.play("takedamage")
			
		
func check_health():
	if HEALTH <= 0:
		get_tree().change_scene_to_file("res://game_over.tscn")

	
func button_pressed_sign():
	if $"../CanvasLayer/AttackButton".is_pressed():
		$"../CanvasLayer/AttackButton".scale.x = 2.5
		$"../CanvasLayer/AttackButton".scale.y = 2.5
	else:
		$"../CanvasLayer/AttackButton".scale.x = 1.905
		$"../CanvasLayer/AttackButton".scale.y = 1.905
		
	if $"../CanvasLayer/JumpButton".is_pressed():
		$"../CanvasLayer/JumpButton".scale.x = 2.5
		$"../CanvasLayer/JumpButton".scale.y = 2.5
	else:
		$"../CanvasLayer/JumpButton".scale.x = 2.17
		$"../CanvasLayer/JumpButton".scale.y = 2.17
		
	if $"../CanvasLayer/MoveRightButton".is_pressed():
		$"../CanvasLayer/MoveRightButton".scale.x = 2.5
		$"../CanvasLayer/MoveRightButton".scale.y = 2.5
	else:
		$"../CanvasLayer/MoveRightButton".scale.x = 2.17
		$"../CanvasLayer/MoveRightButton".scale.y = 2.17
		
	if $"../CanvasLayer/MoveLeftButton".is_pressed():
		$"../CanvasLayer/MoveLeftButton".scale.x = 2.5
		$"../CanvasLayer/MoveLeftButton".scale.y = 2.5
	else:
		$"../CanvasLayer/MoveLeftButton".scale.x = 2.17
		$"../CanvasLayer/MoveLeftButton".scale.y = 2.17

