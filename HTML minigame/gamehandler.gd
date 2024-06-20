extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var phase=0;
var timer=0;
var songplayed=false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func game_end_cleanup():
	$windup.hide();
	$slash.play();
	$text.hide();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept")&&phase==0:
		$windup.play()
		phase=1;
	if $windup.stream_position>0.1:
		$windup.show();
		$AnimatedSprite2D.animation="windup"
		$AnimatedSprite2D.show();
		if !songplayed:
			$song.play();
			songplayed=true;
	#print_debug($windup.stream_position);
	if phase==2 && Input.is_action_just_pressed("ui_accept"):
		game_end_cleanup()
		$earlylose.show();
		$earlylose.play();
		$earlysfx.play();
		$slash.play();
		$song.stop();
		phase=8
		$Timer.stop();
	if phase==3:
		timer+=delta;
		if Input.is_action_just_pressed("ui_accept"):
			game_end_cleanup()
			$win.show();
			$win.play();
			$winsfx.play();
			$slash.play();
			phase=10;
			$Label.text="";
		elif timer>0.5:
			game_end_cleanup()
			$latelose.show();
			$latelose.play();
			$latesfx.play();
			$slash.play();
			phase=9;
			$Label.text="";
	if phase==11&&Input.is_action_just_pressed("ui_accept"):
		phase=0;
		timer=0;
		$win.hide();
		$latelose.hide();
		$earlylose.hide();
		$AnimatedSprite2D.hide();
		$text.hide();	
		songplayed=false;
		
	if Input.is_action_just_pressed("ui_focus_next"):
		$text.hide();
	#bg handler shit
	if $win.stream_position>1:
		$AnimatedSprite2D.animation="victory"
	if $latelose.stream_position>1:
		$AnimatedSprite2D.animation="toolate"
	if $earlylose.stream_position>1:
		$AnimatedSprite2D.animation="tooearly"
	
#	pass


func _on_windup_finished():
	phase=2;
	$Timer.wait_time=((randi()%80)/10.0)+2
	$Timer.start();


func _on_Timer_timeout():
	$Label.text="Go!";
	$notif.play();
	$song.stop();
	$text.animation="go";
	$text.show();
	phase=3;


func _on_idle_finished():
	$idle.play();


func _on_earlylose_finished():
	phase=11;
	$text.animation="tooearly";
	$text.scrollIn();
	$text.show();


func _on_latelose_finished():
	phase=11;
	$text.animation="toolate";
	$text.scrollIn();
	$text.show();


func _on_win_finished():
	phase=11;
	$text.animation="victory";
	$text.scrollIn();
	$text.show();
