extends AnimatedSprite2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func scrollIn(): 
	position.y=-100;
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position.lerp(Vector2(520,100),delta*4)
	pass
