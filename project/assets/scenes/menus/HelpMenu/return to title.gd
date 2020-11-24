extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _on_Button_pressed():
    print ("pressed the button")
    get_tree().change_scene("res://assets/scenes/menus/TitleScreen/TitleScreen.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
