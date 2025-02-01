extends Node2D

var init_angle:float = 0
@export var move_angle:float = 0
@export var move_time:float = 1
@export var randomize_params:bool = false

func _ready():
	init_angle = rotation
	if randomize_params:
		var rng = RandomNumberGenerator.new()
		move_angle = rng.randf_range(15,-15)
		move_time = rng.randf_range(0.4,5)
	var tween = create_tween().set_loops()
	tween.tween_property(self, "rotation", init_angle + deg_to_rad(move_angle), move_time).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "rotation", init_angle - deg_to_rad(move_angle), move_time).set_trans(Tween.TRANS_QUAD)
