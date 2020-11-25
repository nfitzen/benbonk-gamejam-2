# SPDX-FileCopyrightText: 2020 Henry Schneider, Kai Hoop, Nathaniel Fitzenrider, and Austin Chang
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_pressed():
    get_tree().change_scene("res://assets/scenes/main.tscn")

func _on_help_pressed():
    get_tree().change_scene("res://assets/scenes/menus/HelpMenu/HelpMenu.tscn")


func _on_exit_pressed():
    get_tree().quit()

