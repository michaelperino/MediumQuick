extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var triangle_points_1
var colors
var PlayerVars
var polycalc
var angle

# Called when the node enters the scene tree for the first time.
func _ready():
	polycalc = load("res://scripts/point_calc.gd").new()
	var coll_det = load("res://scripts/collision_detection.gd").new()
	triangle_points_1 = polycalc.square_calc(Vector2(500,500),50)
	triangle_points_1 = polycalc.rect_center_calc(Vector2(500,500),50,100)
	triangle_points_1 = polycalc.rect_corner_calc(Vector2(500,500),Vector2(670,900))
	triangle_points_1 = polycalc.penta_calc(Vector2(500,500),50)
	triangle_points_1 = polycalc.star_calc(Vector2(500,500),50)
	triangle_points_1 = polycalc.circle_calc(Vector2(500,500),50)
	triangle_points_1 = polycalc.equi_tri_calc(Vector2(56,300),20,90)
	colors = PoolColorArray([polycalc.COLORS("FIREBRICK")])
	PlayerVars = get_node("/root/PlayerVariables")
	var switch = get_node("/root/Node/MenuOptions/TimerEnable")
	switch.set_pressed_no_signal (PlayerVars.getTimer())
	switch = get_node("/root/Node/MenuOptions/ShuffleOrder")
	switch.set_pressed_no_signal (PlayerVars.getShuffle())
	switch = get_node("/root/Node/MenuOptions/RandomizeLevels")
	switch.set_pressed_no_signal (PlayerVars.getRandom())
	switch = get_node("/root/Node/MenuOptions/NoShapeKill")
	switch.set_pressed_no_signal (PlayerVars.getNoShapeKill())

func _draw():
	draw_polygon(triangle_points_1,colors)

func _on_Begin_Rect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene("res://Gameplay.tscn")


func _on_TimerEnable_toggled(button_pressed):
	PlayerVars.setTimer(button_pressed)


func _on_ShuffleOrder_toggled(button_pressed):
	PlayerVars.setShuffle(button_pressed)


func _on_RandomizeLevels_toggled(button_pressed):
	PlayerVars.setRandom(button_pressed)


func _on_ClickNothingKill_toggled(button_pressed):
	PlayerVars.setNoShapeKill(button_pressed)
