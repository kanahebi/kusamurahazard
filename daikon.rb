class Daikon
	attr_reader :x, :y
	attr_accessor :x, :y, :dk, :hp, :bx, :b
	def initialize(window,sound,hero,x,y)
		@image    = Array.new()
		3.times {|i| @image[i] = SDL::Surface.load("daikon#{i}.gif")}

		@beam    = Array.new()
		5.times {|i| @beam[i] = SDL::Surface.load("daikonbeam#{i}.gif")}

		@window = window
		@sound  = sound
		@hero   = hero
		@x = @syokix = x
		@y = @syokiy = y
		@dk     = 0
		@tobu   = 0
		@b      = 0
		@hassya = 0
		@kousen = 0
		@hp     = 100
		@bx     = @x - 125
		@koudou = 0
	end

	def draw
		@koudou += 1
		if @hp > 0
			if @hero.hp > 0
				if @x - @hero.x < 175 and @hero.karu and @hero.muki == 3
					if @dk == 0
						@sound.krplay
					end
					@dk   = 1
					@tobu = 1
					@muki = 1
				end

				if @x > 720
					@muki = 0
				end

				if @x - @hero.x > 300 and @x > 400
					if @tobu == 0 and @koudou % 500 == 0
						@tobu = 1
						@muki = -1.5
					end
				end
				if @x - @hero.x < 235 and @koudou % 1000 == 0 and @hassya == 0
					@hassya = 1
				end
				if @tobu == 1
					@x += (0.5 * @muki)
					@y -= 0.5
				end
				if @tobu == 1 and @syokiy - @y > 20
					@tobu = 2
				end
				if @tobu == 2
					@y += 0.5
				end
				if @tobu == 2 and @y == @syokiy
					@tobu = 0
					if @muki != -1.5
						@hp -= 8
					end
				end
				if @tobu == 0
					@dk = 0
				end
			end
		elsif @dk != 2
			@dk = 2
			@x -= 60
			@y += 121
		end
		@window.showImage(@image[@dk],@x,@y)
	end

	def beam
		if @hassya == 1
			if @kousen == 0
				@sound.bmplay
			end
			@kousen += 1
			if @kousen == 20
				@b = 1
			end
			if @kousen == 40
				@b = 2
			end
			if @kousen == 100
				@hassya = 2
			end
		end
		if @hassya == 2
			@kousen -= 1
			if @kousen == 40
				@b = 3
			end
			if @kousen == 20
				@b = 4
			end
			if @kousen == 0
				@b = 0
				@hassya = 0
			end
		end
		if @hassya != 0
			@bx = @x - 125
			@window.showImage(@beam[@b],@bx,@y+65)
		end
	end

	def mdraw
		@window.showImage(@image[@dk],@x,@y)
	end
	def reset
		@x      = @syokix
		@y      = @syokiy
		@dk     = 0
		@hp     = 100
		@koudou = 0
	end
end
