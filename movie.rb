class Movie
	def initialize(window,sound,no,img)
		@yaml   = YAML.load_file("movie.yml")
		@window = window
		@sound  = sound
		@talk_m = @yaml["movie_#{no}"]["bun"]
		@haikei = Array.new
		@yaml["movie_#{no}"]["haikei"].length.times {|i| @haikei[i] = SDL::Surface.load(@yaml["movie_#{no}"]["haikei"][i])}
		@bun    = Array.new()
		@yaml["movie_#{no}"]["bun"].times {|i| @bun[i] = SDL::Surface.load("#{img}#{i}.png")}
		@talk  = 0
		@sean  = 0
		@img_x = 0
		@hyoji = true
		@sinko = true
		@close = false
	end

	def play
		@sound.bgmplay("talk")
		while true do
			while event = SDL::Event2.poll do
				case event
					when SDL::Event2::Quit
						exit
					when SDL::Event2::KeyDown
						if event.sym == (SDL::Key::SPACE)
							space_event
						end
						if event.sym == (SDL::Key::Z)
							reset
							return false
						end
				end
			end

			if @close
				reset
				return false
			end

			@window.showImage(@haikei[@sean],@img_x,0)
			draw
			if @hyoji
				@window.showImage(@bun[@talk],10,445)
			end
			@window.refresh
		end
	end

	def space_event
		if @sinko
			@talk += 1
		end
		if @talk == @talk_m
			@close = true
		end
	end

	def run_flag(flag)
		@hero.hasiru = flag
		@sinko = !flag
		@hyoji = !flag
	end

	def suzuki_run(muki,muki2)
		run_flag(true)
		@hero.muki   = muki
		@hero.x      += 0.5 * muki2
		@hero.hayasa += 1
	end

	def reset
		@talk  = 0
		@sean  = 0
		@img_x = 0
		@close = false
		@sinko = true
		@hyoji = true
	end
end

class Movie_1 < Movie
	def initialize(window,sound,no,img)
		super
		@hero = Hero.new(@window,@sound,900,279)
		@kusa = HumuK.new(@window,@sound,@hero,342,421)
		@ie   = SDL::Surface.load("ieie3.gif")
	end

	def draw
		case @talk
			when 1, 2, 3, 4, 5 ,6, 7, 8, 10
				@sean = @talk
			when 15 
				@sean = 11
			when 16 
				@sean = 12
			when 17 
				@sean = 7
		end
		if @sean == 9
			@kusa.draw
		end
		if @sean == 10
			@hero.syokiy = @hero.y
			@kusa.draw
		end
		if @sean != 12
			@hero.draw
		end
		case @talk
			when 8
				if @hero.x >= 400
					suzuki_run(1,-1)
					@window.showImage(@ie,0,0)
				else
					run_flag(false)
				end
			when 9
				if @sean == 8
					if @hero.x > -200
						suzuki_run(1,-1)
					else
						run_flag(false)
						@hero.x = 800
						@hero.y = 224
						@sean   = 9
					end
				end
				if @sean == 9
					if @hero.x > 92
						suzuki_run(1,-1)
					else
						run_flag(false)
					end
				end
			when 12
				if @hero.x < 280
					suzuki_run(3,1)
				else
					run_flag(false)
				end
			when 14
				if @hero.x < 800 and @sean != 12
					suzuki_run(3,1)
				else
					run_flag(false)
					@sean   = 12
					@hero.x = 280
					@hero.y = 279
				end
		end
	end

	def reset
		super
		@hero.syokiy = 279
		@hero.reset
		@kusa.reset
	end
end

class Movie_2 < Movie
	def initialize(window,sound,no,img)
		super
		@hero = Hero.new(@window,@sound,-150,380)
		@sita = SDL::Surface.load("wata.gif")
	end

	def space_event
		if @sinko
			@talk += 1
		end
	end

	def draw
		case @talk
			when 1
				if @hero.x <= 200
					suzuki_run(3,1)
				else
					run_flag(false)
				end
			when 2
				if @hero.x <= 800
					suzuki_run(3,1)
				else
					run_flag(false)
				end
			when 3
				if @hero.x >= 200
					suzuki_run(1,-1)
					@hero.press = "c"
				else
					run_flag(false)
				end
			when 4
				if @hero.x >= -150
					suzuki_run(1,-1)
					@hero.press = "c"
				else
					@close = true
				end
		end
		@hero.draw
		@window.showImage(@sita,0,0)
	end

	def reset
		super
		@hero.reset
	end
end

