extends KinematicBody2D

export var speed = 15
var engage_range = 20

# tim
func _ready():
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var target = $"../Player".position
    if (target - position).length() > engage_range:
        move_and_slide(Vector2(-speed, 0).rotated(position.angle_to_point(target)))
    else:
        rotate(2)
