extends AudioStreamPlayer

const home_music = preload("res://Assets/Sound/Music/Ackordföljd.wav")
const level_one_music = preload("res://Assets/Sound/Music/OST_2.mp3")


func _play_music(music: AudioStream):
	if stream == music:
		return
	stream = music
	play()
	
func play_music_home(): 
	_play_music(home_music)
	
func play_music_level():
	_play_music(level_one_music)
	

