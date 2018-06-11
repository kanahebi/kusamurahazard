class Tutorial
	def initialize(window,sound,menu)
		@yaml   = YAML.load_file("stage_s.yml")
		@window = window
		@sound  = sound
		@menu   = menu
		@back   = Back.new(@window)
		@hero   = Hero.new(@window,@sound,324,240)
		@isi1   = Isi1.new(@window,@sound,@hero,1600,422,0)
		@isi2   = Isi1.new(@window,@sound,@hero,4600,419,1)
		@nexts  = Next.new(@window,@hero)
		@command = Command.new(@window,@hero,30,505,8)
		@kusa   = Array.new
		10.times {|i| @kusa[i] = HumuK.new(@window,@sound,@hero,@yaml["stage1"]["humu"]["x"][i],445)}
		@back.set("stage1")

		@bun = Array.new()
		14.times {|i| @bun[i]  = SDL::Surface.load("t#{i}.png")}
		@bun[15] = SDL::Surface.load("t13.png")

		@talk   = 0
		@hyoji  = true
		@sinkou = true
		@syuryo = false
	end

	def play
		@sound.bgmplay("run")
		while true do
			while event = SDL::Event2.poll do
				case event
					when SDL::Event2::Quit
						exit
					when SDL::Event2::KeyDown
						if event.sym == (SDL::Key::SPACE)
							if @hero.jmp == 3 and @sinkou == false
								@hero.jmp = 1
							end
							if @sinkou
								@talk += 1
							end
						end
						if event.sym == (SDL::Key::Z) and @hero.x >= 500 and @hyoji == false
							@syuryo = true
						end
						if @talk >= 14 and @syuryo
							@back.reset
							@hero.reset
							@isi1.reset
							@isi2.reset
							@kusa.each {|kusa| kusa.reset}
							@talk   = 0
							@hyoji  = true
							@sinkou = true
							@syuryo = false
							return false
						end
				end
			end
			if @isi1.noru
				@isi2.oisinoru = true
			else
				@isi2.oisinoru = false
			end
			if @isi2.noru
				@isi1.oisinoru = true
			else
				@isi1.oisinoru = false
			end
			SDL::Key.scan 
			if SDL::Key.press?(SDL::Key::RIGHT) and !@isi1.tomerum and !@isi2.tomerum and @talk != 3 and !@sinkou
				@hero.muki   = 3
				@hero.hayasa += 1
				@hero.hasiru = true
				if @hero.x == @hero.syokix and @back.x > -5600
					@back.x -= 0.5
					@isi1.x -= 0.5
					@isi2.x -= 0.5
					@kusa.each {|kusa| kusa.x -= 0.5}
				elsif @hero.x <= 680
					@hero.x += 0.5
				end
			elsif SDL::Key.press?(SDL::Key::LEFT) and !@isi1.tomeruh and !@isi2.tomeruh and @talk != 2 and !@sinkou
				@hero.muki   = 1
				@hero.hayasa += 1
				@hero.hasiru = true
				if @back.x != 0 and @hero.x == @hero.syokix
					@back.x += 0.5
					@isi1.x += 0.5
					@isi2.x += 0.5
					@kusa.each {|kusa| kusa.x += 0.5}
				elsif @hero.x >= -40
					@hero.x -= 0.5
				end
			else
				@hero.hasiru = false
			end

			if SDL::Key.press?(SDL::Key::Q)
				@menu.play
				if @menu.sentaku == 1
					@back.reset
					@hero.reset
					@isi1.reset
					@isi2.reset
					@kusa.each {|kusa| kusa.reset}
					@talk   = 0
					@hyoji  = true
					@sinkou = true
					@syuryo = false
					return false
				end
			end

			case @talk
				when 2
					if @back.x == -400
						@hyoji  = true
						@sinkou = true
					else
						@hyoji  = false
						@sinkou = false
					end
				when 3
					if @back.x == 0
						@hyoji  = true
						@sinkou = true
					else
						@hyoji  = false
						@sinkou = false
					end
				when 4
					if @isi1.tomerum
						@hyoji  = true
						@sinkou = true
					else
						@hyoji  = false
						@sinkou = false
					end
				when 7
					if @kusa[0].x == 500
						@hyoji  = true
						@sinkou = true
					else
						@hyoji  = false
						@sinkou = false
					end
				when 9
					if @kusa[4].img == 1
						@hyoji  = true
						@sinkou = true
					else
						@hyoji  = false
						@sinkou = false
					end
				when 12
					if @nexts.hyoji
						@hyoji  = true
						@sinkou = true
					else
						@hyoji  = false
						@sinkou = false
					end
				when 13
					if @syuryo
						@hyoji  = true
						@sinkou = true
					else
						@hyoji  = false
						@sinkou = false
					end
			end

			@back.draw
			@isi1.draw
			@isi2.draw
			@kusa.each {|kusa| kusa.draw}
			@hero.draw
			@nexts.draw
			@command.draw
			if @hyoji
				@window.showImage(@bun[@talk],10,445)
			end
			@window.refresh
		end
	end
