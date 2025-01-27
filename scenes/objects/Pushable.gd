extends TileMap
class_name Pushable

var child_pos:PackedVector2Array = []
var things_to_move = {} #collider:null
@onready var ray:RayCast2D = $RayCast2D
@onready var timer:Timer = $Timer

@export var is_player:bool = false
@export var player_id:int = 1
var i = 0	
var dg
var ascg:bool = false;
var color_saved = []

var tween:Tween

var pos_history:PackedVector2Array = []
	
func _ready():
	Global.max_player = 0
	Global.balloon = []
	child_pos = get_used_cells(0) #used cell from tilemap, must extends/inherit TileMap
	EventBus.undo.connect(_on_undo)
	EventBus.move.connect(_on_move)
	for ch in get_parent().get_children():
		if ch is Balloon:
			#print(ch)
			if (color_saved.find(ch.balloon_color, 0) < 0):
				Global.balloon.append(ch)
				Global.max_player += 1
		
	
#main keyboard capture
func get_input():
	#it checks if player active
	#so if i want to add another movable player 
	##i maybe must add another flag
	if not (Global.game_state == Global.STATES.DEFAULT and is_player and !child_pos.is_empty()):
		return
		
	#registered as built-in in project settings
	##default built-in godot input
	const INPUTS = {"ui_left":Vector2.LEFT, 
					"ui_right":Vector2.RIGHT, 
					"ui_up":Vector2.UP, 
					"ui_down":Vector2.DOWN}
	#collision first process
	for key in INPUTS.keys():
		var key_just_pressed = Input.is_action_just_pressed(key) ##key records for undo redo, awesome
		var key_hold = Input.is_action_pressed(key) and timer.is_stopped() #use timer to detect sticky keys
		if key_just_pressed or key_hold:
			if check_move_collision(INPUTS[key]):
				instant_finish_tween()
				EventBus.move.emit()
				move(INPUTS[key])
				
				if key_just_pressed:
					timer.start(0.15)
				else:
					timer.start(0.09)
			else:
				cant_move(INPUTS[key])
				
	#second form of key records	

	if Input.is_action_just_pressed("ui_copy"): #default ctrl + c
		print(pos_history)
	
	if Input.is_action_just_pressed("change_player") and Global.enable_switch and Global.prev_active_player_id == Global.active_player_id:
		print( Global.enable_switch )
		if Global.prev_active_player_id <= Global.max_player:
			Global.prev_active_player_id = Global.active_player_id
		#print("start:")
		var ag = Global.balloon
		if (self.player_id == Global.active_player_id):
			self.is_player = false
		for ch in ag:
			i+=1
			print("Before" + str(Global.prev_active_player_id) + " iloop " + str(i) + " spi " +str(self.player_id) + " chpi " + str(ch.player_id) + " gapi " + str(Global.active_player_id) + " gmpi " + str(Global.max_player))
		
			dg=ch
			#i+=1
			if Global.active_player_id+1 <= Global.max_player:
				if ag[i].player_id != Global.active_player_id+1:
					continue
				print(str(ag[i].player_id) + " " + str(Global.active_player_id+1))
				Global.active_player_id += 1
				ag[i].is_player = true			
			else:
				Global.active_player_id = 1
				ag[0].is_player = true
			break
			
		#print("After " + str(Global.prev_active_player_id) + " i " + str(i) + " spi " +str(self.player_id) + " chpi " + str(dg.player_id) + " gapi " + str(Global.active_player_id) + " gmpi " + str(Global.max_player))
		#print("end:")	
			
	else:
		Global.prev_active_player_id = Global.active_player_id
		i=0
	
#get the physics running, actively running all inside get_input()
func _physics_process(_delta):
	get_input() 

#collider/edge detection
##this one are actively checking the surounding of the player
func check_move_collision(dir:Vector2, exclude_list = []) -> bool:
	var movable:bool = true
	things_to_move = {}
	for col in get_all_colliders(dir):
		if movable == false:
			break
		var group = col.get_groups()[0]
		exclude_list.append(self)
		if group == "wall":
			movable = false
		if group == "balloon" and col.get_parent() not in exclude_list:
			movable = col.get_parent().check_move_collision(dir, exclude_list)
			if movable:
				things_to_move[col.get_parent()] = null

	return movable

func get_all_colliders(dir:Vector2):
	var cols:Dictionary = {}
	for pos in child_pos:
		var col = check_spot_collision(pos,dir)
		if col != null:
			cols[col] = null
	return cols.keys()
	
func check_spot_collision(pos:Vector2, dir:Vector2):
	ray.position = pos*32 + Vector2.ONE * 16
	ray.target_position = dir * 32
	ray.force_raycast_update()
	return ray.get_collider()
	
func move(dir:Vector2):
	for thing in things_to_move:
		thing.move(dir)
	instant_finish_tween()
	position += dir*32
	
	for child in get_children():
		if child is BalloonTile or child is BalloonFace:
			child.on_pos_move(dir)

func cant_move(dir:Vector2):
	pass
	#TODO - add 'not moving' animation
		
func _on_move():
	pos_history.append(position)
	
func instant_finish_tween():
	if tween != null and tween.is_running():
		tween.pause()
		tween.custom_step(1)
	
func _on_undo():
	if pos_history.size() == 0:
		print('nothing to undo')
		return
		
	position = pos_history[-1]
	pos_history.remove_at(pos_history.size()-1)
		
func destroy():
	for pos in child_pos:
		erase_cell(0,pos)
	child_pos = []
