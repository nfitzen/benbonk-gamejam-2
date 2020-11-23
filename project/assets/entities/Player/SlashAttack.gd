extends Area2D

var num = 0
export (Array, AudioStream) var swordSwipeSounds
export (Array, AudioStream) var swordHitSounds
export (PackedScene) var hitFX
    
func _ready():
    VisualServer.canvas_item_set_parent(get_canvas_item(), $"../".get_canvas_item())
    $"SwipeSound".stream = swordSwipeSounds[randi()%swordSwipeSounds.size()]
    $"SwipeSound".pitch_scale = 1.0+randf()*0.2
    $"SwipeSound".playing = true
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
    if($"SwipeSound".playing==false):
        queue_free()
        
func _on_Area2D_body_enter(body):
    if body.is_in_group("enemy"):
        var i = hitFX.instance()
        i.position = body.position
        for child in i.get_children():
            child.emitting = true
            child.process_material.direction = Vector3((get_global_mouse_position()-get_global_position()).normalized().x,(get_global_mouse_position()-get_global_position()).normalized().y,0)
        VisualServer.canvas_item_set_parent(i.get_canvas_item(), $"../".get_canvas_item())
        VisualServer.canvas_item_set_z_index(i.get_canvas_item(), i.position.y+8)
        $"../".add_child(i)
        $"HitSound".stream = swordHitSounds[randi()%swordHitSounds.size()]
        $"HitSound".pitch_scale = 1.0+randf()*0.3
        $"HitSound".playing = true
        body.take_hit(1, (body.position-position).normalized()*160+$"../Player".velocity*6)
