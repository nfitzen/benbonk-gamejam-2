extends Node2D

var time = 0.0

func _process(delta):
    time+=delta
    if(time>get_children()[0].get_lifetime()*2):
        queue_free()
