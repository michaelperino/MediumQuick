extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var PlayerVars
var TimesLabel
var SettingsLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVars = get_node("/root/PlayerVariables")
	TimesLabel = get_node("/root/Node/TimesLabel")
	SettingsLabel = get_node("/root/Node/SettingsLabel")
	var times = PlayerVars.get_times()
	var total_time = 0
	for i in range(1,len(times)+1):
		TimesLabel.text += "Level " + str(i) + ":  " + str(times[i-1]) + "\n"
		total_time += max(times[i-1],0)
	TimesLabel.text += "Total Time: " + str(total_time)
	SettingsLabel.text = ""
	SettingsLabel.text += "Timer? " + str(PlayerVars.getTimer())
	SettingsLabel.text += "\nShuffle? " + str(PlayerVars.getShuffle())
	SettingsLabel.text += "\nRandom? " + str(PlayerVars.getRandom())
	SettingsLabel.text += "\nEmpty Kill? " + str(PlayerVars.getNoShapeKill())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	PlayerVars.clear_times()
	get_tree().change_scene("res://Menu.tscn")
