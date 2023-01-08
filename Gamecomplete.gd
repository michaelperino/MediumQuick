extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var PlayerVars
var TimesLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVars = get_node("/root/PlayerVariables")
	TimesLabel = get_node("/root/Node/TimesLabel")
	var times = PlayerVars.get_times()
	var total_time = 0
	for i in range(1,len(times)+1):
		TimesLabel.text += "Level " + str(i) + ":  " + str(times[i-1]) + "\n"
		total_time += times[i-1]
	TimesLabel.text += "Total Time: " + str(total_time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	PlayerVars.clear_times()
	get_tree().change_scene("res://Menu.tscn")
