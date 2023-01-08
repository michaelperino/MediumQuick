extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func COLORS(color):
	if color == "FIREBRICK":
		return Color(Color( 178.0/255, 34.0/255, 34.0/255, 1 ))

func square_calc(center,size):
	var points = PoolVector2Array()
	points.push_back(Vector2(center[0]-size,center[1]-size))
	points.push_back(Vector2(center[0]+size,center[1]-size))
	points.push_back(Vector2(center[0]+size,center[1]+size))
	points.push_back(Vector2(center[0]-size,center[1]+size))
	return points
	
func rect_center_calc(center,length,height):
	var points = PoolVector2Array()
	points.push_back(Vector2(center[0]-length,center[1]-height))
	points.push_back(Vector2(center[0]+length,center[1]-height))
	points.push_back(Vector2(center[0]+length,center[1]+height))
	points.push_back(Vector2(center[0]-length,center[1]+height))
	return points

func rect_corner_calc(topleft,botright):
	var points = PoolVector2Array()
	points.push_back(Vector2(topleft[0],topleft[1]))
	points.push_back(Vector2(topleft[0],botright[1]))
	points.push_back(Vector2(botright[0],botright[1]))
	points.push_back(Vector2(botright[0],topleft[1]))
	return points

func penta_calc(center,size):
	var points = PoolVector2Array()
	size = size * 2
	points.push_back(Vector2(center[0],center[1]-int(size*.5)))
	points.push_back(Vector2(center[0]-int(size*0.52573111),center[1]-int(size*0.11803399)))
	points.push_back(Vector2(center[0]-int(size*0.3249197),center[1]+int(size*0.5)))
	points.push_back(Vector2(center[0]+int(size*0.3249197),center[1]+int(size*0.5)))
	points.push_back(Vector2(center[0]+int(size*0.52573111),center[1]-int(size*0.11803399)))
	return points

func equi_tri_calc(center,size,orientation):
	var points = PoolVector2Array()
	size = size * 2
	#points.push_back(Vector2(center[0],center[1]-int(size*.5)))
	#points.push_back(Vector2(center[0] - int(size*.57735027),center[1]+int(size*.5)))
	#points.push_back(Vector2(center[0] + int(size*.57735027),center[1]+int(size*.5)))
	points.push_back(Vector2(0,-size*.66666667))
	points.push_back(Vector2(-size*.57735027,size*.3333333333))
	points.push_back(Vector2(size*.57735027,size*.33333333333))
	for i in range(len(points)):
		#points[i][0] = points[i][0]*cos(orientation*3.14159/180) - points[i][1]*sin(orientation*3.14159/180) + center[0]
		#points[i][1] = points[i][0]*sin(orientation*3.14159/180) + points[i][1]*cos(orientation*3.14159/180) + center[1]
		points[i] = points[i].rotated(orientation*PI/180.0) + Vector2(center[0],center[1])
	return points

func star_calc(center,size):
	var points = PoolVector2Array()
	size = size * 2
	var c0 = center[0]
	var c1 = center[1]
	points.push_back(Vector2(c0,c1-int(size*.5)))
	points.push_back(Vector2(c0+int(size*.11803399),c1-int(size*.11803399)))
	points.push_back(Vector2(c0+int(size*.52573111),c1-int(size*.11803399)))
	points.push_back(Vector2(c0+int(size*.20081142),c1+int(size*.11803399)))
	points.push_back(Vector2(c0+int(size*.3249197),c1+int(size*.5)))
	points.push_back(Vector2(c0,c1+int(size*.26393202)))
	points.push_back(Vector2(c0-int(size*.3249197),c1+int(size*.5)))
	points.push_back(Vector2(c0-int(size*.20081142),c1+int(size*.11803399)))
	points.push_back(Vector2(c0-int(size*.52573111),c1-int(size*.11803399)))
	points.push_back(Vector2(c0-int(size*.11803399),c1-int(size*.11803399)))
	return points
	
func circle_calc(center,size):
	var points = PoolVector2Array()
	var num_angles = 60
	
	for i in range(num_angles):
		points.push_back(center + Vector2(cos(i*2*3.14159/num_angles), sin(i*2*3.14159/num_angles)) * size)
	return points
