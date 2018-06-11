class Buta
	attr_reader :x, :y
	attr_accessor :x, :y, :bt, :punch, :hp, :sx, :utu, :ataru, :koudo
	def initialize(window,hero,sound,x,y)
		@image = Array.new()
		13.times {|i| @image[i] = SDL::Surface.load("buta#{i}.gif")}

		@sgh = SDL::Surface.load("syougekiha.gif")

		@window = window
		@sound  = sound
		@hero   = hero
		@x = @syokix = x
		@y = @syokiy = y
		@bt    = 0
		@punch = 0
		@p     = 0
		@tasu  = 1
		@utu   = false
		@ataru = false
		@kyori = 0
		@hp    = 100
		@d     = 0
		@sx    = 0
		@koudo = 0
	end

	def draw
		@koudo += 1
		@b = 0
		if @hp > 0
			if @hero.hp > 0
				if @x - @hero.x <= 400 and @hero.muki == 3
					if @hero.hi_img == 2
						@b = 6
						@d += 1
						if @d == 30
							@hp -= 1
							@d  = 0
						end
					elsif @bt == 6
						@d = 0
					end
				end
				if @x - @hero.x < 400 and !@utu and @koudo % 650 == 0
						@punch = 1
				end

				if @punch != 0
					if @bt == 0 and @punch == 1
						@sound.utplay
					end
					@p += 1
					if @p == 20
						@bt += @tasu
						@p  = 0
					end
					if @punch == 1
						@tasu = 1
						if @bt == 1
							if @p == 0
								@sx    = @x
								@kyori = 0
							end
							@utu = true
						end
						if @bt == 5
							@punch = 2
						end
					end
					if @punch == 2
						@tasu = -1
						if @bt == 0
							@punch = 0
						end
					end
				end
				if @utu
					if @kyori <= 350
						@sx    -= 0.6
						@kyori += 0.5
					else
						@utu = false
					end
				end
			end
		elsif @bt != 12
			@bt = 12
			@x += 25
			@y += 152
		end
		@window.showImage(@image[@bt+@b],@x,@y)
	end
	
	def kougeki
		if @ataru or @utu and @hp > 0
			@window.showImage(@sgh,@sx,@y+80)
		else
			@sx = @x
		end
	end

	def reset
		@x  = @syokix
		@y  = @syokiy
		@bt = 0
		@punch = 0
		@p     = 0
		@tasu  = 1
		@utu   = false
		@ataru = false
		@kyori = 0
		@hp    = 100
		@d     = 0
		@sx    = 0
		@koudo = 0
	end
end
