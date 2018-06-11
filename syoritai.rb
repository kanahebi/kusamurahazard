class Syoritai
	attr_reader :x, :y
	attr_accessor :x, :y, :hasiru, :syori_k, :count
	def initialize(window,sound,kusa,x,y,no)
		@image = Array.new(4)
		5.times {|i| @image[i] = SDL::Surface.load("syori#{i}.gif")}
		@momo_cap = SDL::Surface.load("momo_#{no}.gif")

		@window = window
		@sound  = sound
		@kusa   = kusa
		@x = @syokix = x
		@y = @syokiy = y
		@hasiru = false
		@sisei  = 0
		@form   = 0
		@hayasa = 0
		@syori  = 0
		@syori_t = nil
		@syori_k = nil
		@count  = 0
	end

	def draw
		run
		kataduke
		syori
		@window.showImage(@image[@sisei], @x,@y)
		@window.showImage(@momo_cap, @x,@y)
	end
	
	def run
		if @hasiru
			@hayasa += 1
			@x      += 0.25
		end
		@form = @hayasa / 50
		if @form > 4
			@form   = 2
			@hayasa = 0
		end

		@sisei = 1 if @form == 1
		@sisei = 2 if @form == 2
		@sisei = 3 if @form == 3
		@sisei = 3 if @form == 4

		unless @hasiru
			@sisei  = 0
			@hayasa = 0
			@form   = 1
		end

	end
	
	def kataduke
		if @syori == 0
			@hasiru = true
		elsif @syori == 1
			@hasiru = false
			@sisei  = 4
		elsif @syori <= 3
			@sisei = 0
		end
	end

	def syori
		unless @syori_t
			@kusa.flatten.each_with_index do |kusa,j|
				if kusa.x - @x <= 85 and kusa.x - @x >= 80 and kusa.y == kusa.syokiy and kusa.state == 1
					@syori_t = kusa
					@syori_k = SyoriK.new(@window,kusa.x,kusa.syokiy-7.5+(kusa.h-20)) if @syori_t
				end
			end
		end
		if @syori_t
			unless @syori == 0
				@x = @syori_t.x - 85
			end
				if @syori_t.syokiy - @syori_t.y <= 7.5
					@syori = 1
				elsif @syori_t.syokiy - @syori_t.y >= 7.5 and @syori == 1
					@syori     = 2
					@syori_t.y = - @syori_t.h
				elsif @syori_k.syokiy - @syori_k.y >= 200 and @syori == 2
					@syori = 3
				elsif @syori_k.syokiy - @syori_k.y <=  80 and @syori == 3
					@syori_t.state = 2
					@syori_t = nil
					@syori_k = nil
					@syori   = 0
					@count  += 1
				end
			case @syori
			when 1
				@syori_t.y -= 0.1
			when 2
				@syori_k.x -= 0.1
				@syori_k.y -= 0.5
			when 3
				@syori_k.x -= 0.1
				@syori_k.y += 0.5
			end
			@syori_k.draw if @syori > 1
		end
	end

	def reset
		@x      = @syokix
		@y      = @syokiy
		@sisei  = 0
		@hasiru = 0
		@form   = 0
		@hayasa = 0
		@seisi  = 0
		@se     = 0
		@count  = 0
		@syori_t = nil
		@syori_k = nil
	end
end

class SyoriK
	attr_reader :x, :y, :syokix, :syokiy
	attr_accessor :x, :y
	def initialize(window,x,y)
		@image  = SDL::Surface.load("syorikusa.gif")
		@window = window
		@x = @syokix = x
		@y = @syokiy = y
	end

	def draw
		@window.showImage(@image, @x, @y)
	end
end
