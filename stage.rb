class Game
	attr_accessor :s_hk, :s_nk, :s_mk, :s_kk, :game_over, :kekka, :score
	def initialize(window,sound,menu,no,yml,bgm)
		@yaml   = YAML.load_file(yml)
		@window = window
		@sound  = sound
		@menu   = menu
		@stg_n  = no
		@bgm    = bgm
		@score  = nil
		@time   = -1
		@stg    = "stage#{no}"
		@back   = Back.new(@window)
		@hero   = Hero.new(@window,@sound,324,240)
		@nexts  = Next.new(@window,@hero)
		@hp     = Hp.new(@window,@hero,1,75,50,1,5,0)
		@kp     = Kp.new(@window,@hero,75,70)
		@command= Command.new(@window,@hero,30,505,@yaml[@stg]["comd"])
		@kazu   = Array.new()
		10.times {|i| @kazu[i] = SDL::Surface.load("70_no_#{i}.gif")}
		@back.set(@stg)
	end

	def play
		@sound.bgmplay(@bgm)
		@game_over  = false
		@start_time = Time.now
		while true do
			while event = SDL::Event2.poll do
				case event
					when SDL::Event2::Quit
						exit
					when SDL::Event2::KeyDown
						if event.sym == (SDL::Key::SPACE) and @hero.jmp == 3
							@hero.jmp = 1
						end
						if event.sym == (SDL::Key::Q)
							menu_start = Time.now
							@menu.play
							if @menu.sentaku == 1
								reset
								@score = nil
								return false
							end
							menu_end = Time.now
							@start_time += menu_end - menu_start
						end
						if event.sym == (SDL::Key::Z) and @nexts.hyoji
							reckon
							reset
							return false
						end
					when SDL::Event2::MouseButtonDown
						if event.button == (SDL::Mouse::BUTTON_LEFT)
							grass(event.x,1)
						end
						if event.button == (SDL::Mouse::BUTTON_MIDDLE)
							grass(event.x,2)
						end
						if event.button == (SDL::Mouse::BUTTON_RIGHT)
							grass(event.x,3)
						end
				end
			end

			SDL::Key.scan 
			if SDL::Key.press?(SDL::Key::RIGHT) and @hero.action == nil
				move_right
			elsif SDL::Key.press?(SDL::Key::LEFT) and @hero.action == nil
				move_left
			else
				@hero.hasiru = false
			end

			@hero.press = ""
			if SDL::Key.press?(SDL::Key::C) and @stg_n > 1
				@hero.press = "c"
			end
			if SDL::Key.press?(SDL::Key::V) and @stg_n > 3
				@hero.press = "v"
			end
			if SDL::Key.press?(SDL::Key::D) and @stg_n > 5
				@hero.press = "d"
			end
			if SDL::Key.press?(SDL::Key::X) and @hero.hasiru == false
				@hero.px = true
			else
				@hero.px = false
			end

			draw
			@window.refresh
			if @game_over
				reset
				@score = nil
				return false
			end
		end
	end

	def reckon
		@s_hk = @s_nk = @s_mk = @s_kk = 0
		@kusa[0].each {|kusa| @s_hk += kusa.total}
		@kusa[1].each {|kusa| @s_nk += kusa.total}
		@kusa[2].each {|kusa| @s_mk += kusa.total}
		@kusa[3].each {|kusa| @s_kk += kusa.total}
	end

	def reset
		@back.reset
		@hero.reset
		@kusa.flatten.each {|kusa| kusa.reset}
		@nexts.hyoji = false
	end

	def grass(event_x,kind)
	end

	def time_limit(limit)
		unless @nexts.hyoji
			if limit > 0
				@ten_t = (limit - (Time.now - @start_time - 1)) / 10
				@one_t = (limit - (Time.now - @start_time - 1)) % 10
				@score = Time.now - @start_time
				if limit - (Time.now - @start_time - 1) < 0
					@game_over = true
				end
			elsif Time.now - @start_time < 100
				@ten_t = (Time.now - @start_time) / 10
				@one_t = (Time.now - @start_time) % 10
			end
		end
		@window.showImage(@kazu[@ten_t],387,20)
		@window.showImage(@kazu[@one_t],423,20)
	end
