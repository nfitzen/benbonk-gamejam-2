# SPDX-FileCopyrightText: 2020 Henry Schneider, Kai Hoop, Nathaniel Fitzenrider, and Austin Chang
#
# SPDX-License-Identifier: GPL-3.0-or-later

extends Node2D

export (Texture) var texture

func _process(delta):
    update()

func _draw():
    VisualServer.canvas_item_set_z_index(get_canvas_item(), 4096)

    # Weapon draws
    var weapon = $"../Player".weapon
    var weaponAmt = int(($"../Player".cooldown/$"../Player".maxCooldown[weapon])*8)*3
    var pos = Vector2(92,-64)
    var screenrect = Rect2(pos, Vector2(24,24))
    var texturerect = Rect2(weapon*24,32,24,24)
    texture.draw_rect_region(get_canvas_item(), screenrect, texturerect)
    pos.y+=24-weaponAmt
    screenrect = Rect2(pos, Vector2(24,weaponAmt))
    texturerect = Rect2(weapon*24,80-weaponAmt,24,weaponAmt)
    texture.draw_rect_region(get_canvas_item(), screenrect, texturerect)

    #Health + Ammo
    pos = Vector2(-124-8,-64)
    for i in $"../Player".maxHealth:
        pos.x+=16
        screenrect = Rect2(pos, Vector2(16,16))
        if($"../Player".health<=i):
            if($"../Player".healthUpdate>0 && $"../Player".health==i):
                texturerect = Rect2(48,0,16,16)
                screenrect.position += Vector2(-1,1)
            else:
                texturerect = Rect2(32,0,16,16)
        else:
            texturerect = Rect2(0,0,16,16)
        texture.draw_rect_region(get_canvas_item(), screenrect, texturerect)

    pos = Vector2(-120-8,-52)
    for i in $"../Player".maxAmmos[$"../Player".weapon]:
        pos.x+=16
        screenrect = Rect2(pos, Vector2(16,16))
        if($"../Player".ammo<=i):
            if($"../Player".ammoUpdate>0 && $"../Player".ammo==i):
                texturerect = Rect2(48,16,16,16)
                screenrect.position += Vector2(-1,1)
            else:
                texturerect = Rect2(16,16,16,16)
        else:
            texturerect = Rect2(0,16,16,16)
        texture.draw_rect_region(get_canvas_item(), screenrect, texturerect)


