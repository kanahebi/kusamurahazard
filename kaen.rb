class Kp
	attr_reader :x, :y
	attr_accessor :x, :y
	def initialize(window,hero,x,y)
		@image     = Array.new()
		@image[0]  = SDL::Surface.load("kwaku.gif")
		@image[1]  = SDL::Surface.load("k1.gif")
		@image[5]  = SDL::Surface.load("k5.gif")
		@image[10] = SDL::Surface.load("k10.gif")
		@image[50] = SDL::Surface.load("k50.gif")

		@window = window
		@hero   = hero
		@x = @syokix = x
		@y = @syokiy = y
	end

	def draw
		@kp = @hero.kp
		keisan
		@window.showImage(@image[0],@x-1,@y-1)
	end

	def reset
		@x = @syokix
		@y = @syokiy
	end
	def keisan
		@ten = @kp / 10
		@one = @kp % 10

		keisan2(0,        20,10,@ten,0)
		keisan2(@ten * 20,2,  1,@one,1)
	end

	def keisan2(x1,x2,kurai,atai,tasu)
		@tasu1 = x1
		@tasu2 = x2
		@kurai = kurai
		@atai  = atai
		@tasu3 = 0
		@tasu4 = tasu
		if @kp >= 0
			if @atai >= 5
				@window.showImage(@image[5*@kurai],@x + @tasu1,@y)
				@atai -= 5
				@tasu3 = 10 * @kurai
			end
			if @atai >= 5
					@window.showImage(@image[5*@kurai],@x + @tasu3,@y)
			else
				if @atai >= 1
					@window.showImage(@image[1*@kurai],@x + @tasu1              + @tasu3,@y)
				end
				if @atai >= 2
					@window.showImage(@image[1*@kurai],@x + @tasu1 + @tasu2     + @tasu3,@y)
				end
				if @atai >= 3
					@window.showImage(@image[1*@kurai],@x + @tasu1 + @tasu2 * 2 + @tasu3,@y)
				end
				if @atai >= 4
					@window.showImage(@image[1*@kurai],@x + @tasu1 + @tasu2 * 3 + @tasu3,@y)
				end
			end
		end
	end
end
