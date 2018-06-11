class Game_d
	attr_accessor :kekka, :s_dm
	def initialize(window,sound,menu)
		@window  = window
		@sound   = sound
		@menu    = menu
		@back    = Back.new(@window)
		@hero    = Hero.new(@window,@sound,100,240)
		@daikon  = Daikon.new(@window,@sound,@hero,550,300)
		@command = Command.new(@window,@hero,30,505,0)
		@shp     = Hp.new(@window,@hero,1,75, 50, 1,  5,0)
		@dhp     = Hp.new(@window,@daikon,2,424,50,-1,735,1)
		@nexts   = Next.new(@window,@hero)
		@h       = 0
		@count   = 0
		@kekka   = 0
		@back.set("stage2")
	end

	def play
		@sound.bgmplay("boss")
		while true do
			while event = SDL::Event2.poll
				case event
					when SDL::Event2::Quit
						exit
					when SDL::Event2::KeyDown
						if event.sym == (SDL::Key::SPACE) and @hero.jmp == 3 and @hero.move and @hero.hp > 0
							@hero.jmp = 1
						end
						if event.sym == (SDL::Key::Z) and @daikon.hp <= 0
							@s_dm = 100 - @hero.hp
							@back.reset
							@hero.reset
							@daikon.reset
							return false
						end
				end
			end
			
			SDL::Key.scan 
			if SDL::Key.press?(SDL::Key::RIGHT)   and !@hero.action and @daikon.x - @hero.x > 120 and @hero.move and @hero.hp > 0
				@hero.muki   = 3
				@hero.x      += 0.5
				@hero.hayasa += 1
				@hero.hasiru = true
			elsif SDL::Key.press?(SDL::Key::LEFT) and !@hero.action and             @hero.x > -48 and @hero.move and @hero.hp > 0
				@hero.muki   = 1
				@hero.x      -= 0.5
				@hero.hayasa += 1
				@hero.hasiru = true
			else
				@hero.hasiru = false
			end
			if SDL::Key.press?(SDL::Key::C) and @hero.move and @hero.hp > 0
				@hero.press = "c"
			else
				@hero.press = ""
			end
			if SDL::Key.press?(SDL::Key::X) and @hero.move and @hero.hp > 0
				@hero.px = true
			else
				@hero.px = false
			end
			if SDL::Key.press?(SDL::Key::Q)
				@menu.play
				if @menu.sentaku == 1
					@back.reset
					@hero.reset
					@daikon.reset
					return false
				end
			end
			if @daikon.bx - @hero.x < 80 and @daikon.b == 2
				@h          += 1
				@hero.ataru = true
				@hero.move  = false
				if @h == 20
					@hero.x += 2
				else
					@hero.x -= 0.1
				end
				if @h == 25
					@hero.hp -= 2
					@h = 0
				end
			else
				@hero.move  = true
				@hero.ataru = false
			end
			@back.draw
			@command.draw
			@daikon.draw
			@hero.draw
			@daikon.beam
			@shp.draw
			@dhp.draw
			if @daikon.hp <= 0
				if @kekka == 0
					@sound.winplay
				end
				@nexts.bdraw
				@kekka = 1
			end
			@window.refresh
			if @hero.hp <= 0
				@count += 1
				if @count == 1000
					@kekka = 0
					@count = 0
					@back.reset
					@hero.reset
					@daikon.reset
					return false
				end
			end
		end
	end
end
