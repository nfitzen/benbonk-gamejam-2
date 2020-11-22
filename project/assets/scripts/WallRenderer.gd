extends Node2D

export (Texture) var texture setget _set_texture
export (PackedScene) var square_dust
export (Array, AudioStream) var sounds
var walls : Array = [];
var newwalls : Array = [];
var walldiff : Array = [];
var walltypes : Array = [];
var wallproxs : Array = [];
const z_multiplier = 16;
const size = 16
const bottomBuffer = 8
const textureSize : Vector2 = Vector2(size,48)
var drawShadows : bool = true
var drawHeight : float = 0.0
var drawTime : float = 0.0
var swapping = false;
var swapTime = 0.45;

func populate(x_size, y_size):
    var r : Array
    r = gen_basic(x_size,y_size)
    walls = r[0]
    walltypes = r[1]
    wallproxs = r[2]
    r = gen_basic(x_size,y_size)
    newwalls = r[0]
    walldiff = get_diff(walls,newwalls)
    recalc_prox()

func get_diff(w,nw):
    var d : Array = []
    for x in w.size():
        d.append([])
        for y in w[0].size():
            d[x].append(nw[x][y]-w[x][y])
    return d

func gen_basic(x_size, y_size):
    var w : Array = []
    var wt : Array = []
    var wp : Array = []
    for x in x_size:
        w.append([])
        for y in y_size:
            if(x>4&&x<12&&y>5&&y<9):
                w[x].append(0)
            else:
                if(x>2&&x<14&&y>3&&y<11):
                    w[x].append(randi()%2)
                else:
                    w[x].append(1)
    for x in x_size:
        wt.append([])
        for y in y_size:
            wt[x].append(randi()%4)
    for x in x_size:
        wp.append([])
        for y in y_size:
            wp[x].append(0)
    return [w,wt,wp]

func recalc_prox():
    for x in wallproxs.size():
        for y in wallproxs[0].size():
            wallproxs[x][y] = 2
    for x in wallproxs.size()-2:
        for y in wallproxs[0].size()-2:
            if(walls[x+1][y+1]!=walls[x+2][y+1] || walls[x+1][y+1]!=walls[x][y+1] || walls[x+1][y+1]!=walls[x+1][y+2] || walls[x+1][y+1]!=walls[x+1][y]):
                wallproxs[x+1][y+1] = 0
    for x in wallproxs.size()-2:
        for y in wallproxs[0].size()-2:
            if(wallproxs[x+1][y+1]==0):
                if(wallproxs[x+2][y+1]==2):
                    wallproxs[x+2][y+1] = 1
                if(wallproxs[x+1][y+2]==2):
                    wallproxs[x+1][y+2] = 1
                if(wallproxs[x+1][y]==2):
                    wallproxs[x+1][y] = 1
                if(wallproxs[x][y+1]==2):
                    wallproxs[x][y+1] = 1


func _ready():
    populate(17,15);
    $"../WallCollision".create_bodies(walls)


func _process(delta):
    if(Input.is_action_pressed("ui_left")):
        swapping = true;
        $"Sound".stream = sounds[randi()%sounds.size()]
        $"Sound".pitch_scale = 1.0+randf()*0.1
        $"Sound".playing = true
        
    if(swapping):
        drawTime += delta
        drawHeight = -(cos(3.8*(drawTime/swapTime)-0.4)*0.5-0.5)*1.055-0.04
        if(drawTime>0.43):
            for x in walls.size():
                for y in walls[0].size():
                    if(walldiff[x][y]==1 || (walldiff[x][y]==-1&&walls[x][y+1]==0&&newwalls[x][y+1]==0)):
                        var i = square_dust.instance()
                        i.position.x = (x-walls.size()/2)*textureSize.x
                        i.position.y = (y-walls[0].size()/2)*textureSize.x+(textureSize.y-size-bottomBuffer)*((walldiff[x][y]-1)/(0-2))
                        for child in i.get_children():
                            child.emitting = true
                        $"Particles".add_child(i)
        if(drawTime>0.44):
            for child in $"Particles".get_children():
                for child2 in child.get_children():
                    child2.emitting = false
        if(drawTime>=swapTime):
            #Finish swap
            drawTime = 0.0
            #Draw particles
            
            #Swap walls
            var s = newwalls
            newwalls = walls
            walls = s
            walldiff = get_diff(walls,newwalls)
            # TODO: add collision for walls the moment they move up, but still only remove it when they finish going down
            $"../WallCollision".update_from_diff(walldiff)
            recalc_prox()
            swapping = false
            drawHeight = 0.0
    
    update()

