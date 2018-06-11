class Top
	attr_accessor :sentaku, :clear, :series, :select
	def initialize(window,sound)
		@back  = Array.new
		@back[0] = SDL::Surface.load("top.gif")
		@back[1] = SDL::Surface.load("tu-top.gif")
		@newg  = SDL::Surface.load("newgame.png")
		@tuto  = SDL::Surface.load("tutorial.png")
		@boss  = SDL::Surface.load("boss.png")
		@chlg  = SDL::Surface.load("challenge.png")
		@cstm  = SDL::Surface.load("custom.png")
		@mtch  = SDL::Surface.load("match.png")
		@ww    = SDL::Surface.load("ww.png")
		@kumo1 = SDL::Surface.load("kumo.gif")
		@kumo2 = SDL::Surface.load("kumo2.gif")
		@kumo3 = SDL::Surface.load("kumo3.gif")
		@hide  = SDL::Surface.load("hide.png")
		@under = SDL::Surface.load("under.gif")
		@over  = SDL::Surface.load("over.gif")
		@right = SDL::Surface.load("right.gif")
		@left  = SDL::Surface.load("left.gif")

		@window  = window
		@sound   = sound
		@x       = 0
		@wx      = 423
		@kx1     = 0
		@kx2     = -800
		@kx3     = 800
		@sentaku = 1
		@select  = 1
		@clear   = false
		@series  = 1
		@nx = [nil,482,532,532]
		@tx = [nil,532,483,535]
		@bx = [nil,535,535,485]
		@wy = [nil,250,312,374]
		@tuy= 295
		@plus = 0
	end

	def play
		@sound.bgmplay("top")
		while true do
			while event = SDL::Event2.poll do
				case event
					when SDL::Event2::Quit
						exit
					when SDL::Event2::KeyDown
						if event.sym == (SDL::Key::UP)
							if @series == 1 and @sentaku > 1
								if @clear
									@sentaku -= 1
								else
									@sentaku = 1
								end
							elsif @select > 1 and @plus == 0
								@plus = 1
								@select -= 1
								@tuy    += 1
							end
						end
						if event.sym == (SDL::Key::DOWN)
							if @series == 1 and @sentaku < 3
								if @clear
									@sentaku += 1
								else
									@sentaku = 2
								end
							elsif @select < 5 and @plus == 0
								@plus = -1
								@select += 1
								@tuy    -= 1
							end
						end
						if event.sym == (SDL::Key::RIGHT) and @series == 1
							@series = 2
							@x = -2
						end
						if event.sym == (SDL::Key::LEFT)  and @series == 2
							@series = 1
							@x = -798
						end
						if event.sym == (SDL::Key::SPACE)
							@kx1 = 0
							@kx2 = -800
							@kx3 = 800
							return false
						end
				end
			end
			if @plus < 0 and @plus > -50
				@tuy  -= 1
				@plus -= 1
			elsif @plus > 0 and @plus < 50
				@tuy  += 1
				@plus += 1
			else
				@plus = 0
			end
				
			if @x == 0 or @x == -800
				@kx1 = -800 if @kx1 >= 1600
				@kx2 = -800 if @kx2 >= 1600
				@kx3 = -800 if @kx3 >= 1600
				@kx1 += 0.1
				@kx2 += 0.1
				@kx3 += 0.1
			end
			@window.showImage(@back[0],@x,0)
			@window.showImage(@back[1],@x+800,0)
			if @series == 1
				unless @x == 0
					@x += 2
				end
			end
			if @series == 2
				unless @x == -800
					@x -= 2
				end
			end
			@window.showImage(@kumo1,@x+@kx1,0)
			@window.showImage(@kumo2,@x+@kx2,0)
			@window.showImage(@kumo3,@x+@kx3,0)

			@window.showImage(@newg,@x+@nx[@sentaku],240)
			@window.showImage(@tuto,@x+@tx[@sentaku],308)
			if @clear
				@window.showImage(@boss,@x+@bx[@sentaku],384)
			end
			@window.showImage(@ww,@x+@wx,@wy[@sentaku])

			@window.showImage(@newg,@x+1330,@tuy)     if @select >= 1 and @select <= 2
			@window.showImage(@tuto,@x+1330,@tuy+52)  if @select >= 1 and @select <= 3
			@window.showImage(@chlg,@x+1330,@tuy+114) if @select >= 2 and @select <= 4
			@window.showImage(@cstm,@x+1330,@tuy+162) if @select >= 3 and @select <= 5
			@window.showImage(@mtch,@x+1330,@tuy+214) if @select >= 4 and @select <= 5

			@window.showImage(@hide,@x+1330,210)

			@window.showImage(@ww,@x+1270,298)
			@window.showImage(@over, @x+1412,245) if @select > 1
			@window.showImage(@under,@x+1412,411) if @select < 5

			@window.showImage(@left, @x+810,289) if @series == 2
			@window.showImage(@right,@x+782,289) if @series == 1
			@window.refresh
		end
	end
end
