extends Node2D
export (PackedScene) var UnitWallCollision = preload("res://assets/entities/UnitWallCollision.tscn")

var static_bodies = []
const size = 16

# Called when the node enters the scene tree for the first tim
func _ready():
    create_bodies([[1,1,0,0,1],[1]])

# Expects a 2D Boolean array
func create_bodies(walls):
    for row in range(len(walls)):
        var br = []
        for col in range(len(walls[row])):
            if walls[row][col]:
                var body = UnitWallCollision.instance()
                br.append(body)
                add_child(body)
                body.position += Vector2(row, col) * size
            else:
                br.append(null)
        static_bodies.append(br)
                