func _set_texture(value):
    # If the texture variable is modified externally,
    # this callback is called.
    texture = value #texture was changed
    update() # update the node

func draw_floor(x, y, screenrect, alpha=1.0, use_z=false):
    #if(!use_z):
    #    z_index = -1
    #else:
    #   z_index = (y-walls[0].size()/2)*z_multiplier
    if(alpha>1.0): alpha = 1.0
    if(alpha<0.0): alpha = 0.0
    # Rendering floors
    screenrect.position.y+=textureSize.y-size-bottomBuffer
    if(wallproxs[x][y]!=0):
        screenrect.size.x = textureSize.x
        screenrect.size.y = textureSize.x
        var texturerect = Rect2((4+walltypes[x][y])*size,size*(2-wallproxs[x][y]),textureSize.x,textureSize.x)
        texture.draw_rect_region(get_canvas_item(), screenrect, texturerect, Color(1,1,1,alpha))
    else:
        #Border floor (needs slicing)
        screenrect.size.x=textureSize.x/2
        screenrect.size.y=textureSize.x/2
        var texturerect1a
        var texturerect1b
        var texturerect1c
        var texturerect1d
        texturerect1a = Rect2(4*size,size*(2-wallproxs[x][y]),textureSize.x/2,textureSize.x/2)
        texturerect1b = Rect2(4*size+textureSize.x/2,size*(2-wallproxs[x][y]),textureSize.x/2,textureSize.x/2)
        texturerect1c = Rect2(4*size,textureSize.x/2+size*(2-wallproxs[x][y]),textureSize.x/2,textureSize.x/2)
        texturerect1d = Rect2(4*size+textureSize.x/2,size*(2-wallproxs[x][y])+textureSize.x/2,textureSize.x/2,textureSize.x/2)
        if(x>0&&x<walls.size()-1&&y>0&&y<walls[0].size()-1):
            #A
            if(walls[x-1][y]==1):
                if(walls[x][y-1]==1):
                    pass
                else:
                    if(walls[x-1][y-1]==1):
                        texturerect1a.position.x+=textureSize.x
                    else:
                        texturerect1a.position.x+=textureSize.x*2
                        texturerect1a.position.y+=textureSize.x*0.5
            else:
                if(walls[x][y-1]==1):
                    if(walls[x-1][y-1]==1):
                        texturerect1a.position.x+=textureSize.x*2
                    else:
                        texturerect1a.position.x+=textureSize.x*3
                else:
                    texturerect1a.position.y-=textureSize.x*3
            #B
            if(walls[x+1][y]==1):
                if(walls[x][y-1]==1):
                    pass
                else:
                    if(walls[x+1][y-1]==1):
                        texturerect1b.position.x+=textureSize.x
                    else:
                        texturerect1b.position.x+=textureSize.x*2
                        texturerect1b.position.y+=textureSize.x*0.5
            else:
                if(walls[x][y-1]==1):
                    if(walls[x+1][y-1]==1):
                        texturerect1b.position.x+=textureSize.x*2
                    else:
                        texturerect1b.position.x+=textureSize.x*3
                else:
                    texturerect1b.position.y-=textureSize.x*3
            #C
            if(walls[x-1][y]==1):
                if(walls[x][y+1]==1):
                    pass
                else:
                    if(walls[x-1][y+1]==1):
                        texturerect1c.position.x+=textureSize.x
                    else:
                        texturerect1c.position.x+=textureSize.x*3
            else:
                #Hopefully our walls are taller than 8px
                texturerect1c.position.y-=textureSize.x*3
            #D
            if(walls[x+1][y]==1):
                if(walls[x][y+1]==1):
                    pass
                else:
                    if(walls[x+1][y+1]==1):
                        texturerect1d.position.x+=textureSize.x
                    else:
                        texturerect1d.position.x+=textureSize.x*3
            else:
                #Hopefully our walls are taller than 8px
                texturerect1d.position.y-=textureSize.x*3
        
        texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1a, Color(1,1,1,alpha))
        screenrect.position.x+=textureSize.x/2
        texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1b, Color(1,1,1,alpha))
        screenrect.position.x-=textureSize.x/2
        screenrect.position.y+=textureSize.x/2
        texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1c, Color(1,1,1,alpha))
        screenrect.position.x+=textureSize.x/2
        texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1d, Color(1,1,1,alpha))
        #var texturerect = Rect2((walltypes[x][y]+4)*size,size*2,textureSize.x,textureSize.y)
        #texture.draw_rect_region(get_canvas_item(), screenrect, texturerect)
        if(drawShadows):
            if(walls[x+1][y]==0 && newwalls[x+1][y]):
                var length : float = textureSize.x*0.75
                if(walldiff[x+1][y]==1):
                    length -= textureSize.x*0.75*(1-drawHeight)
                if(walldiff[x][y]==-1):
                    length -= textureSize.x*0.75*(1-drawHeight)
                if(length<0): length = 0.0
                screenrect.position.x-=length-textureSize.x*0.5
                screenrect.position.y-=textureSize.x/2
                screenrect.size.x = length
                screenrect.size.y = textureSize.x
                var texturerect3 = Rect2(textureSize.x*9,textureSize.x*3,1,1)
                var shadowcolor = Color(1.0,1.0,1.0,0.4)
                texture.draw_rect_region(get_canvas_item(), screenrect, texturerect3, shadowcolor)
            if(walls[x+1][y]==1):
                var length : float = textureSize.x*0.75
                if(walldiff[x+1][y]==-1):
                    length -= textureSize.x*0.75*drawHeight
                if(walldiff[x][y]==1):
                    length -= textureSize.x*0.75*drawHeight
                if(length<0): length = 0.0
                screenrect.position.x-=length-textureSize.x*0.5
                screenrect.position.y-=textureSize.x/2
                screenrect.size.x = length
                screenrect.size.y = textureSize.x
                var texturerect3 = Rect2(textureSize.x*9,textureSize.x*3,1,1)
                var shadowcolor = Color(1.0,1.0,1.0,0.4)
                texture.draw_rect_region(get_canvas_item(), screenrect, texturerect3, shadowcolor)
                            
