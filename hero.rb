class Hero
	attr_reader :x, :y
	attr_accessor :x, :y, :hayasa, :hasiru, :jmp, :px, :karu, :hassya, :muki, :syokix, :syokiy, :hp, :hi_img, :kp, :move, :jmaey, :kakaru, :press, :ataru, :action
	def initialize(window,sound,x,y)
		@yaml = YAML.load_file("suzuki.yml")

		@body = {}
		@body["noml"] = Array.new(4)
		4.times {|i| @body["noml"][i] = SDL::Surface.load(@yaml["noml"][i])}
		@body["kama"] = Array.new(4)
		4.times {|i| @body["kama"][i] = SDL::Surface.load(@yaml["kama"][i])}
		@body["kaen"] = Array.new(1)
		1.times {|i| @body["kaen"][i] = SDL::Surface.load(@yaml["kaen"][i])}
		@body["joso"] = Array.new(5)
		5.times {|i| @body["joso"][i] = SDL::Surface.load(@yaml["joso"][i])}

		@foot = Array.new()
		@yaml["foot"].each_with_index {|j,i| @foot[i] = SDL::Surface.load(j)}
		@kama_ha = SDL::Surface.load("kama_ha.gif")

		@hbody = {}
		@hbody["noml"] = Array.new(4)
		4.times {|i| @hbody["noml"][i] = SDL::Surface.load("h"+@yaml["noml"][i])}
		@hbody["kama"] = Array.new(4)
		4.times {|i| @hbody["kama"][i] = SDL::Surface.load("h"+@yaml["kama"][i])}
		@hbody["kaen"] = Array.new(1)
		1.times {|i| @hbody["kaen"][i] = SDL::Surface.load("h"+@yaml["kaen"][i])}
		@hbody["joso"] = Array.new(5)
		5.times {|i| @hbody["joso"][i] = SDL::Surface.load("h"+@yaml["joso"][i])}

		@hfoot = Array.new()
		@yaml["foot"].each_with_index {|j,i| @hfoot[i] = SDL::Surface.load("h"+j)}
		@hkama_ha = SDL::Surface.load("hkama_ha.gif")

		@yarare  = SDL::Surface.load("bouy.gif")
		@hyarare = SDL::Surface.load("bouy2.gif")
		@taoreru = SDL::Surface.load("taoreru.gif")

		@honou = Array.new()
		6.times {|i| @honou[i] = SDL::Surface.load("honou#{i}.gif")}

		@hhonou = Array.new()
		6.times {|i| @hhonou[i] = SDL::Surface.load("hhonou#{i}.gif")}

		@kusuri = Array.new()
		4.times {|i| @kusuri[i] = SDL::Surface.load("j#{i}.gif")}

		@hkusuri = Array.new()
		4.times {|i| @hkusuri[i] = SDL::Surface.load("hj#{i}.gif")}

		@window = window
		@sound  = sound
		@x = @syokix = x
		@y = @syokiy = y
		reset
	end

	def draw
		if @hp > 0
			if @move
				run
				jump
				kama
				kaen
				joso
				noml
			end
			unless @ataru
				if @muki == 3
					@window.showImage(@body[@dogu][@dosa],@x,@y)     if @body[@dogu][@dosa]
					@window.showImage(@foot[@style],      @x,@y)
					@window.showImage(@kama_ha,           @x,@y)     if @dogu == "kama" and @dosa == 0
					@window.showImage(@honou[@hi_img],@x+200,@y+125) if @hi_img != 6
					@window.showImage(@kusuri[@js_img],@joso_x,@y)   if @js_img != 4
				end
				if @muki == 1
					@window.showImage(@hbody[@dogu][@dosa],@x-48,@y)   if @body[@dogu][@dosa]
					@window.showImage(@hfoot[@style],      @x-48,@y)
					@window.showImage(@hkama_ha,           @x-48,@y)   if @dogu == "kama" and @dosa == 0
					@window.showImage(@hhonou[@hi_img],@x-348,@y+125)  if @hi_img != 6
					@window.showImage(@hkusuri[@js_img],@joso_x-48,@y) if @js_img != 4
				end
			else
				@window.showImage(@yarare,@x,@y)
			end

		else
			@window.showImage(@taoreru,@x-135,@syokiy+160)
		end
	end
	
	def run
		@form = @hayasa / 50
		if @form > 4
			@form = 2
			@hayasa = 0
		end
		
		@style = 1 if @form == 1
		@style = 2 if @form == 2
		@style = 3 if @form == 3
		@style = 3 if @form == 4

		unless hasiru
			@style  = 0
			@hayasa = 0
			@form   = 1
		end
	end
	
	def jump
		if @jp_lag == 100  and !@still
			@jp_lag = 99
			@still  = true
			@y      = @jmaey - 100
		end
		if @still
			@y      = @jmaey - 100
			@style  = 3
			@st_lag += 1
			if @st_lag == 50
				@jmp    = 2
				@st_lag = 0
				@still  = false
			end
		end
		if @jp_lag == -1
			@jp_lag = 0
			@jmp    = 3
			@y      = @jmaey
		end
		if @jmp == 2 and !@still
			@style  = 3
			@y      += 0.5
			@jp_lag -= 0.5
		end
		if @jmp == 1 and !@still
			if @jp_lag == 0
				@jmaey = @y
			end
			@style  = 3
			@y      -= 0.5
			@jp_lag += 0.5
		end
	end
	
	def noml
		if @press =="" and @action == nil
			@dogu = "noml"
			@dosa = @style
		end
	end
	
	def kama
		if @press == "c" and @action == nil or @action == "kama"
			@dosa = 0 unless @action
			@dogu = "kama"
			if @px and @jmp == 3
				@huru   = true
				@action = "kama" unless @action
			end
		end
		if @huru and @action == "kama"
			case @orosu
				when 1
					@dosa = 1
				when 50
					@dosa = 2
				when 100
					@dosa = 3
				when 150
					@dosa = 0
					@karu = true
				when 200
					@orosu  = 0
					@huru   = false
					@karu   = false
					@action = nil
			end
			@orosu  += 1
		end
	end
	
	def kaen
		if @press == "v" and @action == nil or @action == "kaen"
			@dogu = "kaen"
			@dosa = 0
			if @px and @jmp == 3 and @kp > 0
				@hassya = true
				@action = "kaen" unless @action
			else
				@hassya = false
			end
			unless @px
				if @kp < 100
					@kp_lag += 1
					if @kp_lag == 10
						@kp += 1
						@kp_lag = 0
					end
				end
			end
		else
			@hassya = false
			@hi_img = 6
			if @kp < 100
				@kp_lag += 1
				if @kp_lag == 10
					@kp += 1
					@kp_lag = 0
				end
			end
		end
		if @hassya and @action == "kaen"
			if @tyakka % 250 == 0
				@sound.msplay
			end
			if @tyakka % 10 == 0
				@kp -= 1
			end
			case @tyakka
				when 0
					@hi_img = 0
				when 50
					@hi_img = 1
				when 100
					@hi_img = 2
			end
			@tyakka += 1
			@syouka = 0
		end

		if !@hassya and @tyakka >= 50 and @action == "kaen"
			case @syouka
				when 0
					@hi_img = 3
				when 50
					@hi_img = 4
				when 100
					@hi_img = 5
				when 150
					@hi_img = 6
					@tyakka = 0
					@action = nil
			end
			@syouka += 1
		end
	end
	
	def joso
		if @press == "d" and @action == nil or @action == "joso"
			@dogu = "joso"
			if @px and @jmp == 3 and @hasiru == false
				@maku = true
				@action = "joso" unless @action
				@joso_x = @x     unless @tarasu
			end
			@dosa = 0 unless @action
		end
		if @maku and @action == "joso"
			@mk_lag += 1
			case @mk_lag
				when 50
					@dosa = 1
				when 100, 350
					@dosa = 2
				when 150, 300
					@dosa = 3
				when 200
					@dosa = 4
				when 250
					@tarasu = true 
				when 400
					@dosa = 1
				when 450
					@dosa = 0
					@mk_lag = 0
					@maku = false
			end
		end
		if @tarasu
			@sound.mkplay if @js_lag == 0
			@js_lag += 1
			case @js_lag
				when 1
					@js_img = 0
				when 100
					@js_img = 1
				when 150
					@js_img = 2
					@kakaru = true
				when 200
					@js_img = 3
				when 300
					@js_img = 4
					@js_lag = 0
					@action = nil
					@kakaru = false
					@tarasu = false
			end
		end
	end

	def reset
		@x = @joso_x = @syokix
		@y = @jmaey  = @syokiy
		@kp_lag = 0
		@jp_lag = 0
		@mk_lag = 0
		@js_lag = 0
		@st_lag = 0
		@jmp    = 3
		@form   = 0
		@dosa   = 0
		@muki   = 3
		@style  = 0
		@orosu  = 0
		@hayasa = 0
		@tyakka = 0
		@syouka = 0

		@hi_img = 6
		@js_img = 4
		@hp = @kp = 100
		@press  = ""
		@dogu   = "noml"
		@action = nil
		@move   = true
		@px     = false
		@maku   = false
		@huru   = false
		@karu   = false
		@ataru  = false
		@still  = false
		@hassya = false
		@hasiru = false
		@tarasu = false
		@kakaru = false
	end
end