end

class Tutorial_two
	def initialize(window,sound,menu)
		@yaml   = YAML.load_file("stage_s.yml")
		@window = window
		@sound  = sound
		@menu   = menu
		@hero   = Hero.new(@window,@sound,150,240)
		@hp     = Hp.new(@window,@hero,1,75,50,1,5,0)
		@kp     = Kp.new(@window,@hero,75,70)
		@command = Command.new(@window,@hero,30,505,4)
		@kusa = Array.new(4){|i| Array.new}
		3.times {|i| @kusa[0][i] = HumuK.new(@window,@sound,@hero,400+i*64,445)}
		3.times {|i| @kusa[1][i] = KaruK.new(@window,@sound,@hero,400+i*70,360)}
		3.times {|i| @kusa[2][i] = MosuK.new(@window,       @hero,400+i*77,430)}
		3.times {|i| @kusa[3][i] = KesuK.new(@window,       @hero,400+i*85,465)}

		@bun = Array.new()
		14.times {|i| @bun[i]  = SDL::Surface.load("u#{i}.png")}
		@back    = SDL::Surface.load("sean10.gif")

		@ks_i   = 0
		@talk   = 0
		@hyoji  = true
		@sinkou = true
		@syuryo = false
	end

	def play
		@sound.bgmplay("run")
		while true do
			while event = SDL::Event2.poll do
				case event
					when SDL::Event2::Quit
						exit
					when SDL::Event2::KeyDown
						if event.sym == (SDL::Key::SPACE)
							if @hero.jmp == 3 and @sinkou == false
								@hero.jmp = 1
							end
							if @sinkou
								@talk += 1
							end
							if @talk >= 14
								@hero.reset
								@kusa.flatten.each {|kusa| kusa.reset}
								@talk   = 0
								@hyoji  = true
								@sinkou = true
								@syuryo = false
								@ks_i   = 0
								return false
							end
						end
				end
			end
			SDL::Key.scan 
			if SDL::Key.press?(SDL::Key::RIGHT) and !@sinkou and @hero.x <= 680 and !@hero.action
				@hero.muki   = 3
				@hero.hayasa += 1
				@hero.hasiru = true
				@hero.x      += 0.5
			elsif SDL::Key.press?(SDL::Key::LEFT) and !@sinkou and @hero.x >= -40 and !@hero.action
				@hero.muki   = 1
				@hero.hayasa += 1
				@hero.hasiru = true
				@hero.x      -= 0.5
			else
				@hero.hasiru = false
			end

			@hero.press = ""
			if SDL::Key.press?(SDL::Key::C) and !@sinkou
				@hero.press = "c"
			end
			if SDL::Key.press?(SDL::Key::V) and !@sinkou
				@hero.press = "v"
			end
			if SDL::Key.press?(SDL::Key::D) and !@sinkou
				@hero.press = "d"
			end
			if SDL::Key.press?(SDL::Key::X) and @hero.hasiru == false and !@sinkou
				@hero.px = true
			else
				@hero.px = false
			end

			if SDL::Key.press?(SDL::Key::Q)
				@menu.play
				if @menu.sentaku == 1
					@hero.reset
					@kusa.flatten.each {|kusa| kusa.reset}
					@talk   = 0
					@hyoji  = true
					@sinkou = true
					@syuryo = false
					@ks_i   = 0
					return false
				end
			end

			case @talk
				when 4
					if @kusa[0][0].state == 1 and @kusa[0][1].state == 1 and @kusa[0][2].state == 1
						@hyoji  = true
						@sinkou = true
					else
						@hyoji  = false
						@sinkou = false
					end
				when 5
						@ks_i   = 1
						@hero.reset
				when 7
					if @kusa[1][0].state == 1 and @kusa[1][1].state == 1 and @kusa[1][2].state == 1
						@hyoji  = true
						@sinkou = true
					else
						@hyoji  = false
						@sinkou = false
					end
				when 8
						@ks_i   = 2
						@hero.reset
				when 10
					if @kusa[2][0].state == 1 and @kusa[2][1].state == 1 and @kusa[2][2].state == 1
						@hyoji  = true
						@sinkou = true
					else
						@hyoji  = false
						@sinkou = false
					end
				when 11
						@ks_i   = 3
						@hero.reset
				when 13
					if @kusa[3][0].state == 1 and @kusa[3][1].state == 1 and @kusa[3][2].state == 1
						@hyoji  = true
						@sinkou = true
					else
						@hyoji  = false
						@sinkou = false
					end
			end

			@window.showImage(@back,0,0)
			@kusa[@ks_i].each {|kusa| kusa.draw}
			@hero.draw
			@hp.draw
			@kp.draw
			@command.draw
			if @hyoji
				@window.showImage(@bun[@talk],10,445)
			end
			@window.refresh
		end
	end
end