end

class Game_s < Game
	def initialize(window,sound,menu,no)
		super(window,sound,menu,no,"stage_s.yml","run")
		@isi1 = Isi1.new(@window,@sound,@hero,600,422,0)
		@isi2 = Isi1.new(@window,@sound,@hero,1600,419,1)
		@kusa = Array.new(4){|i| Array.new}
		@yaml[@stg]["humu"]["n"].times {|i| @kusa[0][i] = HumuK.new(@window,@sound,@hero,@yaml[@stg]["humu"]["x"][i],445)}
		@yaml[@stg]["karu"]["n"].times {|i| @kusa[1][i] = KaruK.new(@window,@sound,@hero,@yaml[@stg]["karu"]["x"][i],360)}
		@yaml[@stg]["mosu"]["n"].times {|i| @kusa[2][i] = MosuK.new(@window,       @hero,@yaml[@stg]["mosu"]["x"][i],425)}
		@yaml[@stg]["kesu"]["n"].times {|i| @kusa[3][i] = KesuK.new(@window,       @hero,@yaml[@stg]["kesu"]["x"][i],465)}
	end

	def scrl(muki)
		@back.x += 0.5 * muki
		@isi1.x += 0.5 * muki
		@isi2.x += 0.5 * muki
		@kusa.flatten.each {|kusa| kusa.x += 0.5 * muki}
	end

	def move_right
		unless @isi1.tomerum or @isi2.tomerum
			@hero.hayasa += 1
			@hero.muki   = 3
			@hero.hasiru = true
			if @hero.x == @hero.syokix and @back.x > -5600
				scrl(-1)
			elsif @hero.x <= 680
				@hero.x += 0.5
			end
		else
			@hero.hasiru = false
		end
	end

	def move_left
		unless @isi1.tomeruh or @isi2.tomeruh
			@hero.hayasa += 1
			@hero.muki   = 1
			@hero.hasiru = true
			if @hero.x == @hero.syokix and @back.x != 0
				scrl(1)
			elsif @hero.x >= -40
				@hero.x -= 0.5
			end
		else
			@hero.hasiru = false
		end
	end

	def draw
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
		@back.draw
		@isi1.draw
		@isi2.draw
		@kusa.flatten.each {|kusa| kusa.draw}
		@hp.draw
		@hero.draw
		@nexts.draw
		@command.draw
		@kp.draw if @stg_n >= 4
	end

	def reckon
		if @hero.x >= 500
			super
		end
	end


	def reset
		super
		@isi1.reset
		@isi2.reset
	end
end

