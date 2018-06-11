class Game_b
	attr_accessor :kekka, :s_dm
	def initialize(window,sound,menu)
		@window  = window
		@sound   = sound
		@menu    = menu
		@back    = Back.new(@window)
		@hero    = Hero.new(@window,@sound,100,240)
		@buta    = Buta.new(@window,@hero,@sound,500,233)
		@kp      = Kp.new(@window,@hero,75,70)
		@shp     = Hp.new(@window,@hero,1,75, 50, 1,  5,0)
		@bhp     = Hp.new(@window,@buta,3,424,50,-1,735,1)
		@command = Command.new(@window,@hero,30,505,2)
		@nexts   = Next.new(@window,@hero)
		@h       = 0
		@kurau   = 0
		@count   = 0
		@kekka   = 0
		@back.set("stage4")
	end

	def play
		@sound.bgmplay("boss")
		while true do
			while event = SDL::Event2.poll do
				case event
					when SDL::Event2::Quit
						exit
					when SDL::Event2::KeyDown
						if event.sym == (SDL::Key::SPACE) and @hero.jmp == 3 and @hero.move and @hero.hp > 0
							@hero.jmp = 1
						end
						if event.sym == (SDL::Key::Z) and @buta.hp <= 0
							@s_dm = 100 - @hero.hp
							@back.reset
							@hero.reset
							@buta.reset
							@kekka = 1
							return false
						end
				end
			end
			if @buta.sx - @hero.x < 75
				if @buta.utu
					@sound.pcplay
					@hero.hp    -= 7
					@buta.utu   = false
					@buta.ataru = true
				end
			end
			if @buta.ataru
				@hero.move  = false
				@hero.ataru = true
				@h      += 1
				@hero.x -= 1.1
				@hero.x += 1
				if @h == 100
					@h = 0
					@buta.ataru = false
				end
			else
				@hero.move  = true
				@hero.ataru = false
			end
			SDL::Key.scan 
			if SDL::Key.press?(SDL::Key::RIGHT)   and !@hero.action and @buta.x - @hero.x > 120 and @hero.move and @hero.hp > 0
				@hero.muki   = 3
				@hero.x      += 0.5
				@hero.hayasa += 1
				@hero.hasiru = true
			elsif SDL::Key.press?(SDL::Key::LEFT) and !@hero.action and           @hero.x > -48 and @hero.move and @hero.hp > 0
				@hero.muki   = 1
				@hero.x      -= 0.5
				@hero.hayasa += 1
				@hero.hasiru = true
			else
				@hero.hasiru = false
			end
			@hero.press = ""
			if SDL::Key.press?(SDL::Key::C) and @hero.move and @hero.hp > 0
				@hero.press = "c"
			end
			if SDL::Key.press?(SDL::Key::V) and @hero.move and @hero.hp > 0
				@hero.press = "v"
			end
			if SDL::Key.press?(SDL::Key::X) and @hero.hp > 0
				@hero.px = true
			else
				@hero.px = false
			end
			if SDL::Key.press?(SDL::Key::Q)
				@menu.play
				if @menu.sentaku == 1
					@back.reset
					@hero.reset
					@buta.reset
					return false
				end
			end
			if !@buta.utu and @buta.koudo % 500 == 0
				if @hero.kp == 0 or @hero.press == "c"
					@buta.punch = 1
				end
			end
			@back.draw
			@command.draw
			@buta.draw
			@hero.draw
			@buta.kougeki
			@shp.draw
			@bhp.draw
			@kp.draw
			if @buta.hp <= 0
				unless @kekka == 1
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
					@buta.reset
					return false
				end
			end
		end
	end
end
