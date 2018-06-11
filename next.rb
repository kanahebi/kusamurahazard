class Next
	attr_accessor :hyoji
	def initialize(window,hero)
		@window = window
		@hero   = hero
		@hyoji  = false
		@image  = SDL::Surface.load("yazirusi.gif")
	end
	
	def draw
		if @hero.x >= 500
			@window.showImage(@image,670,120)
			@hyoji = true
		else
			@hyoji = false
		end
	end
	def bdraw
		@window.showImage(@image,670,120)
		@hyoji = true
	end
end
