class Boss
	attr_accessor :sentaku
	def initialize(window,sound)
		@back  = SDL::Surface.load("boss.gif")
		@ww    = SDL::Surface.load("ww.png")
		@window = window
		@sound  = sound
		@x = [nil,103,103,234,234,234,103]
		@y = [nil,165,227,324,362,402,490]
		@sentaku = 1
	end

	def play
		@sound.bgmplay("top")
		@sentaku = 1
		while true do
			while event = SDL::Event2.poll do
				case event
					when SDL::Event2::Quit
						exit
					when SDL::Event2::KeyDown
						if event.sym == (SDL::Key::Q)
							@sentaku = 7
							return false
						end
						if event.sym == (SDL::Key::UP) and @sentaku > 1
								@sentaku -= 1
						end
						if event.sym == (SDL::Key::DOWN) and @sentaku < 6
								@sentaku += 1
						end
						if event.sym == (SDL::Key::SPACE)
							return false
						end
				end
			end
			@window.showImage(@back,0,0)
			@window.showImage(@ww,@x[@sentaku],@y[@sentaku])
			@window.refresh
		end
	end
end
