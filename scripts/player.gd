extends CharacterBody2D

@export var max_speed : int = 200
@export var gravity : float = 20
@export var jump_force : int = 350
@export var acceleration : int = 25
@export var jump_buffer_time : int = 15
@export var cayote_time : int = 10

@onready var anim := $AnimatedSprite2D
@onready var animTree : AnimationTree = $AnimationTree

const pushForce = 50
const maxPushVelocity = 80
var canPick:bool = true

var jump_counter : int = 0
var jump_buffer_counter : int = 0
var cayote_counter : int = 0
var max_fall_speed = 500

@onready var raycast := $RayCast2D
@onready var grab_ledge := $Grab_Ledge

func _ready() -> void:
	animTree.active = true

func _physics_process(_delta):
	if is_on_floor():
		if not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right") and not Input.is_action_pressed("jump") and not Input.is_action_pressed("crouch"):
			anim.play("idle")
		cayote_counter = cayote_time
	
	# Add the gravity.
	if not is_on_floor():
		anim.play("fall")
		if cayote_counter > 0:
			cayote_counter -= 1
	
		velocity.y += gravity
		if raycast .is_colliding() and not grab_ledge .is_colliding():
			if raycast .get_collider().name == "Layer1":
				anim.play("wall_slide")
				max_fall_speed = 50
		elif grab_ledge .is_colliding():
			if raycast .get_collider().name == "Layer2":
				anim.play("grab_ledge")
				cayote_counter = 1
				max_fall_speed = 0
		else:
			max_fall_speed = 500
		
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = jump_buffer_time
		anim.play("jump")
		
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
		
	if jump_buffer_counter > 0 and cayote_counter > 0:
		velocity.y = -jump_force
		jump_buffer_counter = 0
		cayote_counter = 0
			
	if Input.is_action_just_released("jump"):
		if velocity.y < 0:
			velocity.y += 100

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input. is_action_pressed("move_right") and not Input. is_action_pressed("move_left"):
		velocity.x += acceleration
		$AnimatedSprite2D.flip_h = false
		raycast.position.x = 9
		raycast.target_position.x = 2
		grab_ledge.position.x = 11
		grab_ledge.target_position.y = 3
		anim.play("run")
		
	elif Input. is_action_pressed("move_left") and not Input. is_action_pressed("move_right"):
		velocity.x -= acceleration
		$AnimatedSprite2D.flip_h = true
		raycast.position.x = -5
		raycast.target_position.x = -2
		grab_ledge.position.x = -7
		grab_ledge.target_position.y = 3
		anim.play("run")
	else:
		velocity.x = lerpf(velocity.x, 0, 0.2)
		
	if Input. is_action_pressed("crouch"):
		velocity.x = lerpf(velocity.x, 0, 0.2)
		#$CollisionShape2D.scale = Vector2(1,0.5)
		#$CollisionShape2D.position.y = -7
		anim.play("crouch")
	
	if Input. is_action_just_pressed("interact"):
		if $PointLight2D.enabled == false:
			$PointLight2D.enabled = true
		
		else:
			$PointLight2D.enabled = false
		
	
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_box = collision.get_collider()
		
		if collision_box.is_in_group("box") and abs(collision_box.get_linear_velocity().x) < maxPushVelocity:
			collision_box.apply_central_impulse(collision.get_normal() * - pushForce)
	
	move_and_slide()
