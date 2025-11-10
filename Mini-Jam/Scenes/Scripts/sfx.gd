extends Node

@export var cracking = true
@export var ambience = true
@export var Mr_Johnson = true
@onready var beep = $intercom/beep
@onready var intercom = $intercom/intercom
@onready var intro = $intercom/intro


func _ready():
	if Mr_Johnson == false:
		var index = AudioServer.get_bus_index("Mr Johnson")
		AudioServer.set_bus_mute(index, true)
	if cracking == false:
		$crack1.volume_db = -80
		$crack2.volume_db = -80
		$crack3.volume_db = -80
		$crack4.volume_db = -80
	if ambience == false:
		$ambience.volume_db = -80
	await get_tree().create_timer(3).timeout
	beep.play()
	await beep.finished
	intro.play()
	await intro.finished
	beep.play()
	$intercom/intercom_timer.start()

func random_intercom():
	beep.play()
	await beep.finished
	intercom.play()
	await intercom.finished
	beep.play()


func _on_intercom_timer_timeout():
	random_intercom()
