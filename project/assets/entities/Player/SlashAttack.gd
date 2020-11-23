extends Area2D

func _process(delta):
    rotation = get_global_mouse_position().angle_to_point(get_global_position())

func attack():
    var bs = get_overlapping_bodies()
    $"..".emit_signal("player_attack", bs, 40, Vector2(20, 0).rotated(rotation))
