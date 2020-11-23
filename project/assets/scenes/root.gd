# SPDX-FileCopyrightText: 2020 Henry Schneider, Kai Hoop, Nathaniel Fitzenrider, and Austin Chang
#
# SPDX-License-Identifier: GPL-3.0-or-later

# This script should be attached to a node when the game starts.
# Usually, this is the title screen.

extends Node

func _enter_tree():
    randomize()
