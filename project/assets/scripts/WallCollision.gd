extends Node2D
export (PackedScene) var UnitWallCollision = preload("res://assets/entities/UnitWallCollision.tscn")

var static_bodies = []
const size = 16

# Called when the node enters the scene tree for the first tim
func _ready():
    pass

func create_body(x, y, offset):
    var wall_base_offset = ($"../WallRenderer".textureSize.y-$"../WallRenderer".size-$"../WallRenderer".bottomBuffer)
    var body = UnitWallCollision.instance()
    body.position += (Vector2(x, y) + offset) * size
    body.position.y += wall_base_offset
    add_child(body)
    return body

func get_offset(walls):
    return Vector2(-walls.size()/2, 1-walls.size()/2)

# Expects a 2D Boolean array
func create_bodies(walls, wallproxs):
    var offset = get_offset(walls)
    for x in range(len(walls)):
        var br = []
        for y in range(len(walls[x])):
            if (walls[x][y]==1 && wallproxs[x][y]<2):
                br.append(create_body(x, y, offset))
            else:
                br.append(null)
        static_bodies.append(br)

func update_from_diff(walldiff, oldproxs, wallproxs, newwalls):
    # TODO: array growing logic?
    var offset = get_offset(walldiff)
    for x in range(len(walldiff)):
        for y in range(len(walldiff[x])):
            if walldiff[x][y] == 1 and static_bodies[x][y]:
                static_bodies[x][y].queue_free()
                static_bodies[x][y] = null
            elif walldiff[x][y] == -1 and not static_bodies[x][y]:
                static_bodies[x][y] = create_body(x, y, offset)
            else:
                if (newwalls[x][y]==1 && wallproxs[x][y]<2 && !static_bodies[x][y]):
                    static_bodies[x][y] = create_body(x, y, offset)
                elif (newwalls[x][y]==1 && wallproxs[x][y]==2 && static_bodies[x][y]):
                    static_bodies[x][y].queue_free()
                    static_bodies[x][y] = null


