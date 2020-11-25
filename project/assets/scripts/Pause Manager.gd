# SPDX-FileCopyrightText: 2020 Henry Schneider, Kai Hoop, Nathaniel Fitzenrider, and Austin Chang
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends Node2D

var timer = 0

func pause(time):
    if(timer<time):
        timer = time

func _process(delta):
    if(timer>0):
        timer -= delta
        get_tree().paused = true
    if(timer<0):
        timer = 0
        get_tree().paused = false

