require_relative "Game.rb"

game = Game.new()

while(game.is_playing)
	game.make_guess()
	game.show_results()
end

puts "Game over"