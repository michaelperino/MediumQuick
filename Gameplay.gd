extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var LevelData
var Level_idx
var LevelLabel
var Shapes
var Order
var allotedTime
var polycalc
var colldet
var LoseScreen
var Status
var WinScreen
var currshape
var PlayerVars
var start_time
var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	polycalc = load("res://scripts/point_calc.gd").new()
	colldet = load("res://scripts/collision_detection.gd").new()
	var file = File.new()
	file.open("res://LevelData.json", File.READ)
	var content = file.get_as_text()
	file.close()
	LevelData = JSON.parse(content).get_result()
	Level_idx = 1
	LevelLabel = get_node("/root/Node/TopLabels/ColorRect/LevelLabel")
	LoseScreen = get_node("/root/Node/LoseControl")
	WinScreen = get_node("/root/Node/WinControl")
	LoseScreen.visible = false
	WinScreen.visible = false
	PlayerVars = get_node("/root/PlayerVariables")
	start_time = 0
	rng = RandomNumberGenerator.new()
	rng.randomize()
	load_level(Level_idx)

func load_level(level_num):
	currshape = 0
	LoseScreen.visible = false
	WinScreen.visible = false
	Status = "Playing"
	LevelLabel.text = "Level " + str(level_num)
	var level_to_load
	var level_bool = false
	for level in LevelData["levels"]:
		if level["level"] == level_num:
			level_to_load = level
			level_bool = true
	if level_bool == false:
		get_tree().change_scene("res://Gamecomplete.tscn")
		return
	allotedTime = level_to_load["time"]
	if start_time == 0:
		start_time = OS.get_ticks_msec()/1000.0
		if(PlayerVars.getRandom()):
			level_to_load["shapes"] = genRandomLevel(level_num*2+8)
			level_to_load["order"] = []+level_to_load["shapes"]
			level_to_load["order"].invert()
	Shapes = [] + level_to_load["shapes"]
	Order = [] + level_to_load["order"]
	if(PlayerVars.getShuffle()):
		randomize()
		Order.shuffle()
		allotedTime += allotedTime*0.2
	var Timer = get_node("/root/Node/Timer")
	if PlayerVars.getTimer() and not PlayerVars.getRandom():
		Timer.setTime(allotedTime)
	else:
		Timer.setTime(1000)
	for shape in Shapes:
		if shape["type"] == "square":
			shape["points"] = polycalc.square_calc(Vector2(shape["center"]["x"],shape["center"]["y"]),shape["size"])
		if shape["type"] == "penta":
			shape["points"] = polycalc.penta_calc(Vector2(shape["center"]["x"],shape["center"]["y"]),shape["size"])
		if shape["type"] == "star":
			shape["points"] = polycalc.star_calc(Vector2(shape["center"]["x"],shape["center"]["y"]),shape["size"])
		if shape["type"] == "circle":
			shape["points"] = polycalc.circle_calc(Vector2(shape["center"]["x"],shape["center"]["y"]),shape["size"])
		if shape["type"] == "triangle":
			shape["points"] = polycalc.equi_tri_calc(Vector2(shape["center"]["x"],shape["center"]["y"]),shape["size"],shape["tri_angle"])
		shape["dropshadow"] = []
		for point in shape["points"]:
			shape["dropshadow"].append(Vector2(point[0]+shape["size"]/20,point[1]+shape["size"]/20))
	update()
			
func conv_color(color_name):
	var color_256 = LevelData["colors"][color_name]
	return Color(color_256[0]/255.0,color_256[1]/255.0,color_256[2]/255.0,1)
	
func userLost():
	Shapes = null
	Order = null
	LoseScreen.visible = true
	Status = "Lost"
	update()
	
func userWon():
	Shapes = null
	Order = null
	WinScreen.visible = true
	Status = "Won"
	Level_idx += 1
	PlayerVars.push_time(OS.get_ticks_msec()/1000.0 - start_time)
	start_time = 0
	update()
	
