class Command
	attr_reader :x, :y
	attr_accessor :x, :y, :com, :use, :ugk
	def initialize(window,hero,x,y,c)
		@imagec = Array.new()
		@imageu = Array.new()
		@imagek = Array.new()
		9.times {|i| @imagec[i] = SDL::Surface.load("tool#{i}.gif")}
		3.times {|i| @imageu[i] = SDL::Surface.load("use#{i}.gif") }
		7.times {|i| @imagek[i] = SDL::Surface.load("move#{i}.gif")}

		@menu = SDL::Surface.load("menu.gif")

		@window = window
		@hero   = hero
		@x = @syokix = x
		@y = @syokiy = y
		@c = c
	end

	def draw
		unless @hero.press == ""
			@com = @c + 1
			@use = 0
			if @hero.px
				@ugk = 6
				@use = 1
			end
		else
			@com = @c
			@use = 1
		end
		if @hero.hasiru
			@use = 1
			@ugk = 1 if @hero.muki == 3
			@ugk = 2 unless @hero.muki == 3
		else
			@ugk = 0
		end
		if @hero.jmp != 3
			@ugk += 3
			@use = 1
		end
		@use = 2 if @c == 8

		@window.showImage(@imagec[@com],@x,@y)
		@window.showImage(@imageu[@use],@x,@y+30)
		@window.showImage(@imagek[@ugk],@x,@y+60)
		@window.showImage(@menu,655,@y+60)
	end
end
