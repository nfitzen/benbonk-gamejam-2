extends Node2D

export (Texture) var texture setget _set_texture
var walls : Array = [];
var newwalls : Array = [];
var walltypes : Array = [];
var wallproxs : Array = [];
const size = 16
const bottomBuffer = 8
const textureSize : Vector2 = Vector2(size,48)
var drawShadows : bool = true

func populate(x_size, y_size):
    var r : Array
    r = gen_basic(x_size,y_size)
    walls = r[0]
    walltypes = r[1]
    wallproxs = r[2]
    recalc_prox()

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
                if(x>3&&x<13&&y>4&&y<10):
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

func update():
    pass

func _process(_delta):
    update()
    
func _set_texture(value):
    # If the texture variable is modified externally,
    # this callback is called.
    texture = value #texture was changed
    update() # update the node

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
            if(walls[x][y]==0):
                screenrect.position.y+=textureSize.y-size-bottomBuffer
                if(wallproxs[x][y]!=0):
                    screenrect.size.x = textureSize.x
                    screenrect.size.y = textureSize.x
                    var texturerect = Rect2((4+walltypes[x][y])*size,size*(2-wallproxs[x][y]),textureSize.x,textureSize.x)
                    texture.draw_rect_region(get_canvas_item(), screenrect, texturerect)
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
                    
                    texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1a)
                    screenrect.position.x+=textureSize.x/2
                    texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1b)
                    screenrect.position.x-=textureSize.x/2
                    screenrect.position.y+=textureSize.x/2
                    texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1c)
                    screenrect.position.x+=textureSize.x/2
                    texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1d)
                    #var texturerect = Rect2((walltypes[x][y]+4)*size,size*2,textureSize.x,textureSize.y)
                    #texture.draw_rect_region(get_canvas_item(), screenrect, texturerect)
                    if(drawShadows):
                        if(walls[x+1][y]==1):
                            var length : float = textureSize.x*0.75
                            screenrect.position.x-=length-textureSize.x*0.5
                            screenrect.position.y-=textureSize.x/2
                            screenrect.size.x = length
                            screenrect.size.y = textureSize.x
                            var texturerect3 = Rect2(textureSize.x*9,textureSize.x*3,1,1)
                            var shadowcolor = Color(1.0,1.0,1.0,0.4)
                            texture.draw_rect_region(get_canvas_item(), screenrect, texturerect3, shadowcolor)
            if(walls[x][y]==1):
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
                texture.draw_rect_region(get_canvas_item(), screenrect, texturerect2)
                if(x>0&&x<walls.size()-1&&y>0&&y<walls[0].size()-1):
                    screenrect.size.x=textureSize.x*0.5
                    screenrect.size.y=textureSize.y-textureSize.x
                    var texturerect2b
                    if(walls[x-1][y]==0):
                        texturerect2b = Rect2(textureSize.x*8,size*3,textureSize.x*0.5,textureSize.y-textureSize.x)
                        texture.draw_rect_region(get_canvas_item(), screenrect, texturerect2b)
                    if(walls[x+1][y]==0):
                        texturerect2b = Rect2(textureSize.x*8.5,size*3,textureSize.x*0.5,textureSize.y-textureSize.x)
                        screenrect.position.x+=textureSize.x*0.5
                        texture.draw_rect_region(get_canvas_item(), screenrect, texturerect2b)
                        screenrect.position.x-=textureSize.x*0.5
                    screenrect.size.x=textureSize.x
                
                
                # THE TOP OF THE WALLS 
                screenrect.position.y-=size
                if(wallproxs[x][y]==2):
                    var texturerect1 = Rect2(walltypes[x][y]*size,size*(2-wallproxs[x][y]),textureSize.x,textureSize.x)
                    screenrect.size.x=textureSize.x
                    screenrect.size.y=textureSize.x
                    texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1)
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
                    texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1a)
                    screenrect.position.x+=textureSize.x/2
                    texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1b)
                    screenrect.position.x-=textureSize.x/2
                    screenrect.position.y+=textureSize.x/2
                    texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1c)
                    screenrect.position.x+=textureSize.x/2
                    texture.draw_rect_region(get_canvas_item(), screenrect, texturerect1d)
