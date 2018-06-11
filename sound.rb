class Sound
	def initialize
		SDL.init(SDL::INIT_EVERYTHING)
		SDL::Mixer.open(SDL::Mixer::DEFAULT_FREQUENCY, SDL::Mixer::DEFAULT_FORMAT,SDL::Mixer::DEFAULT_CHANNELS,2048)
		@sound_humu  = SDL::Mixer::Wave.load("katana_cut1.wav")
		@sound_karu  = SDL::Mixer::Wave.load("basari.wav")
		@sound_mosu  = SDL::Mixer::Wave.load("fire1.wav")
		@sound_punch = SDL::Mixer::Wave.load("middle_punch1.wav")
		@sound_utu   = SDL::Mixer::Wave.load("middle_kick.wav")
		@sound_beam  = SDL::Mixer::Wave.load("laser01.wav")
		@sound_maku  = SDL::Mixer::Wave.load("zombie_eating.wav")
		@sound_rival = SDL::Mixer::Wave.load("katana_cut2.wav")
		@continue    = SDL::Mixer::Music.load("p4_2.mp3")
		@win         = SDL::Mixer::Music.load("syouri.mp3")
		@bgm = Hash.new
		@bgm["talk"] = SDL::Mixer::Music.load("talk.mp3")
		@bgm["run"]  = SDL::Mixer::Music.load("run.mp3")
		@bgm["boss"] = SDL::Mixer::Music.load("boss.mp3")
		@bgm["top"]  = SDL::Mixer::Music.load("top.mp3")
	end
	
	def hmplay
		SDL::Mixer.play_channel(0,@sound_humu,0)
	end

	def krplay
		SDL::Mixer.play_channel(1,@sound_karu,0)
	end

	def pcplay
		SDL::Mixer.play_channel(2,@sound_punch,0)
	end

	def utplay
		SDL::Mixer.play_channel(3,@sound_utu,0)
	end

	def msplay
		SDL::Mixer.play_channel(4,@sound_mosu,0)
	end

	def bmplay
		SDL::Mixer.play_channel(5,@sound_beam,0)
	end

	def mkplay
		SDL::Mixer.play_channel(6,@sound_maku,0)
	end

	def rvplay
		SDL::Mixer.play_channel(7,@sound_rival,0)
	end

	def cntplay
		SDL::Mixer.play_music(@continue,0)
	end

	def winplay
		SDL::Mixer.play_music(@win,0)
	end

	def bgmplay(bgm)
		SDL::Mixer.play_music(@bgm[bgm],-1)
	end
end
