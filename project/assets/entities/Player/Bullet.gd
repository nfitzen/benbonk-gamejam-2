extends Area2D

export (Array, AudioStream) var bulletShootySounds
export (Array, AudioStream) var bulletHitSounds
export (PackedScene) var hitFX

var num # unused

func _ready():
    VisualServer.canvas_item_set_parent(get_canvas_item(), $"../".get_canvas_item())
    #$"ShootSound".stream = bulletShootySounds[randi()%bulletShootySounds.size()]
    #$"ShootSound".pitch_scale = 1.0+randf()*0.2
    #$"ShootSound".playing = true
    connect("body_entered", self, "_on_Area2D_body_enter")
    VisualServer.canvas_item_set_z_index(get_canvas_item(), position.y)
    # $"AnimatedSprite".playing = true
    rotation = get_global_mouse_position().angle_to_point(get_global_position())
    
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
        #$"HitSound".stream = bulletHitSounds[randi()%bulletHitSounds.size()]
        #$"HitSound".pitch_scale = 0.7+randf()*0.1
        #$"HitSound".playing = true
        body.take_hit(1, (body.position-position).normalized()*100)
        queue_free()
