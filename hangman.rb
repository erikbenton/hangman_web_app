require 'sinatra'
require 'sinatra/reloader'

enable :sessions

MAX_GUESSES = 7;
@@word = []
@@guesses = {}
@@incorrect_guesses = []
@@word_length = 0
@@number_of_guesses = 0
@@is_playing = true

get '/' do

	setup_game

	# This is the main page
	# Shows instructions and starts game
	erb :index, :locals => {:max_guesses => MAX_GUESSES}

end



get '/playing' do

	# This is the meat of the app
	# Shows the game
	# Gets input for guesses
	# Allows for save?
	
	message = ""
	if params["guess"] && params["guess"] != ""
		message = check_guess(params["guess"])
	end
	letters_in_word = get_letters_guessed
	get_incorrect_guesses

	if @@is_playing == true

		erb :playing, :locals => {:word => @@word, :guesses => @@guesses, :incorrect_guesses => @@incorrect_guesses, :number_of_guesses => @@number_of_guesses, :letters_in_word => letters_in_word, :message => message}

	else
		win_or_loss = params["win_or_loss"]
		redirect '/gameover'
	end
end



get '/gameover' do

	# Where you go when the game is over
	# Has link back to main '/' page

end

def setup_game
	words = load_words("./5desk.txt")
	@@word = get_word(words)
	@@word_length = @@word.length
	@@guesses = {}
	@@number_of_guesses = @@guesses.length
	@@incorrect_guesses = []
	@@is_playing = true
end

def load_words(file_location)
	words = []
	if File.exist? file_location
		File.readlines(file_location).each do |word|
			if word.length > 4 && word.length < 13
				words.push(word.to_s.strip)
			end
		end
	end
	return words		
end

def get_word(words)
	word = words[Random.rand(words.length)].downcase.split("")
end

def check_guess(guess)
	message = ""
	if guess.length > 1
		message = "Please enter a single letter"
	elsif !@@guesses[guess.to_s]
		if !@@word.include? guess
			@@guesses[guess.to_s] = "no"
			@@number_of_guesses += 1
			if @@number_of_guesses == MAX_GUESSES
				@@is_playing = false
			end
		else
			@@guesses[guess.to_s] = "yes"
		end
	else
		message = "You have already made that guess"
	end
	return message
end

def get_letters_guessed
	letters_in_word = ""
	@@word.each do |letter|
		if @@guesses[letter.to_s]
			letters_in_word += letter.to_s + " "
		else
			letters_in_word += "_ "
		end
	end
	return letters_in_word
end

def get_incorrect_guesses
	@@guesses.each do |guess, val|
		if val == "no" && (!@@incorrect_guesses.include? guess.to_s)
			@@incorrect_guesses.push(guess.to_s)
		end
	end
end