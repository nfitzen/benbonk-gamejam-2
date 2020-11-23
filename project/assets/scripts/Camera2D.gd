extends Camera2D

const updateRate = 0.2
const shakeDecay = 0.8
const shakeThreshhold = 0.02
var shakeMag = 0


func _process(delta):
    if(shakeMag<=shakeThreshhold): shakeMag = 0
    if(shakeMag>0):
        offset = Vector2((randf()*2-1)*shakeMag,(randf()*2-1)*shakeMag)
        shakeMag *= shakeDecay
    position += ($"../Player".position-position)*updateRate
