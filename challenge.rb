class Challenge
	attr_accessor :select, :game, :title, :menu
	def initialize(window,sound,menu,continue)
		@yaml = YAML.load_file("challenge.yml")

		@hide = Array.new
		4.times {|i| @hide[i] = SDL::Surface.load("challenge#{i}.png")}

		@back = SDL::Surface.load("challenge.gif")
		@no_70 = Array.new
		10.times {|i| @no_70[i] = SDL::Surface.load("70_no_#{i}.png")}

		@advice = Array.new
		@advice[0] = Hash.new
		@advice[0]["false"] = SDL::Surface.load("advice.png")
		@advice[0]["true"]  = SDL::Surface.load("advice1.png")
		20.times {|i| @advice[i+1] = SDL::Surface.load("c#{i+1}.png")}

		@ww    = SDL::Surface.load("ww.png")

		@sec  = SDL::Surface.load("sec.gif")
		@kusa = SDL::Surface.load("kusa_total.gif")
		@no   = SDL::Surface.load("no.gif")

		@window = window
		@sound  = sound
		@menu   = menu
		@continue = continue
	end

	def play
		reset
		@sound.bgmplay("top")
		while true do
			while event = SDL::Event2.poll do
				case event
					when SDL::Event2::Quit
						exit
					when SDL::Event2::KeyDown
						if event.sym == (SDL::Key::UP)
							if @no_pick > 1
								@no_pick -= 1
								if @wy > 236
									@wy -= 58
								else
									@list_y += 58
								end
							end
						end

						if event.sym == (SDL::Key::DOWN)
							case @menu_pick
								when 1
									if @no_pick < @yaml.length
										@no_pick += 1
										if @wy < 410
											@wy += 58
										else
											@list_y -= 58
										end
									end
								when 2
									if @no_pick < @failure
										@no_pick += 1
										if @wy < 410
											@wy += 58
										else
											@list_y -= 58
										end
									end
								when 3, 4
									if @no_pick < @clear
										@no_pick += 1
										if @wy < 410
											@wy += 58
										else
											@list_y -= 58
										end
									end
							end
						end

						if event.sym == (SDL::Key::RIGHT)
							if @menu_pick < 4
								@menu_pick += 1
								@no_pick = 1
								@list_y = 240
								@wy     = 236
							end
						end


						if event.sym == (SDL::Key::LEFT)
							if @menu_pick > 1
								@menu_pick -= 1
								@no_pick = 1
								@list_y = 240
								@wy     = 236
							end
						end

						if event.sym == (SDL::Key::SPACE)
							if @play_able
								return false
							end
						end
						if event.sym == (SDL::Key::Q)
							@title = true
							return false
						end
						if event.sym == (SDL::Key::R)
							data_reset
						end
						if event.sym == (SDL::Key::A)
							@adv_flag = !@adv_flag
						end
				end
			end

			@window.showImage(@back,0,0)

			@play_able = false
			case @menu_pick
				when 1
					list_num = 0
					@yaml.each_with_index do |(yaml,val),num|
						draw_list(val,num+1,num+1)
					end
					@play_able = true if @yaml.length > 0
				when 2
					list_num = 0
					@yaml.each_with_index do |(yaml,val),num|
						list_num += 1
						if val["clear"]
							list_num -= 1
							next 
						end
						draw_list(val,num+1,list_num)
					end
					@play_able = true if @failure > 0
				when 3,4
					list_num = 0
					@yaml.each_with_index do |(yaml,val),num|
						list_num += 1
						unless val["clear"]
							list_num -= 1
							next 
						end
						draw_list(val,num+1,list_num)
					@play_able = true if @clear > 0
					end
			end

			@window.showImage(@ww,20,@wy) if @play_able
			@window.showImage(@hide[@menu_pick-1],0,0)
			@window.showImage(@advice[set_game],10,390) if @adv_flag
			@window.showImage(@advice[0][@adv_flag.to_s],260,550)
			@window.refresh
		end
	end

	def check_clear
		@clear = @failure = 0
		@yaml.each do |yaml,val|
			if val["clear"]
				@clear += 1
			else
				@failure += 1
			end
		end
	end

	def draw_list(val,num,list_num)
		ten = num / 10
		one = num % 10
		@window.showImage(@no_70[ten],162,@list_y+58*(list_num-1))
		@window.showImage(@no_70[one],189,@list_y+58*(list_num-1))
		@window.showImage(@no,         80,@list_y+58*(list_num-1)-2)
		ten = val["data"][0] / 10
		one = val["data"][0] % 10
		@window.showImage(@no_70[ten],332,@list_y+58*(list_num-1))
		@window.showImage(@no_70[one],359,@list_y+58*(list_num-1))
		@window.showImage(@sec,       398,@list_y+58*(list_num-1)+2)
		if @menu_pick == 4
			ten = val["score"] / 10
			one = val["score"] % 10
			@window.showImage(@no_70[ten],593,@list_y+58*(list_num-1))
			@window.showImage(@no_70[one],620,@list_y+58*(list_num-1))
			@window.showImage(@sec,       658,@list_y+58*(list_num-1)+2)
		else
			ten = (val["data"][1] +val["data"][2] +val["data"][3] +val["data"][4]) / 10
			one = (val["data"][1] +val["data"][2] +val["data"][3] +val["data"][4]) % 10
			hnd = ten / 10
			ten = ten % 10 if ten > 9
			@window.showImage(@no_70[hnd],566,@list_y+58*(list_num-1)) if hnd > 0
			@window.showImage(@no_70[ten],593,@list_y+58*(list_num-1))
			@window.showImage(@no_70[one],620,@list_y+58*(list_num-1))
			@window.showImage(@kusa,      658,@list_y+58*(list_num-1)+7)
		end
	end

	def set_game
		case @menu_pick
			when 1
				return @no_pick
			when 2
				list_num = 0
				@yaml.each_with_index do |(yaml,val),num|
					list_num += 1
					if val["clear"]
						list_num -= 1
						next 
					end
					return num + 1 if @no_pick == list_num
				end
			when 3, 4
				list_num = 0
				@yaml.each_with_index do |(yaml,val),num|
					list_num += 1
					unless val["clear"]
						list_num -= 1
						next 
					end
					return num + 1 if @no_pick == list_num
				end
		end
	end

	def play_game(play_no)
		return unless play_no
		@game = Game_challenge.new(@window,@sound,@menu,*@yaml["no_#{play_no}"]["data"])
	end

	def data_save(play_no,score)
		return  unless score
		@yaml["no_#{play_no}"]["clear"] = true
		@yaml["no_#{play_no}"]["score"] = score if !@yaml["no_#{play_no}"]["score"]
		@yaml["no_#{play_no}"]["score"] = score if @yaml["no_#{play_no}"]["score"] > score
		open("challenge.yml","w") do |f|
			YAML.dump(@yaml,f)
		end
	end

	def data_reset
		@yaml.length.times do |no|
			@yaml["no_#{no+1}"]["clear"] = false
			@yaml["no_#{no+1}"]["score"] = nil
		end
		open("challenge.yml","w") do |f|
			YAML.dump(@yaml,f)
		end
	end

	def reset
		@no_pick   = 1
		@menu_pick = 1
		@wy        = 236
		@list_y    = 240
		@play_able = false
		@title     = false
		@adv_flag  = false
		check_clear
	end
end
