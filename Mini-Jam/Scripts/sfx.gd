extends Node

@export var cracking = true
@export var ambience = true

func _ready():
	if cracking == false:
		$crack1.volume_db = -80
		$crack2.volume_db = -80
		$crack3.volume_db = -80
		$crack4.volume_db = -80
	if ambience == false:
		$ambience.volume_db = -80
