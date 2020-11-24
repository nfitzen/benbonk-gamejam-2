# SPDX-FileCopyrightText: 2020 Henry Schneider, Kai Hoop, Nathaniel Fitzenrider, and Austin Chang
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends KinematicBody2D

signal player_attack(damage)
export (Array, PackedScene) var attacks
export (PackedScene) var soundPlayer
export (Array, AudioStream) var hitSounds
signal death
signal health_update(health)

export (Material) var white_shader

var active_attack = 0
var maxNumAttack = 2
var attackNum = 0

export var speed = 75.0
var direction = 0.0
export var maxHealth = 4
var health = maxHealth

# Dashing
export var dashLength = 20.0
export var dashSpeed = 250.0
export var dashCooldownAir = 1
export var dashCooldownWall = 1
var dashing = false
var dashVector : Vector2
var dashVelocity : Vector2
var velocity : Vector2
var targetPos : Vector2
var pseudoPos : Vector2
var dashDelta = 0.0
var dashTime : float
var remainingDashLen : float
var dashTarget : Vector2
var dashCooldown = 0.0

# Weapons
var weapon = 0
var maxAmmos = [2,3,4]
var ammo = 4
var ammoUpdate = 0.0
var healthUpdate = 0.0
var maxCooldown = [0.3,0.6,0.2]
var cooldown = 0.0

func is_melee(id):
    return (id==0 || id==1)

func ready():
    VisualServer.canvas_item_set_parent(get_canvas_item(), $"../".get_canvas_item())
    health = maxHealth

    dashing = false
    dashCooldown = 0
    dashVector = Vector2.ZERO
    velocity = Vector2.ZERO
    direction = 0

    active_attack = 0
    attackNum = 0


func _process(delta):
    VisualServer.canvas_item_set_z_index(get_canvas_item(), position.y)
    #z_index = -position.y
    velocity = Vector2.ZERO
    if dashCooldown > 0:
        dashCooldown -= delta
    if dashing:
        # print(dashDelta)
        dashDelta += delta
        remainingDashLen -= dashSpeed * delta
        if dashDelta < dashTime:
            move_and_slide(dashVelocity)
        elif get_slide_count() == 0 and remainingDashLen < 0:
            # print(remainingDashLen)
            position = dashTarget
            dashCooldown = dashCooldownAir
            dashing = false
        elif remainingDashLen == 0:
            dashCooldown = dashCooldownAir
            dashing = false
        else:
            dashCooldown = dashCooldownWall
            dashing = false
    else:
        if Input.is_action_pressed("right"):
            velocity += Vector2.RIGHT
        if Input.is_action_pressed("left"):
            velocity += Vector2.LEFT
        if Input.is_action_pressed("down"):
            velocity += Vector2.DOWN
        if Input.is_action_pressed("up"):
            velocity += Vector2.UP
        if Input.is_action_just_pressed('dash'):
            if dashCooldown <= 0:
                dash()
        velocity = velocity.normalized() * speed
        if velocity.length() > 0:
            if($"Sprite".animation.substr(1,1)!="A"):
                direction = fposmod(round(rad2deg(-velocity.angle())/-45+135),8)
            move_and_slide(velocity)
    #     sprite.animation = "walk"+str(direction)
    # else:
    #     sprite.animation = "idle"+str(direction)
    if(is_melee(weapon)):
        if (velocity.length() > 0 and $"Sprite".animation.substr(0,2)!="MA"):
            $"Sprite".animation = "MW"+str(direction)
        elif($"Sprite".animation.substr(0,2)!="MA"):
            $"Sprite".animation = "MI"+str(direction)
        else:
            if($"Sprite".frame==1):
                $"Sprite".animation = "MI"+str(direction)
    else:
        if (velocity.length() > 0 and $"Sprite".animation.substr(0,2)!="RA"):
            $"Sprite".animation = "RW"+str(direction)
        elif($"Sprite".animation.substr(0,2)!="RA"):
            $"Sprite".animation = "RI"+str(direction)
        else:
            if($"Sprite".frame==1):
                $"Sprite".animation = "RI"+str(direction)

    if(ammoUpdate>0):
        ammoUpdate -= delta
        if(ammoUpdate<0): ammoUpdate = 0.0
    if(healthUpdate>0):
        $"Sprite".material = white_shader
        healthUpdate -= delta
        if(healthUpdate<0): 
            healthUpdate = 0.0
            $"Sprite".material = null
            
    if(cooldown>0):
        cooldown -= delta
        if(cooldown<0): cooldown = 0.0
    if(ammo==0):
        $"../Walls/WallRenderer".init_swap()
        $"../Pause Manager".pause(0.3)
        weapon += 1;
        if(weapon>=attacks.size()):
            weapon = 0
        ammo = maxAmmos[weapon]
        if(cooldown>maxCooldown[weapon]):
            cooldown = maxCooldown[weapon]
    #if(Input.is_action_just_pressed("ui_right")):
       # print(position.y)
    if(Input.is_action_just_pressed("attack") && cooldown==0):
        direction = fposmod(round(rad2deg((get_global_mouse_position() - get_global_position()).angle())/45+135),8)
        if(is_melee(weapon)):
            $"Sprite".animation = "MA"+str(direction)
        else:
            $"Sprite".animation = "RA"+str(direction)
        $"Sprite".frame = 0
        attackNum += 1;
        ammo -= 1;
        ammoUpdate = 0.2
        cooldown = maxCooldown[weapon]
        if(attackNum==maxNumAttack):
            attackNum = 0
        var i  = attacks[weapon].instance()
        i.position = position+(get_global_mouse_position() - get_global_position()).normalized()*8
        i.num = attackNum
        $"../".add_child(i)

func dash():
    dashing = true
    var dashDirection = (get_global_mouse_position() - get_global_position()).normalized()
    dashVelocity = dashDirection * dashSpeed
    dashTarget = position + dashDirection * dashLength
    dashTime = dashLength / dashSpeed
    dashDelta = 0.0
    remainingDashLen = dashLength
    # print(dashDirection, dashVelocity, dashVector)
    # print(dashTime)

func _on_enemy_attack(damage):
    var c = soundPlayer.instance()
    c.stream = hitSounds[randi()%hitSounds.size()]
    c.pitch_scale = 1.0+randf()*0.2
    c.playing = true
    $"../".add_child(c)
    health -= damage
    healthUpdate = 0.3
    if health <= 0:
        emit_signal("death")
    emit_signal("health_update",health)
