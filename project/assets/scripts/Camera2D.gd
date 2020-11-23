extends Camera2D

const updateRate = 0.2
const shakeDecay = 0.7
const shakeThreshhold = 0.02
var shakeMag = 0
var camOff : Vector2 = Vector2(0,0)


func _process(delta):
    if(shakeMag<=shakeThreshhold): shakeMag = 0
    if(shakeMag>0):
        offset = Vector2((randf()*2-1)*shakeMag,(randf()*2-1)*shakeMag)
        shakeMag *= shakeDecay
    camOff = ($"../Player".get_global_position()-get_global_position())*updateRate
    $"../HUD".global_position = get_global_position()
    position += camOff
