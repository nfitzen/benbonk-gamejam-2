extends Area2D

func _process(delta):
    rotation = get_global_mouse_position().angle_to_point(get_global_position())

func attack():
    pass
