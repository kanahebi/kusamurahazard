class Continue
	attr_accessor :sentaku
	def initialize(window,sound)
		@back   = SDL::Surface.load("continueback.gif")
		@cont   = SDL::Surface.load("continue.gif")
		@title  = SDL::Surface.load("title.gif")
		@ww     = SDL::Surface.load("ww.png")
		@window = window
		@sound  = sound
		@hero   = Hero.new(@window,@sound,-800,-800)
		@kusa   = Array.new(4){|i| Array.new}
		10.times {|i| @kusa[0][i] = HumuK.new(@window,@sound,@hero,rand(730) + 1,445)}
		10.times {|i| @kusa[1][i] = KaruK.new(@window,@sound,@hero,rand(730) + 1,360)}
		10.times {|i| @kusa[2][i] = MosuK.new(@window,       @hero,rand(730) + 1,430)}
		10.times {|i| @kusa[3][i] = KesuK.new(@window,       @hero,rand(730) + 1,465)}
		@count = 0
		@wx    = 42.5
	end

	def play
		@sentaku = 0
		@sound.cntplay
		while true do
			while event = SDL::Event2.poll do
				case event
					when SDL::Event2::Quit
						exit
					when SDL::Event2::KeyDown
						if @count >= 7000
							if event.sym == (SDL::Key::LEFT)
								@sentaku = 0
								@wx      = 42.5
							end
							if event.sym == (SDL::Key::RIGHT)
								@sentaku = 1
								@wx      = 403.5
							end
							if event.sym == (SDL::Key::SPACE) and ( @sentaku == 1 or @sentaku == 0 )
								@kusa.flatten.each{|kusa| kusa.x = rand(730) + 1}
								@count = 0
								@wx    = 42.5
								return false
							end
						end
				end
			end

			@window.showImage(@back,0,0)

			@kusa.each {|kusa| kusa[0].draw}
			@kusa.each {|kusa| kusa[1].draw} if @count >= 500
			@kusa.each {|kusa| kusa[2].draw} if @count >= 1000
			@kusa.each {|kusa| kusa[3].draw} if @count >= 1500
			@kusa.each {|kusa| kusa[4].draw} if @count >= 2000
			@kusa.each {|kusa| kusa[5].draw} if @count >= 2500
			@kusa.each {|kusa| kusa[6].draw} if @count >= 3000
			@kusa.each {|kusa| kusa[7].draw} if @count >= 3500
			@kusa.each {|kusa| kusa[8].draw} if @count >= 4000
			@kusa.each {|kusa| kusa[9].draw} if @count >= 4500

			if @count >= 7000
				@window.showImage(@ww,@wx,310)
				@window.showImage(@cont,101,334)
				@window.showImage(@title,460,330)
			else
				@count += 1
			end
			@window.refresh
		end
	end
end
