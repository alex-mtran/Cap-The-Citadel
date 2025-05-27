extends AudioStreamPlayer

const main_music = preload("res://Assets/Sounds/enchanted tiki 86.mp3")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()

func play_main_music():
	_play_music(main_music)
