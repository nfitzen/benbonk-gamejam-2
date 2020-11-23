extends KinematicBody2D

signal attack(damage)

export var speed = 12
export var max_health = 100
var health = max_health
export var engage_range = 20
export var attack_range = 25
var attacking = false
var attack_timer
export var attack_speed = .8

# tim
func _ready():
    $"../Player".connect("player_attack", self, "_on_Player_player_attack")
    self.connect("attack", $"../Player", "_on_enemy_attack")
    
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
            if (target - position).length() < attack_range:
                emit_signal("attack", 1)
                rotate(2)
            attacking = false

func _on_Player_player_attack(damage):
    health -= damage
    if health <= 0:
        queue_free()
