# SPDX-FileCopyrightText: 2020 Henry Schneider, Kai Hoop, and Nathaniel Fitzenrider
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends KinematicBody2D

export var speed = 50
var direction = 0
export var maxHealth = 4

export var dashLength = 120
export var dashSpeed = 75
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


func _process(delta):
    velocity = Vector2.ZERO
    if dashing:
        dashDelta += delta
        remainingDashLen -= dashSpeed * delta
        if dashDelta < dashTime:
            move_and_slide(dashVelocity)
        elif get_slide_count() == 0 and remainingDashLen < 0:
            position = position + remainingDashLen * dashDirection
        else:
            dashing = false

    if(!dashing):
        if Input.is_action_pressed("right"):
            velocity += Vector2.RIGHT
        if Input.is_action_pressed("left"):
            velocity += Vector2.LEFT
        if Input.is_action_pressed("down"):
            velocity += Vector2.DOWN
        if Input.is_action_pressed("up"):
            velocity += Vector2.UP
        if Input.is_action_just_pressed('dash'):
            dash()
        velocity = velocity.normalized() * speed
        if velocity.length() > 0:
            direction = fposmod(round(rad2deg(-velocity.angle())/45),8)
            move_and_slide(velocity)
    #     sprite.animation = "walk"+str(direction)
    # else:
    #     sprite.animation = "idle"+str(direction)

func _input(event):
    if event is InputEventKey:
        if event.pressed and event.scancode == KEY_C:
            $"Camera2D".shakeAmount = 50


func dash():
    dashing = true
    dashDirection = (get_global_mouse_position() - get_global_position()).normalized()
    dashVelocity = dashDirection * dashSpeed
    dashVector = dashDirection * dashLength
    dashTime = dashLength / dashSpeed
    dashDelta = 0.0