class Game_w < Game
	def initialize(window,sound,menu,no)
		super(window,sound,menu,no,"stage_w.yml","boss")
		@kekka = false
		@kusa = Array.new(4){|i| Array.new(0,0)}
		@yaml[@stg]["humu"]["n"].times {|i| @kusa[0][i] = HumuK_W.new(@window,@sound,@hero,(rand 730) + 1,445)}
		@yaml[@stg]["karu"]["n"].times {|i| @kusa[1][i] = KaruK_W.new(@window,@sound,@hero,(rand 730) + 1,360)}
		@yaml[@stg]["mosu"]["n"].times {|i| @kusa[2][i] = MosuK_W.new(@window,       @hero,(rand 730) + 1,430)}
		@yaml[@stg]["kesu"]["n"].times {|i| @kusa[3][i] = KesuK_W.new(@window,       @hero,(rand 730) + 1,465)}
	end

	def move_right 
		if  @hero.x <= 680
			@hero.muki   = 3
			@hero.x      += 0.5
			@hero.hayasa += 1
			@hero.hasiru = true
		else
			@hero.hasiru = false
		end
	end

	def move_left
		if @hero.x >= -40
			@hero.muki   = 1
			@hero.x      -= 0.5
			@hero.hayasa += 1
			@hero.hasiru = true
		else
			@hero.hasiru = false
		end
	end

	def draw
		@gk = 0 unless @kekka
		@kusa.flatten.each {|kusa| @gk += kusa.state}
			
		if @gk <= @yaml[@stg]["re"]
			@kusa.flatten.each {|kusa| kusa.reborn}
		elsif @gk == @kusa.flatten.length
			unless @kekka
				@sound.winplay
			end
			@kekka = true
		end

		@back.draw
		@kusa.flatten.each {|kusa| kusa.draw}
		@hero.draw
		@command.draw
		@hp.draw
		@kp.draw
		@nexts.bdraw if @kekka
	end

	def reckon
		if @kekka
			super
		end
	end

	def reset
		super
		@gk    = 0
		@kekka = false
	end
end

class Game_syori < Game_s
	def initialize(window,sound,menu,no,syo,riv)
		super(window,sound,menu,no)
		@riv = riv
		@syori = 0
		@syoritai    = Array.new
		@syoritai[0] = Syoritai.new(@window,@sound,@kusa,   -1400,315,1)
		@syoritai[1] = Syoritai.new(@window,@sound,@kusa[0],-1300,315,2) if syo >= 2
		@syoritai[2] = Syoritai.new(@window,@sound,@kusa[1],-1200,315,3) if syo >= 3
		@syoritai[3] = Syoritai.new(@window,@sound,@kusa[2],-1100,315,4) if syo >= 4
		@syoritai[4] = Syoritai.new(@window,@sound,@kusa[3],-1000,315,5) if syo >= 5
		@rival = Rival.new(@window,@sound,@kusa,8000,240,5)              if @riv
		@bar   = Bar.new(@window,@back,@hero,@syoritai,@rival,@kusa)
	end

	def scrl(muki)
		super
		@rival.x += 0.5 * muki                           if @riv
		@rival.rivalk.each {|kusa| kusa.x += 0.5 * muki} if @riv
		@syoritai.each do |syoritai|
			syoritai.syori_k.x += 0.5 * muki if syoritai.syori_k
			syoritai.x         += 0.5 * muki
		end
	end

	def draw
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
		@back.draw
		@isi1.draw
		@isi2.draw
		@rival.rivalk.each {|kusa| kusa.draw} if @riv
		@kusa.flatten.each {|kusa| kusa.draw}
		@rival.draw                           if @riv
		@hp.draw
		@hero.draw
		@syoritai.each {|syoritai| syoritai.draw}
		@nexts.draw if @syoritai[0].x > 750
		@command.draw
		@kp.draw if @stg_n >= 4
		@bar.draw
	end

	def reckon
		@syori = 0
		@syoritai.each {|syoritai| @syori += syoritai.count}
		@suzuki = 0
		@kusa.flatten.each {|kusa| @suzuki += 1 if kusa.state <= 2}
		@game_over = true if @riv == false and @syori <= @kusa.flatten.length * 0.6
		@game_over = true if @riv and @syori  <= @suzuki * 0.6
		@game_over = true if @riv and @suzuki <= @rival.rivalk.length
		@game_over = true if @riv and @kusa.flatten.length * 0.6 <= @rival.rivalk.length
		super
	end

	def reset
		super
		@rival.reset  if @riv
		@syoritai.each {|syoritai| syoritai.reset}
	end
end

