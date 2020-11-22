extends Node2D
export (PackedScene) var UnitWallCollision = preload("res://assets/entities/UnitWallCollision.tscn")

var static_bodies = []
const size = 16

# Called when the node enters the scene tree for the first tim
func _ready():
    pass

# Expects a 2D Boolean array
func create_bodies(walls):
    var offset = Vector2(-walls.size()/2, 1-walls.size()/2)
    for x in range(len(walls)):
        var br = []
        for y in range(len(walls[x])):
            if walls[x][y]:
                var body = UnitWallCollision.instance()
                br.append(body)
                add_child(body)
                body.position += (Vector2(x, y) + offset) * size
            else:
                br.append(null)
        static_bodies.append(br)
                
