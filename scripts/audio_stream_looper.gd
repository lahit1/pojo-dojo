@tool
extends AudioStreamPlayer

func _ready() -> void:
	# 1. Connect the finished signal to this script
	finished.connect(_on_audio_finished)
	
	# 2. Start the first random sound
	play()

func _on_audio_finished() -> void:
	# When a stream ends, calling play() automatically forces 
	# AudioStreamRandomizer to select a fresh random track.
	play()