func draw_wall(x, y, screenrect, alpha=1.0):
    #z_index = (y-walls[0].size()/2)*z_multiplier+100
    if(alpha>1.0): alpha = 1.0
    if(alpha<0.0): alpha = 0.0
    #side of da walls
    screenrect.position.y+=size
    var texturerect2 = Rect2((walltypes[x][y]+3)*size,size*3,textureSize.x,textureSize.y)
    if(x>0&&x<walls.size()-1&&y>0&&y<walls[0].size()-1):
        if(walls[x-1][y+1]==1):
            if(walls[x+1][y+1]==1):
                texturerect2 = Rect2(0,size*3,textureSize.x,textureSize.y)
            else:
                texturerect2 = Rect2(2*size,size*3,textureSize.x,textureSize.y)
        elif(walls[x+1][y+1]==1):
            texturerect2 = Rect2(size,size*3,textureSize.x,textureSize.y)
    texture.draw_rect_region(get_canvas_item(), screenrect, texturerect2, Color(1,1,1,alpha))
    if(x>0&&x<walls.size()-1&&y>0&&y<walls[0].size()-1):
        screenrect.size.x=textureSize.x*0.5
        screenrect.size.y=textureSize.y-textureSize.x
        var texturerect2b
        if(walls[x-1][y]==0):
            texturerect2b = Rect2(textureSize.x*8,size*3,textureSize.x*0.5,textureSize.y-textureSize.x)
            texture.draw_rect_region(get_canvas_item(), screenrect, texturerect2b, Color(1,1,1,alpha))
        if(walls[x+1][y]==0):
            texturerect2b = Rect2(textureSize.x*8.5,size*3,textureSize.x*0.5,textureSize.y-textureSize.x)
            screenrect.position.x+=textureSize.x*0.5
            texture.draw_rect_region(get_canvas_item(), screenrect, texturerect2b, Color(1,1,1,alpha))
            screenrect.position.x-=textureSize.x*0.5
        screenrect.size.x=textureSize.x
    
    
    # THE TOP OF THE WALLS 
    screenrect.position.y-=size
    if(wallproxs[x][y]==2):
        var texturerect1 = Rect2(walltypes[x][y]*size,size*(2-wallproxs[x][y]),textureSize.x,textureSize.x)
        screenrect.size.x=textureSize.x
        screenrect.size.y=textureSize.x
        texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1, Color(1,1,1,alpha))
    else:
        screenrect.size.x=textureSize.x/2
        screenrect.size.y=textureSize.x/2
        var texturerect1a = Rect2(walltypes[x][y]*size,size*(2-wallproxs[x][y]),textureSize.x/2,textureSize.x/2)
        var texturerect1b = Rect2(walltypes[x][y]*size+textureSize.x/2,size*(2-wallproxs[x][y]),textureSize.x/2,textureSize.x/2)
        var texturerect1c = Rect2(walltypes[x][y]*size,textureSize.x/2+size*(2-wallproxs[x][y]),textureSize.x/2,textureSize.x/2)
        var texturerect1d = Rect2(walltypes[x][y]*size+textureSize.x/2,size*(2-wallproxs[x][y])+textureSize.x/2,textureSize.x/2,textureSize.x/2)
        if(x>0&&x<walls.size()-1&&y>0&&y<walls[0].size()-1):
            var a = false
            var b = false
            var c = false
            var d = false
            if(walls[x-1][y-1]==0):
                a = true
            if(walls[x+1][y-1]==0):
                b = true
            if(walls[x-1][y+1]==0):
                c = true
            if(walls[x+1][y+1]==0):
                d = true
            if(wallproxs[x][y]==0):
                a = ((walls[x][y-1]==0) || (walls[x-1][y]==0))
                b = ((walls[x][y-1]==0) || (walls[x+1][y]==0))
                c = ((walls[x][y+1]==0) || (walls[x-1][y]==0))
                d = ((walls[x][y+1]==0) || (walls[x+1][y]==0))
            elif(wallproxs[x][y]==1):
                if(a):
                    texturerect1a.position.y+=textureSize.x
                if(b):
                    texturerect1b.position.y+=textureSize.x
                if(c):
                    texturerect1c.position.y+=textureSize.x
                if(d):
                    texturerect1d.position.y+=textureSize.x
                if(wallproxs[x][y-1]==0):
                    a = true
                    b = true
                if(wallproxs[x][y+1]==0):
                    c = true
                    d = true
                if(wallproxs[x-1][y]==0):
                    a = true
                    c = true
                if(wallproxs[x+1][y]==0):
                    b = true
                    d = true
            if(!a):
                texturerect1a.position.y-=textureSize.x
            if(!b):
                texturerect1b.position.y-=textureSize.x
            if(!c):
                texturerect1c.position.y-=textureSize.x
            if(!d):
                texturerect1d.position.y-=textureSize.x
        texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1a, Color(1,1,1,alpha))
        screenrect.position.x+=textureSize.x/2
        texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1b, Color(1,1,1,alpha))
        screenrect.position.x-=textureSize.x/2
        screenrect.position.y+=textureSize.x/2
        texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1c, Color(1,1,1,alpha))
        screenrect.position.x+=textureSize.x/2
        texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1d, Color(1,1,1,alpha))
