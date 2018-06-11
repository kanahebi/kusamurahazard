class Result
	attr_accessor :s_hk, :s_nk, :s_mk, :s_kk, :s_dm
	def initialize(window,sound)
		@kazu = Array.new()
		10.times {|i| @kazu[i] = SDL::Surface.load("score#{i}.gif")}

		@back = Array.new
		@back[1] = SDL::Surface.load("result.gif")
		@back[2] = SDL::Surface.load("result2.gif")
		
		@window = window
		@sound  = sound
		@s_hk   = 0
		@s_nk   = 0
		@s_mk   = 0
		@s_kk   = 0
		@s_dm   = 0
	end

	def play(no)
		while true do
			while event = SDL::Event2.poll do
				case event
					when SDL::Event2::Quit
						exit
					when SDL::Event2::KeyDown
						if event.sym == (SDL::Key::SPACE)
							@s_hk = 0
							@s_nk = 0
							@s_mk = 0
							@s_kk = 0
							@s_dm = 0
							return false
						end
				end
			end

			@window.showImage(@back[no],0,0)
			hyouji(@s_hk / 10,@s_hk % 10,115)
			hyouji(@s_nk / 10,@s_nk % 10,178)
			hyouji(@s_mk / 10,@s_mk % 10,241)
			hyouji(@s_kk / 10,@s_kk % 10,304)
			hyouji(@s_dm / 10,@s_dm % 10,367)
			@window.refresh
		end
	end

	def hyouji(ten,one,y)
		@ten = ten
		@one = one
		@y   = y
		if @ten >= 10
			@window.showImage(@kazu[1],419,@y)
			@ten -= 10
		end
		@window.showImage(@kazu[@ten],455,@y)
		@window.showImage(@kazu[@one],491,@y)
	end
end
