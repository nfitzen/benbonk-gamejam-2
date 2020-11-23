extends KinematicBody2D

signal attack(damage)

export (Material) var white_shader
export var speed = 12
export var max_health = 100
var health = max_health
export var engage_range = 20
export var attack_range = 25
var attacking = false
var attack_timer
export var attack_speed = .8
var kb = Vector2.ZERO
export var kb_speed = 85

# tim
func _ready():
    VisualServer.canvas_item_set_parent(get_canvas_item(), $"../".get_canvas_item())
    self.connect("attack", $"../Player", "_on_enemy_attack")
    #$"../Player".connect("player_attack", self, "_on_Player_player_attack")
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    VisualServer.canvas_item_set_z_index(get_canvas_item(), position.y)
    var target = $"../Player".position
    
    #Hit stun effect
    if($"Sprite".animation.substr(1,3) == "hit" && $"Sprite".frame == 0):
        #$"Sprite".material = white_shader
        pass
    else:
        $"Sprite".material = null
    if kb.length_squared() > 0:
        var step_kb = Vector2(min(kb.normalized().x * kb_speed, kb.x),
                              min(kb.normalized().y * kb_speed, kb.y))
        kb -= step_kb
        move_and_slide(step_kb)
    elif not attacking:
        if (target - position).length() > engage_range:
            move_and_slide(Vector2(-speed, 0).rotated(position.angle_to_point(target)))
        else:
            attacking = true
            attack_timer = 0
    else:
        attack_timer += delta
        if attack_timer >= attack_speed:
            #rotate(2)
            if (target - position).length() < attack_range:
                emit_signal("attack", 1)
                #rotate(2)
            attacking = false

func _on_Player_player_attack(bodies, damage, knockback):
    if self in bodies:
        take_hit(damage, knockback)

func take_hit(damage, knockback):
    $"../Pause Manager".pause(0.1)
    $"Sprite".frame = 0
    $"Sprite".material = white_shader
    $"Sprite".animation = "hit0"
    health -= damage
    print(knockback)
    if knockback:
        attacking = false
        kb = knockback
    if health <= 0:
        queue_free()