class Game_challenge < Game_w
	def initialize(window,sound,menu,time,*volume)
		super(window,sound,menu,6)
		@sumi = [0,0,0,0,0]
		@mi   = [0,0,0,0,0]
		@time = time
		@vol  = volume[0] + volume[1] + volume[2] + volume[3]
		@volume = volume
		@ten_k = @one_k = @hnd_k = 0
		@rest = SDL::Surface.load("rest.gif")
		@kusa = Array.new(4){|i| Array.new(0,0)}
		vol_calc(volume[0]).times {|i| @kusa[0][i] = HumuK_W.new(@window,@sound,@hero,(rand 730) + 1,445)}
		vol_calc(volume[1]).times {|i| @kusa[1][i] = KaruK_W.new(@window,@sound,@hero,(rand 730) + 1,360)}
		vol_calc(volume[2]).times {|i| @kusa[2][i] = MosuK_W.new(@window,       @hero,(rand 730) + 1,430)}
		vol_calc(volume[3]).times {|i| @kusa[3][i] = KesuK_W.new(@window,       @hero,(rand 730) + 1,465)}
	end

	def vol_calc(volume)
		if volume < 10
			return volume
		else
			return 10
		end
	end

	def kusa_total
		if @vol - @sumi[4] > 0
			@ten_k = (@vol - @sumi[4]) / 10
			@one_k = (@vol - @sumi[4]) % 10
			@hnd_k = 0
		else
			@one_k = 0
		end
		@hnd_k = @ten_k / 10
		@ten_k = @ten_k % 10 if @ten_k > 9
		@window.showImage(@rest        ,600,518)
		@window.showImage(@kazu[@hnd_k],670,505) if @hnd_k > 0
		@window.showImage(@kazu[@ten_k],698,505)
		@window.showImage(@kazu[@one_k],726,505)
	end

	def draw
		unless @kekka
			@sumi = [0,0,0,0,0]
			@mi   = [0,0,0,0,0]
			@kusa.each_with_index do |kusa,i|
				kusa.each do |k|
					@sumi[i] += k.total
					@mi[i]   += 1 if k.state == 0
				end
				kusa.each do |k|
					k.reborn if @sumi[i] + @mi[i] < @volume[i]
					k.reborn if @sumi[i] + @mi[i] < @volume[i] and @mi[i] < i+2
				end
			end
			@sumi[4] = @sumi[0] + @sumi[1] + @sumi[2] + @sumi[3]
			@mi[4]   = @mi[0] + @mi[1] + @mi[2] + @mi[3]
		end
		if @sumi[4] >= @vol
			@kusa.flatten.each {|kusa| kusa.img = kusa.kusa.length-1}
			unless @kekka
				@sound.winplay
			end
			@kekka = true
		end

		@back.draw
		@kusa.flatten.each {|kusa| kusa.draw}
		@hero.draw
		@command.draw
		@hp.draw
		@kp.draw
		@nexts.bdraw if @kekka
		kusa_total
		time_limit(@time)
	end

	def reckon
		if @kekka
			super
		end
	end

	def reset
		super
		@sumi = [0,0,0,0,0]
		@mi   = [0,0,0,0,0]
		@kekka = false
	end
end

class Game_match < Game_w
	def initialize(window,sound,menu,no)
		super(window,sound,menu,no)
		@time = 30
		@humu = @kusa[0].length
		@karu = @kusa[1].length
		@mosu = @kusa[2].length
		@kesu = @kusa[3].length
	end

	def draw
		@back.draw
		@kusa.flatten.each {|kusa| kusa.draw}
		@hero.draw
		@nexts.bdraw if @kekka
		@gk = 0 unless @kekka
		@kusa.flatten.each {|kusa| @gk += kusa.state}
		if @gk <= @kusa.flatten.length * 0.6
			@kusa.flatten.each do |kusa|
				kusa = nil if kusa.class.superclass == Kusa and kusa.state != 0
				next if kusa.class.superclass == Kusa or !kusa
				kusa.reborn
			end
		end
		if @gk == @kusa.flatten.length
			unless @kekka
				@sound.winplay
			end
			@kekka = true
		end
		@command.draw
		@hp.draw
		@kp.draw
		time_limit(@time)
	end

	def grass(event_x,kind)
		rare = rand 10
		if rare == 0
			@kusa[0] << HumuK_W.new(@window,@sound,@hero,event_x,445)
		else
			case kind
				when 1
					@kusa[1] << KaruK.new(@window,@sound,@hero,event_x,360)
				when 2
					@kusa[2] << MosuK.new(@window,       @hero,event_x,430)
				when 3
					@kusa[3] << KesuK.new(@window,       @hero,event_x,465)
			end
		end
	end

	def reset
		super
		@time = 30
		@kusa[0].each_with_index {|kusa,i| kusa = nil if i >= @humu}
		@kusa[1].each_with_index {|kusa,i| kusa = nil if i >= @karu}
		@kusa[2].each_with_index {|kusa,i| kusa = nil if i >= @mosu}
		@kusa[3].each_with_index {|kusa,i| kusa = nil if i >= @kesu}
	end
