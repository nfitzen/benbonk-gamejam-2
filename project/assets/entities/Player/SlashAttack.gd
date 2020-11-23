extends Area2D

var num = 0
    
func _ready():
    VisualServer.canvas_item_set_parent(get_canvas_item(), $"../".get_canvas_item())
    connect("body_entered", self, "_on_Area2D_body_enter")
    VisualServer.canvas_item_set_z_index(get_canvas_item(), position.y)
    $"AnimatedSprite".playing = true
    if(num==0):
        $"AnimatedSprite".rotation = 135
        $"AnimatedSprite".flip_h = false
    else:
        $"AnimatedSprite".rotation = 45
        $"AnimatedSprite".flip_h = true
        
    #var bs = get_overlapping_bodies()
    rotation = get_global_mouse_position().angle_to_point(get_global_position())
    #$"..".emit_signal("player_attack", bs, 40, Vector2(20, 0).rotated(rotation))
    
func _process(delta):
    if($"AnimatedSprite".frame==1):
        if(get_node_or_null("CollisionPolygon2D")!=null):
            $"CollisionPolygon2D".queue_free()
    if($"AnimatedSprite".frame==4):
        queue_free()
        
func _on_Area2D_body_enter(body):
    if body.is_in_group("enemy"):
        body.take_hit(1, (body.position-position).normalized()*4+$"../Player".velocity/8)
