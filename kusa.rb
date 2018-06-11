class Kusa
	attr_reader :x, :y, :state, :total, :syokiy, :h, :img, :kusa
	attr_accessor :x, :y, :state, :img
	def initialize(window,hero,x,y,name)
		@yaml = YAML.load_file("kusa.yml")
		@kusa = Array.new()
		@yaml[name].each_with_index {|i,j| @kusa[j] = SDL::Surface.load(@yaml[name][j])}
		@window = window
		@hero   = hero
		@x = @syokix = x
		@y = @syokiy = y
		@state = 0
		@img   = 0
		@total = 0
		@delay = 0
		@h     = @kusa[0].h
	end

	def draw
		if @state <= 1
			@window.showImage(@kusa[@img],@x,@y)
		end
	end

	def reset
		@x     = @syokix
		@y     = @syokiy
		@time  = 0
		@img   = 0
		@state = 0
		@total = 0
		@delay = 0
	end

	def reborn(delay)
		@state = 1
		@delay += 1
		if @delay >= delay
			@x     = rand(730) + 1
			@delay = 0
			@img   = 0
			@state = 0
		end
	end
end

class HumuK < Kusa
	def initialize(window,sound,hero,x,y)
		super(window,hero,x,y,"humu")
		@sound = sound
	end

	def draw
		if @img == 0 and @hero.syokiy == @hero.y and @syokiy == @y and @state == 0
			if @x - @hero.x > 0 and @x - @hero.x < 64  and @hero.muki == 3
				mow
			end
			if @x - @hero.x > 2 and @x - @hero.x < 112 and @hero.muki == 1
				mow
			end
		end
		super
	end

	def mow
		@sound.hmplay
		@img   = 1
		@state = 1
		@total = 1
	end
end

class KaruK< Kusa
	def initialize(window,sound,hero,x,y)
		super(window,hero,x,y,"karu")
		@sound  = sound
	end

	def draw
		if @hero.karu and @img == 0 and @syokiy == @y and @state == 0
			if @x - @hero.x >= 75 and @x - @hero.x <= 180 and @hero.muki == 3
				mow
			end
			if @hero.x - @x >= -55 and @hero.x - @x <= 90 and @hero.muki == 1
				mow
			end
		end
		super
	end

	def mow
		@sound.krplay
		@img   = 1
		@state = 1
		@total = 1
	end
end

class MosuK < Kusa
	def initialize(window,hero,x,y)
		super(window,hero,x,y,"mosu")
		@time = 0
	end

	def draw
		if @img == 0 and @hero.hassya and @syokiy == @y
			if @x - @hero.x >= 245 and @x - @hero.x <= 485 and @hero.muki == 3
				@img = 1
			end
			if @hero.x - @x >= 165 and @hero.x - @x <= 400 and @hero.muki == 1
				@img = 1
			end
		end
		case @time
		when 500
			@img = 2
		when 1000
			@img = 3
		when 1500
			mow
		end
		if @img >= 1 and @img < 4
			@time += 1
		end
		super
	end

	def mow
		@img   = 4
		@state = 1 if @state == 0
		@total = 1
	end
end

class KesuK < Kusa
	def initialize(window,hero,x,y)
		super(window,hero,x,y,"kesu")
		@time = 0
	end

	def draw
		if @img == 0 and @hero.kakaru and @syokiy == @y
			if @x - @hero.x >=  75  and @x - @hero.x <= 180 and @hero.muki == 3
				@img = 1
			end
			if @x - @hero.x >= -120 and @x - @hero.x <= -4  and @hero.muki == 1
				@img = 1
			end
		end
		if @time == 500 and @state == 0
			mow
		end
		if @img == 1
			@time += 1
		end
		super
	end

	def mow
		@img   = 2
		@state = 1
		@total = 1
	end
end

class HumuK_W < HumuK
	def reborn
		if @img == 1
			super(3000 + rand(5) -10)
		end
	end

	def mow
		@sound.hmplay
		@img   = 1
		@state = 1
		@total += 1
	end

	def reset
		super
		@x = rand(730) + 1
	end
end

class KaruK_W < KaruK
	def reborn
		if @img == 1
			super(5000 + rand(5) -10)
		end
	end

	def mow
		@sound.krplay
		@img   = 1
		@state = 1
		@total += 1
	end

	def reset
		super
		@x = rand(730) + 1
	end
end

class MosuK_W < MosuK
	def reborn
		if @img == 4
			super(6000 + rand(5) -10)
			@time = 0
		end
	end

	def mow
		@img = 4
		if @state == 0
			@state  = 1
			@total += 1
		end
	end

	def reset
		super
		@x = rand(730) + 1
	end
end

class KesuK_W < KesuK
	def reborn
		if @img == 2
			super(8000 + rand(5) -10)
			@time = 0
		end
	end

	def mow
		@img = 2
		if @state == 0
			@state  = 1
			@total += 1
		end
	end

	def reset
		super
		@x = rand(730) + 1
	end
end