class Movie_3 < Movie
	def initialize(window,sound,no,img)
		super
		@hero   = Hero.new(@window,@sound,900,240)
		@daikon = Daikon.new(@window,@sound,@hero,656,444)
		@kusa   = Array.new
		4.times {|i| @kusa[i] = HumuK.new(@window,@sound,@hero,400+i*64,445)}
		@sita     = SDL::Surface.load("sita.gif")
		@sizumu   = 0
		@detekuru = 0
	end

	def draw
		if @hero.x == 616
			@sizumu = 1
		end
		if @sizumu == 1
			@daikon.y += 0.5
			if @daikon.y == 484
				@sizumu = 2
			end
		end
		if @sizumu == 2
			@daikon.y -= 0.5
			if @daikon.y == 444
				@sizumu = 3
			end
		end
		if @detekuru == 1
			if @daikon.y >= 300
				@daikon.y -= 1
			else
				@sinko    = true
				@talk     = 4
				@detekuru = 0
			end
		end
		case @talk
			when 1
				if @hero.x >= 200
					suzuki_run(1,-1)
				else
					run_flag(false)
				end
			when 3
				@detekuru = 1
			when 4
				@daikon.dk = 1
			when 6
				@daikon.dk = 0
		end
		@kusa.each {|kusa| kusa.draw}
		@daikon.mdraw
		@hero.draw
		@window.showImage(@sita,0,0)
	end

	def reset
		super
		@sizumu   = 0
		@detekuru = 0
		@hero.reset
		@daikon.reset
		@kusa.each {|kusa| kusa.reset}
	end
end

class Movie_4 < Movie
	def draw
		case @talk
		 	when 3, 17
				@sean = 1
		 	when 5, 14
				@sean = 2
		 	when 6
				@sean = 3
		 	when 8
				@sean = 4
		 	when 12
				@sean = 5
		 	when 18
				@sean = 0
		end
	end
end

class Movie_5 < Movie
	def initialize(window,sound,no,img)
		super
		@hero = Hero.new(@window,@sound,-300,240)
		@kusa = Array.new
		0.upto(8)   {|i| @kusa[i] = HumuK.new(@window,@sound,@hero,100 +i*30,     445)}
		9.upto(18)  {|i| @kusa[i] = HumuK.new(@window,@sound,@hero,1500+(i- 9)*60,445)}
		19.upto(32) {|i| @kusa[i] = MosuK.new(@window,       @hero,400 +(i-19)*30,415)}
		33.upto(41) {|i| @kusa[i] = MosuK.new(@window,       @hero,800 +(i-33)*20,415)}
		42.upto(49) {|i| @kusa[i] = MosuK.new(@window,       @hero,1000+(i-42)*60,415)}
		@kusa[50] = KaruK.new(@window,@sound,@hero,1400,360)
		@buta = Buta.new(@window,@hero,@sound,560,233)
		@ue   = SDL::Surface.load("monooki2.gif")
		@bu   = SDL::Surface.load("bu2.gif")
	end

	def draw
		@window.showImage(@haikei[1],@img_x+800, 0)
		@window.showImage(@haikei[2],@img_x+1600,0)
		if @talk > 5 and @talk < 15
			@window.showImage(@bu,@img_x+574,368)
		end
		@kusa.each {|kusa| kusa.draw}
		@hero.draw
		case @talk
			when 1
				if @hero.x <= 324
					suzuki_run(3,1)
				else
					run_flag(false)
				end
			when 2
				if @img_x > -1600
					run_flag(true)
					@hero.muki    = 3
					@hero.hayasa += 1
					@img_x       -= 0.5
					@kusa.each {|kusa| kusa.x -= 0.5}
				elsif @hero.x < 800
					suzuki_run(3,1)
					@window.showImage(@ue,0,0)
				else
					run_flag(false)
				end
			when 4
				@hero.press = "v"
				if @hero.x >= 324
					suzuki_run(1,-1)
					@window.showImage(@ue,0,0)
				elsif @img_x < -1400
					@hero.muki    = 1
					@hero.hayasa += 1
					@img_x       += 0.5
					@kusa.each {|kusa| kusa.x += 0.5}
				else
					@hero.hasiru = false
					if @kusa[49].img >= 4
						@hero.px = false
						if @hero.hi_img == 6
							run_flag(false)
						end
					else
						@hero.kp = 100
						@hero.px = true
					end
				end
			when 6
				if @img_x <= 0
					run_flag(true)
					@hero.px     = true
					@hero.hassya = 1
					@hero.muki   = 1
					@hero.kp     = 100
					@hero.hayasa += 1
					@img_x       += 0.5
					@kusa.each {|kusa| kusa.x += 0.5}
				elsif @hero.x >= 120
					suzuki_run(1,-1)
				else
					@hero.px = false
					run_flag(false)
				end
			when 9
				@hero.muki = 3
		end
		if @talk > 14
			@buta.draw
		end 
	end

	def reset
		super
		@kusa.each {|kusa| kusa.reset}
		@hero.reset
		@buta.reset
	end
end

class Movie_6 < Movie
	def draw
		case @talk
		 	when 3
				@sean = 1
		 	when 5
				@sean = 2
		 	when 7
				@sean = 3
		 	when 9, 12, 14
				@sean = 4
		 	when 11
				@sean = 5
		 	when 13
				@sean = 6
		end
	end
end

