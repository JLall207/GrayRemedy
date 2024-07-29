extends CharacterBody2D

# Scene-Tree Node references
@onready var animated_sprite = $AnimatedSprite2D
@onready var interact_ui = $InteractUI
@onready var inventory_ui = $InventoryUI

# variables
var speed = 200

func _ready():
	# Set this node as the Player node
	Global.set_player_reference(self)

# Input for movement
func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	
func _physics_process(delta):
	get_input()
	move_and_slide()
	update_animations()
	
func update_animations():
	if velocity == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				animated_sprite.play("walk-right")
			else:
				animated_sprite.play("walk-left")
		else:
			if velocity.y > 0:
				animated_sprite.play("walk-down")
			else:
				animated_sprite.play("walk-up")
			

func _input(event):
	if event.is_action_pressed("ui_inventory"):
		inventory_ui.visible = !inventory_ui.visible
		get_tree().paused = !get_tree().paused
		

func apply_item_effect(item):
	match item["effect"]:
		"Stamina":
			speed += 50
			print("Speed increased to ", speed)
		"Slot Boost":
			Global.increase_inventory_size(5)
			print("Slots increased to ", Global.inventory.size())
		_:
			print("There is no effect for this item")
