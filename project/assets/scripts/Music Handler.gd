extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func update_buses(weapon_id):
    print(weapon_id)
    for i in $"../Player".attacks.size():
        AudioServer.set_bus_mute(AudioServer.get_bus_index("Beat"+str(i)), i!=weapon_id)

func set_playing(p):
    for child in get_children():
        child.playing = p
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
