extends Node

class_name Scenario

const DURATION:float = 30.0

var start_time:float
var time_left:float setget , _get_time_left


func start():
	start_time = OS.get_system_time_msecs()


func _get_time_left():
	time_left = OS.get_system_time_msecs() - start_time
	return time_left
