require "sdl"
require "yaml"
require "date"
require "./window"
require "./sound"
require "./menu"
require "./continue"
require "./top"
require "./tutorial"
require "./movie"
require "./stage"
require "./stage_d"
require "./stage_b"
require "./result"
require "./boss"
require "./back"
require "./hero"
require "./daikon"
require "./buta"
require "./kusa"
require "./isi"
require "./next"
require "./command"
require "./hp"
require "./kaen"
require "./syoritai"
require "./rival"
require "./bar"
require "./custom"
require "./challenge"
require "./match"

window   = Window.new
sound    = Sound.new
menu     = Menu.new(window)
continue = Continue.new(window,sound)
top      = Top.new(window,sound)
tutorial = Tutorial.new(window,sound,menu)
movie1  = Movie_1.new(window,sound,1,"")
movie2  = Movie_2.new(window,sound,2,"w")
movie3  = Movie_3.new(window,sound,3,"d")
movie4  = Movie_4.new(window,sound,4,"b")
movie5  = Movie_5.new(window,sound,5,"k")
movie6  = Movie_6.new(window,sound,6,"i")
movie7  = Movie_7.new(window,sound,7,"e")
movie8  = Movie_8.new(window,sound,8,"j")
movie9  = Movie_9.new(window,sound,9,"s")
movie10 = Movie_10.new(window,sound,10,"h")
game1  = Game_s.new(window,sound,menu,1)
game2  = Game_d.new(window,sound,menu)
game3  = Game_s.new(window,sound,menu,3)
game4  = Game_b.new(window,sound,menu)
game5  = Game_s.new(window,sound,menu,5)
game6  = Game_w.new(window,sound,menu,6)
game7  = Game_w.new(window,sound,menu,7)
game8  = Game_w.new(window,sound,menu,8)
game9  = Game_s.new(window,sound,menu,9)
gamem  = Game_match.new(window,sound,menu,6)
result = Result.new(window,sound)
boss   = Boss.new(window,sound)
custom = Custom.new(window,sound)
match  = Match.new(window,sound)
challenge = Challenge.new(window,sound,menu,continue)
tuto_two = Tutorial_two.new(window,sound,menu)

game2_1  = Game_challenge.new(window,sound,menu,50,20,20,5,5)
game2_2  = Game_syori.new(window,sound,menu,22,1,false)
game2_3  = Game_syori.new(window,sound,menu,23,2,false)
game2_4  = Game_syori.new(window,sound,menu,24,5,false)
game2_5  = Game_syori.new(window,sound,menu,25,5,true)
movie2_1 = Movie_2_1.new(window,sound,"2_1","o")
movie2_2 = Movie_2_2.new(window,sound,"2_2","y")
movie2_3 = Movie_2_3.new(window,sound,"2_3","m")
movie2_4 = Movie_2_4.new(window,sound,"2_4","n")
movie2_5 = Movie_2_5.new(window,sound,"2_5","r")
movie2_6 = Movie_2_6.new(window,sound,"2_6","a")


def limit_game(game,menu,continue,result)
	game.game_over = true
	while game.game_over do
		game.play
		if menu.sentaku == 1
			break
		end
		if game.game_over
			continue.play
			result.s_dm += 1
			if continue.sentaku == 1
				$title = false
				break
			end
		end
	end
end

def boss_battle(game,menu,continue)
	game.kekka = 0
	while game.kekka == 0 do
		game.play
		if menu.sentaku == 1
			break
		end
		if game.kekka == 0
			continue.play
			if continue.sentaku == 1
				$title = false
				break
			end
		end
	end
end

