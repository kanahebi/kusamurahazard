class Rival
	attr_reader :x, :y
	attr_accessor :x, :y, :hasiru, :syori_k, :count, :rivalk
	def initialize(window,sound,kusa,x,y,no)
		@image = Array.new
		4.times {|i| @image[i] = SDL::Surface.load("kusakariyasan#{i}.gif")}

		@window = window
		@sound  = sound
		@kusa   = kusa
		@x = @syokix = x
		@y = @syokiy = y
		@hasiru = true
		@sisei  = 0
		@form   = 0
		@hayasa = 0
		@rivalk = []
	end

	def draw
		run
		syori
		@window.showImage(@image[@sisei], @x,@y)
	end
	
	def run
		if @hasiru
			@hayasa += 1
			@x      -= 0.25
		end
		@form = @hayasa / 100

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
	
	def syori
		@kusa.flatten.each do |kusa|
			if @x - kusa.x <= 0 and @x - kusa.x >= -90 and kusa.y == kusa.syokiy and kusa.state == 0
				@sound.rvplay
				kusa.y = -kusa.h
				kusa.state = 3
				@rivalk << RivalK.new(@window,x,465)
			end
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
		@rivalk = []
	end
end

class RivalK
	attr_reader :x, :y, :syokix, :syokiy
	attr_accessor :x, :y
	def initialize(window,x,y)
		@image  = SDL::Surface.load("rivalkusa.gif")
		@window = window
		@x      = @syokix = x
		@y      = @syokiy = y
	end

	def draw
		@window.showImage(@image, @x, @y)
	end
end
