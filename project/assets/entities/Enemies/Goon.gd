extends KinematicBody2D

export var speed = 12
var engage_range = 20
var attacking = false
var attack_timer
export var attack_speed = .8

# tim
func _ready():
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var target = $"../Player".position
    if not attacking:
        if (target - position).length() > engage_range:
            move_and_slide(Vector2(-speed, 0).rotated(position.angle_to_point(target)))
        else:
            attacking = true
            attack_timer = 0
    else:
        attack_timer += delta
        if attack_timer >= attack_speed:
            rotate(2)
            attacking = false
