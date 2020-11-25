# SPDX-FileCopyrightText: 2020 Henry Schneider, Kai Hoop, Nathaniel Fitzenrider, and Austin Chang
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends Control


func _on_Button_pressed():
    get_tree().change_scene("res://assets/scenes/menus/TitleScreen/TitleScreen.tscn")

