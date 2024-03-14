extends CharacterBody2D


enum player_state{
	MOVE,
	SWORD,
	JUMP,
	DEAD
}




@onready var collision_shape_2d: CollisionShape2D = $"武器Area2D/CollisionShape2D"
@onready var 主collision_shape_2d: CollisionShape2D = $"主CollisionShape2D"




@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_tree_state = animation_tree.get("parameters/playback")

var speed := 200
var jump_speed := 2
var current_state = player_state.MOVE
var direction = Vector2.ZERO
#var target = position


func _ready() -> void:
	collision_shape_2d.disabled = true
	animation_tree.active = true
	
func _physics_process(_delta: float) -> void:
	match current_state:
			player_state.MOVE:
				move()
			player_state.SWORD:
				sword()
			player_state.JUMP:
				jump()
func move():
	direction = Input.get_vector("ui_left" , "ui_right" ,"ui_up" ,"ui_down")
	velocity = direction * speed
	主collision_shape_2d.disabled = false
	if direction:
		animation_tree.set("parameters/idle/blend_position" , direction)
		animation_tree.set("parameters/jump/blend_position" , direction)
		animation_tree.set("parameters/sword/blend_position" , direction)
		animation_tree.set("parameters/walk/blend_position" , direction)
		animation_tree_state.travel("walk")
	else:
		animation_tree_state.travel("idle") 
	if Input.is_action_just_pressed("sword"):
		current_state = player_state.SWORD
	if Input.is_action_just_pressed("jump"):
		current_state = player_state.JUMP
		
	move_and_slide()
func sword():
	animation_tree_state.travel("sword")
	#target = get_global_mouse_position()
	
	#direction = (target - self.position).normalized()
	#animation_tree.set("parameters/sword/blend_position" , direction)
	
func on_state_reset():
	current_state = player_state.MOVE
func jump():
	主collision_shape_2d.disabled = true
	animation_tree_state.travel("jump")
	#position += direction * jump_speed
	#velocity = direction * speed
	move_and_slide()

