# SPDX-FileCopyrightText: 2020 Henry Schneider, Kai Hoop, and Nathaniel Fitzenrider
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends KinematicBody2D

signal player_attack(damage)
export (Array, PackedScene) var attacks

var active_attack = 0;

export var speed = 75.0
var direction = 0.0
export var maxHealth = 4

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
var dashDirection : Vector2
var maxNumAttack = 2;
var attackNum = 0;

var dashCooldown = 0

func ready():
    VisualServer.canvas_item_set_parent(get_canvas_item(), $"../".get_canvas_item())

func _process(delta):
    if(Input.is_action_just_pressed("ui_right")):
        print(position.y)
    if(Input.is_action_just_pressed("attack")):
        attackNum += 1;
        if(attackNum==maxNumAttack):
            attackNum = 0
        var i  = attacks[1].instance()
        i.position = position+(get_global_mouse_position() - get_global_position()).normalized()*8
        i.num = attackNum
        $"../".add_child(i)
    
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
            print(remainingDashLen)
            position = position + remainingDashLen * dashDirection
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
            direction = fposmod(round(rad2deg(-velocity.angle())/45),8)
        move_and_slide(velocity)
    #     sprite.animation = "walk"+str(direction)
    # else:
    #     sprite.animation = "idle"+str(direction)

func dash():
    dashing = true
    dashDirection = (get_global_mouse_position() - get_global_position()).normalized()
    dashVelocity = dashDirection * dashSpeed
    dashVector = dashDirection * dashLength
    dashTime = dashLength / dashSpeed
    dashDelta = 0.0
    remainingDashLen = dashLength
    print(dashDirection, dashVelocity, dashVector)
    print(dashTime)
    
func _on_enemy_attack(damage):
    print("ouch owie")
