extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var timerFarLeft
var timerFarRight
var timerCurrPos
var end_time
var start_time
var curr_time
var polycalc
var timer_color

# Called when the node enters the scene tree for the first time.
func _ready():
	timerFarLeft = Vector2(30,800)
	timerFarRight = Vector2(1170,850)
	timerCurrPos = timerFarRight
	polycalc = load("res://scripts/point_calc.gd").new()
	curr_time = OS.get_ticks_msec()/1000.0
	setTime(1000)
	timerCurrPos = max((end_time - curr_time)/(end_time - start_time)*1170,30.0)
	timer_color = Color(.1,.8,.1,1)
	
func setTime(val):
	start_time = OS.get_ticks_msec()/1000.0
	end_time = val + start_time
	
func getRemaining():
	return end_time - curr_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if end_time - curr_time < 0:
		var Gameplay = get_node("/root/Node/GameControl")
		Gameplay.userLost()
	curr_time = OS.get_ticks_msec()/1000.0
	timerCurrPos = max((end_time - curr_time)/(end_time - start_time)*1170,30.0)
	timer_color = Color(.9 - 0.75*timerCurrPos/1170, 0.0+0.75*timerCurrPos/1170, 0.02, 1)
	update()

func _draw():
	var timer_points_1 = polycalc.rect_corner_calc(timerFarLeft,timerFarRight)
	draw_colored_polygon(timer_points_1,Color(.9,.9,.9,1))
	var timer_points_2 = polycalc.rect_corner_calc(timerFarLeft,Vector2(timerCurrPos,850))
	draw_colored_polygon(timer_points_2,timer_color)
