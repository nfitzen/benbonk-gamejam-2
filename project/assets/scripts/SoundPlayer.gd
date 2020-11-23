extends AudioStreamPlayer

func _process(_delta):
    if(!playing):
        queue_free()
