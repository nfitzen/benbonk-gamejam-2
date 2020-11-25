# SPDX-FileCopyrightText: 2020 Henry Schneider, Kai Hoop, Nathaniel Fitzenrider, and Austin Chang
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends Area2D

export (Array, AudioStream) var bulletShootySounds
export (Array, AudioStream) var bulletHitSounds
export (Array, AudioStream) var bulletWallSounds
export (PackedScene) var shootFX
export (PackedScene) var soundPlayer
export (PackedScene) var hitFX

export var speed = 250

var num # unused

func _ready():
    var i = shootFX.instance()
    i.position = $"../Player".position
    for child in i.get_children():
        child.emitting = true
    VisualServer.canvas_item_set_parent(i.get_canvas_item(), $"../".get_canvas_item())
    VisualServer.canvas_item_set_z_index(i.get_canvas_item(), i.position.y+8)
    $"../".add_child(i)
    VisualServer.canvas_item_set_parent(get_canvas_item(), $"../".get_canvas_item())
    var c = soundPlayer.instance()
    c.stream = bulletShootySounds[randi()%bulletShootySounds.size()]
    c.pitch_scale = 1.0+randf()*0.2
    c.playing = true
    $"../".add_child(c)
    connect("body_entered", self, "_on_Area2D_body_enter")
    # $"AnimatedSprite".playing = true
    rotation = get_global_mouse_position().angle_to_point(get_global_position())

func _process(delta):
    VisualServer.canvas_item_set_z_index(get_canvas_item(), position.y)
    position += Vector2(speed, 0).rotated(rotation) * delta

func _on_Area2D_body_enter(body):
    if body.is_in_group("enemy"):
        var i = hitFX.instance()
        i.position = body.position
        for child in i.get_children():
            child.emitting = true
            child.process_material.direction = Vector3((get_global_mouse_position()-get_global_position()).normalized().x,(get_global_mouse_position()-get_global_position()).normalized().y,0)
        VisualServer.canvas_item_set_parent(i.get_canvas_item(), $"../".get_canvas_item())
        VisualServer.canvas_item_set_z_index(i.get_canvas_item(), i.position.y+8)
        $"../".add_child(i)
        var c = soundPlayer.instance()
        c.stream = bulletHitSounds[randi()%bulletHitSounds.size()]
        c.pitch_scale = 1.0+randf()*0.2
        c.playing = true
        $"../".add_child(c)
        body.take_hit(1, (body.position-position).normalized()*100)
        queue_free()
    elif body.is_in_group("wall"):
        var c = soundPlayer.instance()
        c.stream = bulletWallSounds[randi()%bulletWallSounds.size()]
        c.pitch_scale = 1.0+randf()*0.1
        c.playing = true
        $"../".add_child(c)
        queue_free()
