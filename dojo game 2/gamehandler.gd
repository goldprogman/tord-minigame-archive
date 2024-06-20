extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var phase=0;
var timer=0;
var songplayed=false;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func end_game_cleanup():	
	$text.hide();
	$waitingidle.hide();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept")&&phase==0:
		$windup.play()
		phase=1;
	if $windup.stream_position>0.1:
		$windup.show();
		$AnimatedSprite2D.show();
		$AnimatedSprite2D.animation="windup"
		if !songplayed:
			$song.play();
			songplayed=true;
	if $waitingidle.stream_position>0&&phase==2:
		$waitingidle.show();
		$windup.hide();
	if phase==2 && Input.is_action_just_pressed("ui_accept"):
		end_game_cleanup();
		$earlylose.show();
		$earlylose.play();
		$slash.play();
		$earlysfx.play();
		$song.stop();
		phase=8
		$Timer.stop();
	if phase==3:
		timer+=delta;
		if Input.is_action_just_pressed("ui_accept"):
			end_game_cleanup();
			$win.show();
			$win.play();
			$slash.play();
			$winsfx.play();
			phase=10;
		elif timer>0.5:
			end_game_cleanup();
			$latelose.show();
			$latelose.play();
			$slash.play();
			$latesfx.play();
			phase=9;
	if Input.is_action_just_pressed("ui_focus_next"):
		$text.hide();
	if phase==11&&Input.is_action_just_pressed("ui_accept"):
		phase=0;
		timer=0;
		$win.hide();
		$latelose.hide();
		$earlylose.hide();
		$waitingidle.hide();
		$AnimatedSprite2D.hide();
		$text.hide();
		songplayed=false;
	#antiflicker handlers
	if $win.stream_position>1:
		$AnimatedSprite2D.animation="victory"
	if $earlylose.stream_position>1:
		$AnimatedSprite2D.animation="tooearly"
	if $latelose.stream_position>1:
		$AnimatedSprite2D.animation="toolate"
#	pass


func _on_windup_finished():
	phase=2;
	$Timer.wait_time=((randi()%80)/10.0)+2
	$Timer.start();
	$waitingidle.play();


func _on_Timer_timeout():
	$notif.play();
	$song.stop();
	$text.animation="go"
	$text.show();
	phase=3;


func _on_idle_finished():
	$idle.play();


func _on_earlylose_finished():
	phase=11;
	$text.animation="tooearly"
	$text.scrollIn();
	$text.show();


func _on_latelose_finished():
	phase=11;
	$text.animation="toolate"
	$text.scrollIn();
	$text.show();


func _on_win_finished():
	phase=11;
	$text.animation="victory"
	$text.scrollIn();
	$text.show();

func _on_waitingidle_finished():
	$waitingidle.play();
