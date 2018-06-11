class Hp
	def initialize(window,char,kaoi,x,y,seihu,kaox,w)
		@waku    = Array.new()
		@waku[0] = SDL::Surface.load("waku.gif")
		@waku[1] = SDL::Surface.load("waku2.gif")

		@image     = Array.new()
		@image[0]  = SDL::Surface.load("waku.gif")
		@image[1]  = SDL::Surface.load("1.gif")
		@image[5]  = SDL::Surface.load("5.gif")
		@image[10] = SDL::Surface.load("10.gif")
		@image[50] = SDL::Surface.load("50.gif")

		@kao    = Array.new()
		@kao[1] = SDL::Surface.load("kao1.gif")
		@kao[2] = SDL::Surface.load("kao2.gif")
		@kao[3] = SDL::Surface.load("kao3.gif")

		@window = window
		@char   = char
		@x = @syokix = x
		@y = @syokiy = y
		@kaox  = kaox
		@kaoi  = kaoi
		@seihu = seihu
		@w     = w
	end

	def draw
		@hp = @char.hp
		keisan
		@window.showImage(@kao[@kaoi],@kaox,5)
		@window.showImage(@waku[@w]  , @x-1,@y-1)
	end

	def reset
		@x = @syokix
		@y = @syokiy
	end
	def keisan
		@ten = @hp / 10
		@one = @hp % 10


		if @w == 0
			keisan2(        0,30,10,@ten,0)
			keisan2(@ten * 30, 3, 1,@one,1)
		else
			keisan3(        0,30,10,@ten,0)
			keisan3(@ten * 30, 3, 1,@one,1)
		end
	end

	def keisan3(x1,x2,kurai,atai,tasu)
		@tasu1 = x1
		@tasu2 = x2
		@kurai = kurai
		@atai  = atai
		@tasu3 = 0
		@tasu4 = tasu
		if @hp >= 0
			if @atai >= 5
				@window.showImage(@image[5*@kurai],@x - 2 + ((100 - 5 * @kurai) * 3 - @tasu1),@y)
				@atai -= 5
				@tasu3 = 15 * @kurai
			end
			if @atai >= 5
					@window.showImage(@image[5*@kurai],@x - 2 + ((100 - 5 * @kurai) * 3) - @tasu3 - @tasu1,@y)
			else
				if @atai >= 1
					@window.showImage(@image[1*@kurai],@x - 2 + ((100 - 1 * @kurai) * 3) - @tasu3 - @tasu1,@y)
				end
				if @atai >= 2
					@window.showImage(@image[1*@kurai],@x - 2 + ((100 - 2 * @kurai) * 3) - @tasu3 - @tasu1,@y)
				end
				if @atai >= 3
					@window.showImage(@image[1*@kurai],@x - 2 + ((100 - 3 * @kurai) * 3) - @tasu3 - @tasu1,@y)
				end
				if @atai >= 4
					@window.showImage(@image[1*@kurai],@x - 2 + ((100 - 4 * @kurai) * 3) - @tasu3 - @tasu1,@y)
				end
			end
		end
	end

	def keisan2(x1,x2,kurai,atai,tasu)
		@tasu1 = x1
		@tasu2 = x2
		@kurai = kurai
		@atai  = atai
		@tasu3 = 0
		@tasu4 = tasu
		if @hp >= 0
			if @atai >= 5
				@window.showImage(@image[5*@kurai],@x + @tasu1,@y)
				@atai -= 5
				@tasu3 = 15 * @kurai
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
