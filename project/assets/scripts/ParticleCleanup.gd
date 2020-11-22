extends Node2D

var time = 0.0

func _process(delta):
    time+=delta
    if(time>$"Particles".get_lifetime()*2):
        queue_free()
