extends Node2D

export (Texture) var texture setget _set_texture
var walls : Array = [];
var walltypes : Array = [];
const size = 16
const textureSize : Vector2 = Vector2(16,48)

func populate(x_size, y_size):
	for x in x_size:
		walls.append([])
		for y in y_size:
			walls[x].append(randi()%3)
	for x in x_size:
		walltypes.append([])
		for y in y_size:
			walltypes[x].append(randi()%4)

func _ready():
	populate(9,9);

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
	print(walltypes)
	for y in walls[0].size():
		for x in walls.size():
			var screenrect = Rect2(-walls[0].size()*size/2+x*size,-walls.size()*size/2+y*size,textureSize.x,textureSize.y)
			if(walls[x][y]==0):
				screenrect.position.y+=size*1.5
				var texturerect = Rect2((walltypes[x][y]+4)*size,0,textureSize.x,textureSize.y)
				texture.draw_rect_region(get_canvas_item(), screenrect, texturerect)
			if(walls[x][y]==1):
				screenrect.position.y+=size*1.5
				var texturerect = Rect2(walltypes[x][y]*size,0,textureSize.x,textureSize.y)
				texture.draw_rect_region(get_canvas_item(), screenrect, texturerect)
			if(walls[x][y]==2):
				var texturerect = Rect2(walltypes[x][y]*size,0,textureSize.x,textureSize.y)
				texture.draw_rect_region(get_canvas_item(), screenrect, texturerect)

