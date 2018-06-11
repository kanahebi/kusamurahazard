class Back
	attr_accessor :x
	attr_reader :x, :y
	def initialize(window)
		@yaml  = YAML.load_file("back.yml")
		@image = Array.new()
		@yaml["image"].each_index {|i| @image[i] = SDL::Surface.load(@yaml["image"][i])}

		@window = window
		@x      = 0
		@y      = 0
	end
	
	def draw
		@stimg.each_with_index {|i,j| @window.showImage(i,@x+j*800,@y)}
	end
	
	def set(stg)
		@stimg = Array.new()
		@yaml[stg].each_with_index {|i,j| @stimg[j] = @image[i]}
	end

	def reset
		@x = 0
	end
end