#
# A poem for your
# Wall and floor renderer which
# Barely even works
#
# Love from a coding masochist ~
#
# Enjoy the readability !
#
func _draw():
    for y in walls[0].size():
        for x in walls.size():
            var screenrect = Rect2((-walls.size())*size/2+x*size,-walls.size()*size/2+y*size+size,textureSize.x,textureSize.y)
            if(walldiff[x][y]==0):
                if(walls[x][y]==0):
                    draw_floor(x,y,screenrect)
                if(walls[x][y]==1):
                    draw_wall(x,y,screenrect)
            else:
                screenrect.position.y-=(textureSize.y-size-bottomBuffer)*drawHeight*walldiff[x][y]
                if(walls[x][y]==0):
                    screenrect.position.y+=(textureSize.y-size-bottomBuffer)
                    draw_wall(x,y,screenrect,1-drawHeight)
                    screenrect.position.y-=(textureSize.y-size-bottomBuffer)
                    draw_floor(x,y,screenrect,1-drawHeight,true)
                    drawHeight = 1-drawHeight
                    screenrect.position.y+=(textureSize.y-size-bottomBuffer)
                    draw_wall(x,y,screenrect,1-drawHeight)
                    drawHeight = 1-drawHeight
                if(walls[x][y]==1):
                    drawHeight = 1-drawHeight
                    draw_wall(x,y,screenrect,1-drawHeight)
                    screenrect.position.y-=(textureSize.y-size-bottomBuffer)
                    draw_floor(x,y,screenrect,1-drawHeight,true)
                    screenrect.position.y+=(textureSize.y-size-bottomBuffer)
                    drawHeight = 1-drawHeight
                    draw_wall(x,y,screenrect,1-drawHeight)
