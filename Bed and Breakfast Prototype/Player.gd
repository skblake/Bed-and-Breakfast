extends KinematicBody2D

# Declare member variables here. 
var isMousePressed = false;
var mouseSteerOrigin = Vector2 (0, 0);
var mouseSteerDirection = Vector2 (0, 0); # normalized vector representing desired player movement direction
var mouseOldDirection = Vector2 (0, 0);

var walkStartDelay = 0.01;
var walkDelayTimer = 0.0;
var targetSpeed = 72;
var speed = 0.0;
var moveAccelSecs = 4.0;
var moveAccelTimer = 0.0;

var walking = false;
var topSpeed = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 
func _process(delta):
	if isMousePressed:
		if !walking:
			walkDelayTimer += delta;
			if walkDelayTimer > walkStartDelay:
				walkDelayTimer = 0.0;
				moveAccelTimer = 0.0;
				walking = true;
				topSpeed = false;
		else:
			if !topSpeed:
				moveAccelTimer += delta;
				if moveAccelTimer > moveAccelSecs:
					moveAccelTimer = moveAccelSecs;
					topSpeed = true;
			speed = targetSpeed * (1 - sqrt(1 - pow (moveAccelTimer / moveAccelSecs, 2)));
			speed /= 1 + (mouseOldDirection - mouseSteerDirection).length();
			if speed > 0:
				move_and_collide( mouseSteerDirection * speed * delta );
	else:
		walking = false;

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if !isMousePressed:
				mouseSteerOrigin = event.global_position;
				isMousePressed = true;
		else:
			isMousePressed = false;
			moveAccelTimer = 0.0;
	elif event is InputEventMouseMotion && isMousePressed:
		mouseOldDirection = mouseSteerDirection;
		mouseSteerDirection = ( event.global_position - mouseSteerOrigin ).normalized();
		