end

class Game_custom < Game
	def initialize(window,sound,menu,no,yml,bgm)
		super
		@time = @data["time"]
	end

	def draw
		@hp.draw
		@command.draw
		@kp.draw
		time_limit(@time)
	end
end

class Game_cs < Game_custom
	def initialize(window,sound,menu,data)
		@data = data
		super(window,sound,menu,9,"stage_s.yml","run")
		@kusa = Array.new(4){|i| Array.new}
		@data["humu"].times {|i| @kusa[0][i] = HumuK.new(@window,@sound,@hero,(rand 730) + 800 * (i%8),445)}
		@data["karu"].times {|i| @kusa[1][i] = KaruK.new(@window,@sound,@hero,(rand 730) + 800 * (i%8),360)}
		@data["mosu"].times {|i| @kusa[2][i] = MosuK.new(@window,       @hero,(rand 730) + 800 * (i%8),430)}
		@data["kesu"].times {|i| @kusa[3][i] = KesuK.new(@window,       @hero,(rand 730) + 800 * (i%8),465)}
		@isi1 = Isi1.new(@window,@sound,@hero,600,422,0)
		@isi2 = Isi1.new(@window,@sound,@hero,1600,419,1)
		
		@syoritai    = Array.new
		@syoritai[0] = Syoritai.new(@window,@sound,@kusa,   -1400,315,1) if @data["syori"] >= 1
		@syoritai[1] = Syoritai.new(@window,@sound,@kusa[0],-1300,315,2) if @data["syori"] >= 2
		@syoritai[2] = Syoritai.new(@window,@sound,@kusa[1],-1200,315,3) if @data["syori"] >= 3
		@syoritai[3] = Syoritai.new(@window,@sound,@kusa[2],-1100,315,4) if @data["syori"] >= 4
		@syoritai[4] = Syoritai.new(@window,@sound,@kusa[3],-1000,315,5) if @data["syori"] >= 5
		@rival = Rival.new(@window,@sound,@kusa,7000,240,5) if @data["rival"]
		@bar   = Bar.new(@window,@back,@hero,@syoritai,@rival,@kusa)
	end

	def scrl(muki)
		@back.x += 0.5 * muki
		@isi1.x += 0.5 * muki
		@isi2.x += 0.5 * muki
		@kusa.flatten.each {|kusa| kusa.x += 0.5 * muki}
		if @data["rival"]
			@rival.x += 0.5 * muki
			@rival.rivalk.each {|kusa| kusa.x += 0.5 * muki}
		end
		if @data["syori"] >= 1
			@syoritai.each do |syoritai|
				syoritai.syori_k.x += 0.5 * muki if syoritai.syori_k
				syoritai.x         += 0.5 * muki
			end
		end
	end

	def move_right
		unless @isi1.tomerum or @isi2.tomerum
			@hero.hayasa += 1
			@hero.muki   = 3
			@hero.hasiru = true
			if @hero.x == @hero.syokix and @back.x > -5600
				scrl(-1)
			elsif @hero.x <= 680
				@hero.x += 0.5
			end
		else
			@hero.hasiru = false
		end
	end

	def move_left
		unless @isi1.tomeruh or @isi2.tomeruh
			@hero.hayasa += 1
			@hero.muki   = 1
			@hero.hasiru = true
			if @hero.x == @hero.syokix and @back.x != 0
				scrl(1)
			elsif @hero.x >= -40
				@hero.x -= 0.5
			end
		else
			@hero.hasiru = false
		end
	end

	def draw
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

		@back.draw
		@isi1.draw
		@isi2.draw
		@rival.rivalk.each {|kusa| kusa.draw} if @data["rival"]
		@kusa.flatten.each {|kusa| kusa.draw}
		@rival.draw                           if @data["rival"]
		@hero.draw
		@syoritai.each {|syoritai| syoritai.draw}
		@nexts.draw
		@bar.draw
		super
	end

	def reset
		super
		@rival.reset if @data["rival"]
		@syoritai.each {|syoritai| syoritai.reset}
		@isi1.reset
		@isi2.reset
	end
