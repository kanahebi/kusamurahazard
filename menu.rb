class Menu
	attr_accessor :sentaku
	def initialize(window)
		@window = window
		@image  = SDL::Surface.load("menu.png")
		@sentaku = 0
	end

	def play
		@window.showImage(@image,220,181)
		@window.refresh
		while true do
			while event = SDL::Event2.poll do
				case event
					when SDL::Event2::Quit
						exit
					when SDL::Event2::KeyDown
						if event.sym == (SDL::Key::Q)
							@sentaku = 0
							return false
						end
						if event.sym == (SDL::Key::Z)
							@sentaku = 1
							return false
						end
				end
			end
		end
	end
end