class Movie_7 < Movie
	def initialize(window,sound,no,img)
		super
		@hero = Hero.new(@window,@sound,-150,356)
	end

	def space_event
		if @sinko
			@talk += 1
		end
	end

	def draw
		case @talk
		 	when 1
				if @hero.x < 300
					suzuki_run(3,1)
				else
					run_flag(false)
				end
		 	when 2
				if @hero.x < 800
					suzuki_run(3,1)
				else
					run_flag(false)
					@hero.press  = "d"
				end
		 	when 5
				if @hero.x > 300
					suzuki_run(1,-1)
				else
					run_flag(false)
				end
		 	when 6
				@hero.muki = 3
		 	when 8
				if @hero.x > -150
					suzuki_run(1,-1)
				else
					@close = true
				end
		end
		@hero.draw
		@window.showImage(@haikei[1],0,0)
	end

	def reset
		super
		@hero.reset
	end
end

class Movie_8 < Movie
	def initialize(window,sound,no,img)
		super
		@hero = Hero.new(@window,@sound,800,240)
		@john = SDL::Surface.load("john.gif")
		@bagi = SDL::Surface.load("bagik.gif")
	end

	def draw
		if @talk == 1
			@hyoji = false
			@sinko = false
			@hero.press= "d"
			if @hero.x >= 580
				suzuki_run(1,-1)
			else
				run_flag(false)
			end
		end
		@window.showImage(@john,65,253)
		@hero.draw
		@window.showImage(@bagi,178,300)
	end

	def reset
		super
		@hero.reset
	end
end


class Movie_9 < Movie
	def initialize(window,sound,no,img)
		super
		@john   = SDL::Surface.load("john.gif")
		@bou    = Array.new()
		@bou[0] = SDL::Surface.load("hbou3.gif")
		@bou[1] = SDL::Surface.load("bagibou.gif")
		@bagi   = Array.new()
		12.times {|i| @bagi[i] = SDL::Surface.load("bagi#{i}.gif")}
		@bax = 350
		@box = 580
		@boy = 240
		@bat = 0
		@ba  = 0
		@bo  = 0
	end

	def space_event
		if @talk <= 3
			@talk += 1
		end
	end

	def draw
		if @talk >= 4
			@hyoji = false
			@bax  -= 0.5
			@bat  += 1
			if @bat % 100 == 0
				@ba += 1
			end
		end
		if @ba > 11
			@ba = 1
		end
		if @talk >= 2
			@bo  = 1
			@boy = 197.5
			@box = @bax
		end
		@window.showImage(@john,65,253)
		@window.showImage(@bagi[@ba],@bax,300)
		@window.showImage(@bou[@bo],@box,@boy)
		if @bax <= -500
			@close = true
		end
	end

	def reset
		super
		@bax = 350
		@box = 580
		@boy = 240
		@bat = 0
		@ba  = 0
		@bo  = 0
	end
end

class Movie_10 < Movie
	def draw
		case @talk
		 	when 3
				@sean = 1
		 	when 4
				@sean = 2
		 	when 5
				@sean = 0
		 	when 6
				@sean = 3
		 	when 8
				@sean = 4
		 	when 11
				@sean = 5
		end
	end
end

class Movie_2_1 < Movie
	def draw
		case @talk
		 	when 1, 2, 3
				@sean = @talk
		 	when 5
				@sean = 4
		end
	end
end

class Movie_2_2 < Movie
	def initialize(window,sound,no,img)
		super
		kusa = Array.new
		@hero     = Hero.new(@window,@sound,-100,240)
		@syoritai = Syoritai.new(@window,@sound,kusa,-100,315,1)
		@syori_h  = SDL::Surface.load("syoritai_h.gif")
	end

	def draw
		case @talk
		 	when 1, 2
				@sean = @talk
		 	when 10
				@sean = 3
		 	when 12
				@sean = 4
		 		if @syoritai.x <= 490
					@sinko = false
					@hyoji = false
		 			@syoritai.hasiru = true
		 		else
		 			@syoritai.hasiru = false
					@sinko = true
					@hyoji = true
				end
				@syoritai.draw
			when 13
				if @hero.x <= 130
					suzuki_run(3,1)
				else
					run_flag(false)
				end

		end
		if @talk >= 13
			@hero.draw
			@window.showImage(@syori_h,@syoritai.x-40,@syoritai.y)
		end
	end

	def reset
		super
		@hero.reset
		@syoritai.reset
	end
end

class Movie_2_3 < Movie
	def draw
		case @talk
		 	when 2
				@sean = 1
			when 5
				@sean = 2
		end
	end
end

class Movie_2_4 < Movie
	def draw
		case @talk
		 	when 2
				@sean = 1
			when 5
				@sean = 2
		end
	end
end

class Movie_2_5 < Movie
	def draw
		@sean = 1 if @talk == 5
	end
end

class Movie_2_6 < Movie
	def draw
		@sean = 1 if @talk == 2
	end
end
