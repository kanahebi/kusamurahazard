class Bar
	attr_accessor :x
	attr_reader :x, :y
	def initialize(window,back,hero,syoritai,rival,kusa)
		@image = Hash.new
		@image["hero"]   = SDL::Surface.load("suzuki.gif")
		@image["red"]    = SDL::Surface.load("red.gif")
		@image["yellow"] = SDL::Surface.load("yellow.gif")
		@image["pink"]   = SDL::Surface.load("pink.gif")
		@image["green"]  = SDL::Surface.load("green.gif")
		@image["purple"] = SDL::Surface.load("purple.gif")
		@image["rival"]  = SDL::Surface.load("rival.gif")

		@ground = SDL::Surface.load("ground.gif")
		@kusa_img = Array.new
		@kusa_img[0] = SDL::Surface.load("kuro.gif")
		@kusa_img[1] = SDL::Surface.load("aka.gif")
		@kusa_img[2] = SDL::Surface.load("mido.gif")
		@kusa_img[3] = SDL::Surface.load("ao.gif")

		@window   = window
		@back     = back
		@hero     = hero
		@syoritai = syoritai
		@rival    = rival
		@kusa     = kusa
	end
	
	def draw
		@window.showImage(@ground,460,60)
		@kusa.flatten.each {|kusa| @window.showImage(@kusa_img[kusa.state],image_x(kusa.x),60)} if @kusa
		@window.showImage(@image["hero"]   ,image_x(@hero.x),33)
		@window.showImage(@image["rival"]  ,image_x(@rival.x),35)       if @rival
		@window.showImage(@image["green"]  ,image_x(@syoritai[4].x),50) if @syoritai[4]
		@window.showImage(@image["purple"] ,image_x(@syoritai[3].x),50) if @syoritai[3]
		@window.showImage(@image["pink"]   ,image_x(@syoritai[2].x),50) if @syoritai[2]
		@window.showImage(@image["yellow"] ,image_x(@syoritai[1].x),50) if @syoritai[1]
		@window.showImage(@image["red"]    ,image_x(@syoritai[0].x),50) if @syoritai[0]
	end

	def image_x(x)
		bar_x = x - @back.x
		if bar_x <= 0
			bar_x = 0
		end
		if bar_x >= 6400
			bar_x = 6400
		end
		return bar_x / 20 + 460
	end
end