while true do
	menu.sentaku = 0
	top.play
	$title = true
	if top.series == 1
		case top.sentaku
		when 1
			top.sentaku = 1
			while $title do
				movie1.play
				game1.play
				if menu.sentaku == 1
					break
				end
				movie2.play
				movie3.play
				boss_battle(game2,menu,continue)
				if $title == false or menu.sentaku == 1
					break
				end
				movie4.play
				game3.play
				if menu.sentaku == 1
					break
				end
				movie5.play
				boss_battle(game4,menu,continue)
				if $title == false or menu.sentaku == 1
					break
				end
				movie6.play
				game5.play
				if menu.sentaku == 1
					break
				end
				movie7.play
				movie8.play
		       		game6.play
				if menu.sentaku == 1
					break
				end
				movie9.play
				movie10.play
				result.s_hk = game1.s_hk + game3.s_hk + game5.s_hk + game6.s_hk
				result.s_nk = game3.s_nk + game5.s_nk + game6.s_nk
				result.s_mk = game5.s_mk + game6.s_mk
				result.s_kk = game6.s_kk
				result.s_dm = game2.s_dm + game4.s_dm
				result.play(1)
				$title = false
				top.clear = 1
			end
		when 2
			tutorial.play
			top.sentaku = 1
		when 3
			while true do
				boss.play
				case boss.sentaku
					when 1
						boss_battle(game2,menu,continue)
					when 2
						boss_battle(game4,menu,continue)
					when 3
						game6.play
						if menu.sentaku == 1
							break
						end
					when 4
						game7.play
						if menu.sentaku == 1
							break
						end
					when 5
						game8.play
						if menu.sentaku == 1
							break
						end
					when 6
						game9.play
						if menu.sentaku == 1
							break
						end
				end
				if menu.sentaku == 1
					$title = false
					break
				end
				if boss.sentaku == 7
					break
				end
			end
			boss.sentaku = 1
			top.sentaku  = 1
		end
	else
		case top.select
			when 1
				while $title do
					result.s_dm = 0
					movie2_1.play
					limit_game(game2_1,menu,continue,result)
					if menu.sentaku == 1 or $title == false
						break
					end
					movie2_2.play
					limit_game(game2_2,menu,continue,result)
					if menu.sentaku == 1 or $title == false
						break
					end
					movie2_3.play
					limit_game(game2_3,menu,continue,result)
					if menu.sentaku == 1 or $title == false
						break
					end
					movie2_4.play
					limit_game(game2_4,menu,continue,result)
					if menu.sentaku == 1 or $title == false
						break
					end
					movie2_5.play
					limit_game(game2_5,menu,continue,result)
					if menu.sentaku == 1 or $title == false
						break
					end
					movie2_6.play
					result.s_hk = game2_1.s_hk + game2_2.s_hk + game2_3.s_hk + game2_4.s_hk + game2_5.s_hk
					result.s_nk = game2_1.s_nk + game2_2.s_nk + game2_3.s_nk + game2_4.s_nk + game2_5.s_nk
					result.s_mk = game2_1.s_mk + game2_2.s_mk + game2_3.s_mk + game2_4.s_mk + game2_5.s_mk
					result.s_kk = game2_1.s_kk + game2_2.s_kk + game2_3.s_kk + game2_4.s_kk + game2_5.s_kk
					result.play(2)
					$title = false
					end
			when 2
				tuto_two.play
			when 3
				while true do
					challenge.play
					if challenge.title
						break
					end
					challenge.play_game(challenge.set_game)
					limit_game(challenge.game,menu,continue,result)
					challenge.data_save(challenge.set_game,challenge.game.score)
					if challenge.menu.sentaku == 1
						break
					end
					unless $title
						break
					end
				end
			when 4
				while true do
					custom.reset
					custom.play
					if custom.select == 11
						break
					end
					data = custom.valueTohash
					if data["scrl"]
						gamec = Game_cs.new(window,sound,menu,data)
					else
						gamec = Game_cw.new(window,sound,menu,data)
					end
					limit_game(gamec,menu,continue,result)
					if menu.sentaku == 1
						break
					end
					unless $title
						break
					end
				end
			when 5
				while true do
					match.play
					if match.title
						break
					end
					limit_game(gamem,menu,continue,result)
					if menu.sentaku == 1
						break
					end
					unless $title
						break
					end
				end
		end
	end
end
