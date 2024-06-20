extends Node2D


# Declare member variables here. Examples:
var timer=0; #time in seconds
var phase=-1; #phase of the game
var winner=false; #false = lose
var begin=false; #so that you dont immediately get thrust into it
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept")&&phase==-1:
		begin=true;
		phase=0;
	if (phase==1): $"go".show(); else: $"go".hide();
	if (phase==2):
		var explosion = preload("res://explosion.tscn").instantiate();
		explosion.frame=0;
		explosion.position.x=270;
		if (winner): explosion.position.x+=100;
		add_child(explosion)
		if (winner): $"1x4".animation="victory"; $"1x4".scale=Vector2(0.5,0.5)
	if begin:
		timer+=delta;
	$ProgressBar.value=timer;
	$Label.text=str(timer).pad_decimals(2)
	if (timer>=3&&phase==0):
		timer=0;
		phase=1;
	if Input.is_action_just_pressed("ui_accept")&&phase==1:
		winner=true;
		timer=0;
		phase=2;
	if (timer>=0.5&&phase==1):
		timer=0;
		phase=2;