end

class Game_cw < Game_custom
	def initialize(window,sound,menu,data)
		@data = data
		super(window,sound,menu,6,"stage_w.yml","boss")
		@kusa = Array.new(4){|i| Array.new}
		@data["humu"].times {|i| @kusa[0][i] = HumuK_W.new(@window,@sound,@hero,(rand 730) + 1,445)}
		@data["karu"].times {|i| @kusa[1][i] = KaruK_W.new(@window,@sound,@hero,(rand 730) + 1,360)}
		@data["mosu"].times {|i| @kusa[2][i] = MosuK_W.new(@window,       @hero,(rand 730) + 1,430)}
		@data["kesu"].times {|i| @kusa[3][i] = KesuK_W.new(@window,       @hero,(rand 730) + 1,465)}
		@kekka = false
	end

	def move_right
		if  @hero.x <= 680
			@hero.muki   = 3
			@hero.x      += 0.5
			@hero.hayasa += 1
			@hero.hasiru = true
		else
			@hero.hasiru = false
		end
	end

	def move_left
		if @hero.x >= -40
			@hero.muki   = 1
			@hero.x      -= 0.5
			@hero.hayasa += 1
			@hero.hasiru = true
		else
			@hero.hasiru = false
		end
	end

	def draw
		@back.draw
		@kusa.flatten.each {|kusa| kusa.draw}
		@hero.draw
		@nexts.bdraw if @kekka
		super
		@gk = 0 unless @kekka
		@kusa.flatten.each {|kusa| @gk += kusa.state}
		if @gk <= @kusa.flatten.length * 0.6
			@kusa.flatten.each {|kusa| kusa.reborn}
		end
		if @gk == @kusa.flatten.length
			unless @kekka
				@sound.winplay
			end
			@kekka = true
		end
	end

	def grass(event_x,kind)
		rare = rand 10
		if rare == 0
			@kusa[0] << HumuK_W.new(@window,@sound,@hero,event_x,445)
		else
			case kind
				when 1
					@kusa[1] << KaruK_W.new(@window,@sound,@hero,event_x,360)
				when 2
					@kusa[2] << MosuK_W.new(@window,       @hero,event_x,430)
				when 3
					@kusa[3] << KesuK_W.new(@window,       @hero,event_x,465)
			end
		end
	end

	def reset
		super
		@kusa[0].each_with_index {|kusa,i| kusa = nil if i >= @data["humu"]}
		@kusa[1].each_with_index {|kusa,i| kusa = nil if i >= @data["karu"]}
		@kusa[2].each_with_index {|kusa,i| kusa = nil if i >= @data["mosu"]}
		@kusa[3].each_with_index {|kusa,i| kusa = nil if i >= @data["kesu"]}
		@gk    = 0
		@kekka = false
	end
end
