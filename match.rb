class Match
	attr_accessor :title
	def initialize(window,sound)
		@window = window
		@sound  = sound
		@image  = SDL::Surface.load("match.gif")
	end

	def play
		@sound.bgmplay("top")
		@title = false
		@window.showImage(@image,0,0)
		@window.refresh
		while true do
			while event = SDL::Event2.poll do
				case event
					when SDL::Event2::Quit
						exit
					when SDL::Event2::KeyDown
						if event.sym == (SDL::Key::Q)
							@title = true
							return false
						end
						if event.sym == (SDL::Key::SPACE)
							return false
						end
				end
			end
		end
	end
end
