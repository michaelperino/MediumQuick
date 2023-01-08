extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var times
var enableTimer
var enableShuffle
var enableRandom
var noShapeKill

# Called when the node enters the scene tree for the first time.
func _ready():
	times = []
	enableTimer = true
	enableShuffle = false
	enableRandom = false
	noShapeKill = false
	
func push_time(time):
	times.push_back(time)
	
func get_times():
	return times

func clear_times():
	times = []
	
func setTimer(val):
	enableTimer = val
	
func getTimer():
	return enableTimer
	
func setShuffle(val):
	enableShuffle = val
	
func getShuffle():
	return enableShuffle
	
func setRandom(val):
	enableRandom = val
	
func getRandom():
	return enableRandom
	
func setNoShapeKill(val):
	noShapeKill = val
	
func getNoShapeKill():
	return noShapeKill

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
