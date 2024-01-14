extends CharacterBody2D


@export var SPEED : int = 30.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var attackingBox : CollisionShape2D = $HitBox/HitBoxShape
var rng = RandomNumberGenerator.new()
var change_direct : int = 100
var boar_direct : int = 0
var damage_taken : bool = false
var invul_count : int = 30
var choice : int = 1 #1 is walk 2 is attack for boar
@export var HEALTH : int = 100
@export var DAMAGE : int = 10

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if damage_taken == false:
		if change_direct <= 0:
			boar_direct = rng.randi_range(-1, 1)
			choice = rng.randi_range(1, 2)
			change_direct = 100
		velocity.x = boar_direct * SPEED
		change_direct -= 1

		if boar_direct == 0:
			anim.play("idle")
			
		elif boar_direct == 1:
			if choice == 2:
				anim.play("runAttack")
			else:
				anim.play("walk")
			anim.flip_h = true
			
		elif boar_direct == -1:
			if choice == 2:
				anim.play("runAttack")
			else:
				anim.play("walk")
			anim.flip_h = false
	
	else:
		invul_count -= 1
		if invul_count <= 0:
			damage_taken = false
			invul_count = 30
	
	
	#velocity.x = move_toward(velocity.x, 0, SPEED)
	check_health()
	is_attacking(choice)
	move_and_slide()
	get_hit()
	enemy_hit()

func is_attacking(x):
	if boar_direct != 0:
		if x == 2:
			attackingBox.disabled = false
			SPEED = 200
		else:
			attackingBox.disabled = true
			SPEED = 30

func get_hit():
	var weapon_hitting =  $DamageBox.get_overlapping_areas()
	for i in weapon_hitting:
		if i.name == "AttackArea":
			$GetHitSlash.play()
			$GetHitSqueal.play()
			$"../Camera2D".shake(1, "PLAYER_ATTACKING")
			var damage = i.get_parent().DAMAGE
			HEALTH -= damage
			anim.play("takeDamage")
			damage_taken = true
			boar_direct = 0
			change_direct = 100
			check_health()

func check_health():
	if HEALTH <= 0:
		$".".queue_free()
		

func enemy_hit():
	var enemyHit = $HitBox.get_overlapping_areas()
	for i in enemyHit:
		if i.get_parent().name == "F1Player":
			if i.get_parent().position.x > position.x:
				boar_direct = -1
				change_direct = 100
			elif i.get_parent().position.x < position.x:
				boar_direct = 1
				change_direct = 100
			
			
