class Custom
	attr_accessor :select
	def initialize(window,sound)
		@back = Hash.new
		@back["true"]  = SDL::Surface.load("custom.gif")
		@back["false"] = SDL::Surface.load("custom_2.gif")

		@no_70 = Array.new
		10.times {|i| @no_70[i] = SDL::Surface.load("70_no_#{i}.png")}

		@no_55 = Array.new
		10.times {|i| @no_55[i] = SDL::Surface.load("55_no_#{i}.png")}

		@umu = Hash.new
		@umu["true"] = SDL::Surface.load("ari.png")
		@umu["false"] = SDL::Surface.load("nasi.png")

		@ww    = SDL::Surface.load("ww.png")
		@under = SDL::Surface.load("under.gif")
		@over  = SDL::Surface.load("over.gif")
		
		@lr_img = Hash.new
		@lr_img["true"]  = SDL::Surface.load("left.gif")
		@lr_img["false"] = SDL::Surface.load("right.gif")

		@window = window
		@sound  = sound
		@wx     = [nil, 99, 99, 99, 99, 99,390,390,390,390, 17]
		@wy     = [nil,106,163,221,282,337,389,429,469,509,531]
		@kusa_y = [nil,389,429,469,509]

		@sayuu = {"x"=>{"true"=>397, "false"=>462}, "y"=>[nil,133,185,244]}
		@jouge = {"over"=> {"ten"=>[nil,nil,nil,nil,nil,[392,335],[579,395],[579,435],[579,475],[579,515]],
		                    "one"=>[nil,nil,nil,nil,nil,[417,335],[602,395],[602,435],[602,475],[602,515]]},
		          "under"=>{"ten"=>[nil,nil,nil,nil,nil,[392,393],[579,443],[579,483],[579,523],[579,563]],
		                    "one"=>[nil,nil,nil,nil,nil,[417,393],[602,443],[602,483],[602,523],[602,563]]}}
		reset
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
							unless @flag[@select]
								if @select > 1
									@select -= 1
								end
							end

							if @flag[4] and @value[4] < 5
								@value[4] += 1
							end

							if @select >= 5 and @select <= 9
								if @flag[@select] and @value[@select] % 10 < 9 and @one
									@value[@select] += 1
								end
								if @flag[@select] and @value[@select] / 10 < 9 and @ten
									@value[@select] += 10
								end
							end
						end

						if event.sym == (SDL::Key::DOWN)
							unless @flag[@select]
								if @select < 10
									@select += 1
								end
							end

							if @flag[4] and @value[4] > 0
								@value[4] -= 1
							end

							if @select >= 5 and @select <= 9
								if @flag[@select] and @value[@select] % 10 > 0 and @one
									@value[@select] -= 1
								end
								if @flag[@select] and @value[@select] / 10 > 0 and @ten
									@value[@select] -= 10
								end
							end
						end

						if event.sym == (SDL::Key::RIGHT)
							if @select >= 1 and @select <= 3
								if @flag[@select]
									@value[@select] = true
								end
							end

							if @select >= 5 and @select <= 9
								if @flag[@select]
									@one = true
									@ten = false
								end
							end
						end


						if event.sym == (SDL::Key::LEFT)
							if @select >= 1 and @select <= 3
								if @flag[@select]
									@value[@select] = false
								end
							end

							if @select >= 5 and @select <= 9
								if @flag[@select]
									@one = false
									@ten = true
								end
							end
						end

						if event.sym == (SDL::Key::SPACE)
							@flag[@select] = !@flag[@select]
							@ten = false
							@one = true
						end
						if event.sym == (SDL::Key::Q)
							@select = 11
							return false
						end
				end
			end
			if @flag[10]
				return false
			end

			if @value[1]
				@value[3] = false
				@flag[3]  = false
			else
				@value[2] = false
				@value[4] = 0
				@flag[2]  = @flag[4] = false
			end
			@window.showImage(@back[@value[1].to_s],0,0)

			@window.showImage(@umu[@value[1].to_s],412,120)
			@window.showImage(@umu[@value[2].to_s],412,172)
			@window.showImage(@umu[@value[3].to_s],412,231)

			@window.showImage(@no_70[@value[4]],420,289)

			@window.showImage(@no_70[@value[5] / 10],395,345)
			@window.showImage(@no_70[@value[5] % 10],420,345)

			@window.showImage(@no_55[@value[6] / 10],586,407)
			@window.showImage(@no_55[@value[6] % 10],608,407)
			@window.showImage(@no_55[@value[7] / 10],586,447)
			@window.showImage(@no_55[@value[7] % 10],608,447)
			@window.showImage(@no_55[@value[8] / 10],586,487)
			@window.showImage(@no_55[@value[8] % 10],608,487)
			@window.showImage(@no_55[@value[9] / 10],586,527)
			@window.showImage(@no_55[@value[9] % 10],608,527)

			@window.showImage(@ww,@wx[@select],@wy[@select])

			if @flag[1] or @flag[2] or @flag[3]
				@window.showImage(@lr_img[(@value[@select]).to_s],@sayuu["x"][(@value[@select]).to_s],@sayuu["y"][@select])
			end
			
			if @flag[4]
				@window.showImage(@over, 417,277) if @value[4] < 5
				@window.showImage(@under,417,335) if @value[4] > 0
			end
			
			if @select >= 5 and @select <= 9
				if @flag[@select]
					@window.showImage(@over, *@jouge["over"]["ten"][@select])  if @value[@select] / 10 < 9 and @ten
					@window.showImage(@under,*@jouge["under"]["ten"][@select]) if @value[@select] / 10 > 0 and @ten
					@window.showImage(@over, *@jouge["over"]["one"][@select])  if @value[@select] % 10 < 9 and @one
					@window.showImage(@under,*@jouge["under"]["one"][@select]) if @value[@select] % 10 > 0 and @one
				end
			end
			@window.refresh
		end
	end

	def valueTohash
		return Hash[*([["scrl","rival","multi","syori","time","humu","karu","mosu","kesu"],@value[1..9]].transpose).flatten]
	end

	def reset
		@value = [nil,false,false,false,    0,    0,    0,    0,    0,    0,    0]
		@flag  = [nil,false,false,false,false,false,false,false,false,false,false]

		@select = 1
		@one    = true
		@ten    = false
	end
end
