# SPDX-FileCopyrightText: 2020 Henry Schneider, Kai Hoop, Nathaniel Fitzenrider, and Austin Chang
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends Node2D

var time = 0.0

func _process(delta):
    time+=delta
    if(time>get_children()[0].get_lifetime()*2):
        queue_free()
