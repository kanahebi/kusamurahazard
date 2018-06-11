class Window
	WINDOW_WIDTH  = 800
	WINDOW_HEIGHT = 600
	BIT_PER_PIXEL = 0
  
	def initialize
		SDL.init(SDL::INIT_EVERYTHING)
		@screen = SDL.set_video_mode(WINDOW_WIDTH,WINDOW_HEIGHT,BIT_PER_PIXEL,SDL::SWSURFACE)
		showImage(SDL::Surface.load("load.gif"),0,0)
		refresh
	end

	def refresh
		@screen.update_rect(0,0,0,0)
	end

	def showImage(image,x,y)
		@screen.put(image,x,y)
	end
end
