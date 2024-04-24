extends Area2D
signal hit
#export keyword on the first variable speed allows us to set its value in the Inspector
@export var speed = 400 #how fast the player will move (pixels/sec)
var screen_size # size of the game window

# Called when the node enters the scene tree for the first time. A good time to find the size of the game window
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# function that defines what the player will do
# Player needs to be able to do the following:
	# Check for input: is the player pressing a key?
		# 4 directional inputs to check
	# Mave in given direction
	# Play the appropriate animation
func _process(delta):
	# detect whether a key is pressed using Input.is_action_pressed() - T/F
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	# use clamp to prevent the player's position from leaving the screen. clamping restricts the position within a given range
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# the following is to adjust the animation to filp horizontally for left movement, flip vertically for downward movement
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	
func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
