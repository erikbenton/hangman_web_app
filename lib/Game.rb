require 'json'

class Game

	attr_reader :is_playing

	def initialize
		
		self.setup()
	end

	def setup
		words = self.load_words("../5desk.txt")
		@word = get_word(words)
		@word_length = @word.length
		@guesses = {}
		@number_of_guesses = @guesses.length
		@max_guess_number = 10
		@is_playing = true
		puts @word
		self.setup_message()
	end

	def setup_message
		puts "Welcome to Hangman!"
		puts "You 10 chances to correctly guess the word"
		puts "To save your game and exit, just type: save"
		puts "To load a previously saved game, just type: load"
		puts "To simply exit, just type: exit"
		self.show_results();

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
		words		
	end

	def get_word(words)
		
		word = words[Random.rand(words.length)].downcase.split("")
	end

	def make_guess
		
		puts "Please enter in a letter for your guess"
		self.get_guess()		
	end

	def get_guess

		loop do
			
			guess = gets.chomp.downcase
			
			if guess == "save"
				self.save_game()
				break
			elsif guess == "exit"
				self.exit_game()
				break
			elsif guess == "load"
				self.load_game()
				break
			elsif guess.length > 1
				puts "Please enter a single letter"
			elsif !@guesses[guess.to_s]
				if !@word.include? guess
					@guesses[guess.to_s] = "no"
					@number_of_guesses += 1
					if @number_of_guesses == @max_guess_number
						@is_playing = false
					end
				else
					@guesses[guess.to_s] = "yes"
				end
				break
			else
				puts "You have already made that guess"
			end
		end
	end

	def show_results

		puts ""
		@word.each do |letter|
			if @guesses[letter.to_s]
				print letter.to_s + " "
			else
				print "_ "
			end
		end
		puts ""
		print "Incorrect guesses: "
		@guesses.each do |guess, val|
			if val == "no"
				print guess.to_s + " "
			end
		end
		puts ""
		puts "You have #{@max_guess_number - @number_of_guesses} guesses left"
	end

	def save_game
		file_name = "../saves/hangman_save.txt"

		save_file = File.open(file_name, "w")
		save_file.puts JSON.generate(self)
		save_file.close
	end

	def load_game
		if File.exist?("../saves/hangman_save.txt")
			load_game = JSON.parse(File.read("../saves/hangman_save.txt"))
			puts load_game["guesses"]
			@word = load_game["word"]
			@word_length = load_game["word_length"]
			@guesses = load_game["guesses"]
			@number_of_guesses = load_game["number_of_guesses"]
			@max_guess_number = load_game["max_guess_number"]
			@is_playing = load_game["is_playing"]
		end
	end

	def exit_game
		@is_playing = false
	end

	def as_json(options={})
        {
          word: @word,
					word_length: @word_length,
					guesses: @guesses,
					number_of_guesses: @number_of_guesses,
					max_guess_number: @max_guess_number,
					is_playing: @is_playing
        }
  end

  def to_json(*options)
      
      as_json(*options).to_json(*options)
  end

	def reset

	end
end