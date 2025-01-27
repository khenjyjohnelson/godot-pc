extends Node

enum STATES {DEFAULT, MOVING, WIN, TRANSITION}
var game_state:int = STATES.DEFAULT

var lv:int = 1
var sub_lv:int = 1
var completed = []
var active_player_id = 1
var max_player = 0
var prev_active_player_id = 1
var balloon = []
var enable_switch:bool = false

var music_volume:int = 0
var sfx_volume:int = 0

func _ready():
	for i in range(4):
		completed.append([])
		for j in range(10):
			completed[i].append(false)
			
func complete_level(l:int, sub:int):
	completed[l-1][sub-1] = true
