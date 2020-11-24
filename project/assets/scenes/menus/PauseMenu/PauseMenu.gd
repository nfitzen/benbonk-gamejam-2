extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _input(event):
    if event is InputEventKey and event.pressed:
        if event.scancode == KEY_ESCAPE:
            var new_pause_state = not get_tree().paused
            get_tree().paused = not get_tree().paused
            visible = new_pause_state



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
