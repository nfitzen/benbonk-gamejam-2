extends Node2D

export (Texture) var texture setget _set_texture
var walls : Array = [];
var newwalls : Array = [];
var walltypes : Array = [];
var wallproxs : Array = [];
const size = 16
const textureSize : Vector2 = Vector2(16,48)

func populate(x_size, y_size):
	for x in x_size:
		walls.append([])
		for y in y_size:
			if(x>4&&x<12&&y>5&&y<11):
				walls[x].append(0)
			else:
				walls[x].append(1)
	for x in x_size:
		walltypes.append([])
		for y in y_size:
			walltypes[x].append(randi()%4)
	for x in x_size:
		wallproxs.append([])
		for y in y_size:
			wallproxs[x].append(0)

func recalc_prox():
	for x in wallproxs.size():
		for y in wallproxs[0].size():
			wallproxs[x][y] = 2;
	for x in wallproxs.size()-2:
		for y in wallproxs[0].size()-2:
			if(walls[x+1][y+1]==0):
				wallproxs[x+1][y+1] = 0;
				wallproxs[x+2][y+1] = 0;
				wallproxs[x+1][y+2] = 0;
				wallproxs[x+1][y] = 0;
				wallproxs[x][y+1] = 0;
	for x in wallproxs.size()-2:
		for y in wallproxs[0].size()-2:
			if(wallproxs[x+1][y+1]==0):
				wallproxs[x+2][y+1] = 1;
				wallproxs[x+1][y+2] = 1;
				wallproxs[x+1][y] = 1;
				wallproxs[x][y+1] = 1;
				

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

func _draw():
	for y in walls[0].size():
		for x in walls.size():
			var screenrect = Rect2((-walls.size())*size/2+x*size,-walls.size()*size/2+y*size+size,textureSize.x,textureSize.y)
			if(walls[x][y]==0):
				screenrect.position.y+=size*1.5
				var texturerect = Rect2((walltypes[x][y]+4)*size,0,textureSize.x,textureSize.y)
				texture.draw_rect_region(get_canvas_item(), screenrect, texturerect)
			if(walls[x][y]==1):
				var texturerect = Rect2(walltypes[x][y]*size,0,textureSize.x,textureSize.y)
				texture.draw_rect_region(get_canvas_item(), screenrect, texturerect)

