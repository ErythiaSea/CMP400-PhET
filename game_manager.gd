## The GameManager is responsible for storing the current scenario type
## and for tracking and generating question types.

extends Node

const MAIN_MENU_SCENE = "res://Scenes/main_menu.tscn"
@export var q_args: Dictionary[String, float] # only export so i can cheat :p 
signal new_question_type

enum mode {
	freeplay,
	e_coeff,
	proj_mtn,
	collision
}

enum q_type {
	e_initheight,            #0
	e_finalheight,           #1
	e_findcoeff,             #2
	e_finalvel,              #3
	e_initvel,               #4
	e_vel_coeff,             #5
	suvat_lob_powerangle,    #6
	suvat_lob_angle_time,    #7
	suvat_lob_dist_time,     #8
	suvat_needle_maxheight,  #9
	suvat_needle_dist,       #10
	col_ballmass,            #11
	col_pinmass,             #12
	col_init_ballspeed,      #13
	col_final_ballspeed,     #14
	col_final_pinspeed,      #15
	q_type_count
}

var current_gamemode: int = mode.freeplay
var current_q_type: q_type = q_type.q_type_count;
var correct: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func generate_q_type() -> q_type:
	if current_gamemode == mode.freeplay:
		return q_type.q_type_count
		
	if current_gamemode == mode.e_coeff:
		var i = randi_range(0, 5)
		current_q_type = (0 + i) as q_type
		
	if current_gamemode == mode.proj_mtn:
		var i = randi_range(0, 4)
		current_q_type = (q_type.suvat_lob_powerangle + i) as q_type
		
	if current_gamemode == mode.collision:
		var i = randi_range(0, 4)
		current_q_type = (q_type.col_ballmass + i) as q_type
		
	new_question_type.emit(current_q_type)
	return current_q_type

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
