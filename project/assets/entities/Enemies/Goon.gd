# SPDX-FileCopyrightText: 2020 Henry Schneider, Kai Hoop, Nathaniel Fitzenrider, and Austin Chang
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends KinematicBody2D

signal attack(damage)

export (Material) var white_shader
export var speed = 12
# Health generated is between
export var max_health_range = Vector2(4, 6)
var maxHealth : int
var health : int
export var engage_range = 20
export var attack_range = 25
var attacking = false
var attack_timer
export var attack_speed = .8
var kb = Vector2.ZERO
export var kb_speed = 85
var deltaPos : Vector2 = Vector2(0,0)

# tim
func _ready():
    VisualServer.canvas_item_set_parent(get_canvas_item(), $"../".get_canvas_item())
    self.connect("attack", $"../Player", "_on_enemy_attack")
    #$"../Player".connect("player_attack", self, "_on_Player_player_attack")
    maxHealth = randi() % (int(max_health_range[1])-int(max_health_range[0])+1) + int(max_health_range[0])
    health = maxHealth


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    print($"Sprite".frame)
    VisualServer.canvas_item_set_z_index(get_canvas_item(), position.y)
    var target = $"../Player".position

    #Hit stun effect
    if($"Sprite".animation.substr(0,3) == "hit" && $"Sprite".frame == 0):
        pass
        #$"Sprite".animation = "hit"+str(fposmod(round(rad2deg(-deltaPos.angle())/-45+135),8))
    else:
        $"Sprite".material = null
        #print($"Sprite".animation.substr(0,6))
        if(attacking || ($"Sprite".animation.substr(0,6) == "attack" && $"Sprite".frame >= 1 && $"Sprite".frame <= 2)):
            $"Sprite".animation = "attack"+str(fposmod(round(rad2deg(-deltaPos.angle())/-45+135),8))
        else:
            $"Sprite".animation = "walk"+str(fposmod(round(rad2deg(-deltaPos.angle())/-45+135),8))
    if kb.length_squared() > 0:
        var step_kb = Vector2(min(kb.normalized().x * kb_speed, kb.x),
                              min(kb.normalized().y * kb_speed, kb.y))
        kb -= step_kb
        deltaPos = step_kb
        move_and_slide(step_kb)
    elif not attacking:
        if (target - position).length() > engage_range:
            deltaPos = Vector2(-speed, 0).rotated(position.angle_to_point(target))
            move_and_slide(deltaPos)
            
        else:
            attacking = true
            attack_timer = 0
            if($"Sprite".frame==3): 
                $"Sprite".frame = 1
    else:
        if($"Sprite".frame==3): 
            if($"Sprite".animation.substr(0,6)=="attack"): 
                $"Sprite".frame = 1
            else:
                $"Sprite".frame = 0
        if (target - position).length() > engage_range*2:
            attacking = false
            
        attack_timer += delta
        if attack_timer >= attack_speed:
            #rotate(2)
            if (target - position).length() < attack_range:
                emit_signal("attack", 1)
                #rotate(2)
                pass
            attacking = false

func _on_Player_player_attack(bodies, damage, knockback):
    if self in bodies:
        take_hit(damage, knockback)

func take_hit(damage, knockback):
    $"../Pause Manager".pause(0.1)
    $"Sprite".frame = 0
    $"Sprite".material = white_shader
    $"Sprite".animation = "hit"+str(fposmod(round(rad2deg(-deltaPos.angle())/-45+90+(randi()%2*45)),8))
    health -= damage
    #print(knockback)
    if knockback:
        attacking = false
        kb = knockback
    if health <= 0:
        queue_free()
