class Isi1
	attr_reader :x, :y
	attr_accessor :x, :tomeruh, :tomerum, :noru, :noruy, :oisinoru, :noru
	def initialize(window,sound,hero,x,y,isn)
		@isi    = Array.new()
		2.times {|i| @isi[i] = SDL::Surface.load("isi#{i}.gif")}

		@window = window
		@sound  = sound
		@hero   = hero
		@x = @syokix = x
		@y = @syokiy = y
		@tomeruh  = false
		@tomerum  = false
		@oisinoru = false
		@noru     = false
		@noruy    = @hero.y
		@isn      = isn
	end

	def draw
		if @x - @hero.x <= 100 and @x - @hero.x >= -50 and @hero.muki == 3 and @hero.y == @hero.syokiy
			unless @tomerum
				@noruy = @hero.y
			end
			@tomerum = true
		else
			@tomerum = false
		end
		if @x - @hero.x <= 100 and @x - @hero.x >= -50 and @hero.muki == 1 and @hero.y == @hero.syokiy
			unless @tomeruh
				@noruy = @hero.y
			end
			@tomeruh = true
		else
			@tomeruh = false
		end

		if @x - @hero.x < 100 and @x - @hero.x > -50 and @hero.muki == 3
			@norum = true
		else
			@norum = false
		end
		if @x - @hero.x < 100 and @x - @hero.x > -50 and @hero.muki == 1
			@noruh = true
		else
			@noruh = false
		end


		if @norum or @noruh
			@noru = true
			if @hero.jmp == 3
				@hero.y = @noruy - 50
			end
		elsif @hero.jmp == 3 and !@oisinoru
			@hero.y = @noruy
			@noru   = false
		end
		 @window.showImage(@isi[@isn],@x,@y)
	end

	def reset
		@x  = @syokix
		@y  = @syokiy
		@nk = 0
	end
end
