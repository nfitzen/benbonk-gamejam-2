# SPDX-FileCopyrightText: 2020 Henry Schneider, Kai Hoop, and Nathaniel Fitzenrider
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends KinematicBody2D

export var speed = 800
export var maxHealth = 4
export var dashLength = 400
var direction = 0
var dashing = false
var dashVector : Vector2
var velocity : Vector2


func _process(delta):
    velocity = Vector2.ZERO
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
        velocity = velocity.normalized() * speed * delta
    if velocity.length() > 0:
        direction = fposmod(round(rad2deg(-velocity.angle())/45),8);
    #     sprite.animation = "walk"+str(direction)
    # else:
    #     sprite.animation = "idle"+str(direction)
    position += velocity

func dash():
    return
    dashing = true
    dashVector = (get_global_mouse_position() - get_global_position()).normalized() * dashLength