func _draw():
	if Shapes:
		for shape in Shapes:
			draw_colored_polygon(shape["dropshadow"],conv_color("DIM GRAY / DIM GREY"))
			draw_colored_polygon(shape["points"],conv_color(shape["color"]))
		var shapeinc = 55
		var drawshapecount = 0
		if currshape > 14:
			drawshapecount -= (currshape - 14)
		var draw_currshape = min(currshape,14)
		draw_colored_polygon(polycalc.square_calc(Vector2(38 + 1 + draw_currshape * shapeinc, 44), 28),conv_color("WHITE SMOKE"))
		draw_colored_polygon(polycalc.equi_tri_calc(Vector2(38 + 1 + draw_currshape * shapeinc, 88), 14, 0),conv_color("WHITE SMOKE"))
		for shape in Order:
			if shape["type"] == "circle":
				draw_colored_polygon(polycalc.circle_calc(Vector2(38 + 2 + drawshapecount * shapeinc, 44 + 2), 22), conv_color("DIM GRAY / DIM GREY"))
				draw_colored_polygon(polycalc.circle_calc(Vector2(38 + drawshapecount * shapeinc, 44), 22), conv_color(shape["color"]))
			elif shape["type"] == "square":
				draw_colored_polygon(polycalc.square_calc(Vector2(38 + drawshapecount * shapeinc + 2, 44 + 2), 21), conv_color("DIM GRAY / DIM GREY"))
				draw_colored_polygon(polycalc.square_calc(Vector2(38 + drawshapecount * shapeinc, 44), 21), conv_color(shape["color"]))
			elif shape["type"] == "penta":
				draw_colored_polygon(polycalc.penta_calc(Vector2(38 + drawshapecount * shapeinc + 2, 44 + 2), 21), conv_color("DIM GRAY / DIM GREY"))
				draw_colored_polygon(polycalc.penta_calc(Vector2(38 + drawshapecount * shapeinc, 44), 21), conv_color(shape["color"]))
			elif shape["type"] == "star":
				draw_colored_polygon(polycalc.star_calc(Vector2(38 + drawshapecount * shapeinc + 2, 44 + 2), 21), conv_color("DIM GRAY / DIM GREY"))
				draw_colored_polygon(polycalc.star_calc(Vector2(38 + drawshapecount * shapeinc, 44), 21), conv_color(shape["color"]))
			elif shape["type"] == "triangle":
				draw_colored_polygon(polycalc.equi_tri_calc(Vector2(38 + drawshapecount * shapeinc + 2, 44 + 2), 21, shape["tri_angle"]), conv_color("DIM GRAY / DIM GREY"))
				draw_colored_polygon(polycalc.equi_tri_calc(Vector2(38 + drawshapecount * shapeinc, 44), 21, shape["tri_angle"]), conv_color(shape["color"]))
			drawshapecount += 1

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if Status == "Playing":
				var ClickedShape = null
				print("Left button was clicked at ", event.position)
				for shape in range(len(Shapes)-1,-1,-1):
					if colldet.is_inside_polygon(Shapes[shape]["points"],get_viewport().get_mouse_position()):
						ClickedShape = Shapes[shape]
						break
				if ClickedShape != null:
					print(ClickedShape["center"])
					Shapes.erase(ClickedShape)
					update()
					if Order[currshape]["type"] == ClickedShape["type"] and Order[currshape]["color"] == ClickedShape["color"]:
						currshape += 1
					else:
						userLost()
						print("WRONG")
				if ClickedShape == null and PlayerVars.getNoShapeKill():
					userLost()
				if Order and currshape >= len(Order) and Status == "Playing":
					userWon()
			elif (Status == "Lost" or Status == "Won") and event.position.y > 120:
				load_level(Level_idx)

func randShape(center,size):
	var shape = {}
	var valid_types = ["star","circle","square","penta","triangle"]
	var valid_colors = ["MAROON","ORANGE","ROYAL BLUE","MEDIUM VIOLET RED","DARK KHAKI"]
	shape["center"] = {}
	shape["center"]["x"] = rng.randi_range(100,1100)
	shape["center"]["y"] = rng.randi_range(100,750)
	shape["tri_angle"] = rng.randi_range(0,30)*360/30.0
	shape["type"] = valid_types[rng.randi_range(0,len(valid_types)-1)]
	shape["color"] = valid_colors[rng.randi_range(0,len(valid_colors)-1)]
	shape["size"] = rng.randi_range(40,100)
	if shape["type"] == "square":
		shape["points"] = polycalc.square_calc(Vector2(shape["center"]["x"],shape["center"]["y"]),shape["size"])
	if shape["type"] == "penta":
		shape["points"] = polycalc.penta_calc(Vector2(shape["center"]["x"],shape["center"]["y"]),shape["size"])
	if shape["type"] == "star":
		shape["points"] = polycalc.star_calc(Vector2(shape["center"]["x"],shape["center"]["y"]),shape["size"])
	if shape["type"] == "circle":
		shape["points"] = polycalc.circle_calc(Vector2(shape["center"]["x"],shape["center"]["y"]),shape["size"])
	if shape["type"] == "triangle":
		shape["points"] = polycalc.equi_tri_calc(Vector2(shape["center"]["x"],shape["center"]["y"]),shape["size"],shape["tri_angle"])
	return shape
	
func test_circ_enc(circles):
	for i in range(len(circles)):
		var circ_1 = Vector2(circles[i][0],circles[i][1])
		for j in range(i+1,len(circles)):
			var dist = circ_1.distance_to(Vector2(circles[j][0],circles[j][1]))
			if(circles[i][2] > circles[j][2] and dist < (circles[i][2] - circles[j][2])):
				return true

func genRandomLevel(num_shapes):
	var rand_shape_list = []
	var rand_shape_locs = []
	for i in range(num_shapes):
		var x = rng.randi_range(100,1100)
		var y = rng.randi_range(150,750)
		var size = rng.randi_range(40,100)
		rand_shape_locs.append(Vector3(x,y,size*1.1))
		if test_circ_enc(rand_shape_locs):
			for j in range(100):
				rand_shape_locs.remove(len(rand_shape_locs) - 1)
				x = rng.randi_range(100,1100)
				y = rng.randi_range(100,750)
				size = rng.randi_range(40,100)
				rand_shape_locs.append(Vector3(x,y,size*1.1))
				if not test_circ_enc(rand_shape_locs):
					break
		
	for i in range(num_shapes):
		rand_shape_list.push_back(randShape(Vector2(rand_shape_locs[i][0],rand_shape_locs[i][1]),rand_shape_locs[i][2]/1.1))
	return rand_shape_list
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().change_scene("res://Gamecomplete.tscn")
	return
