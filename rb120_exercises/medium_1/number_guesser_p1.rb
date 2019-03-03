class GuessingGame
  def initialize
    @num = (1..100).to_a.sample
    @guesses = 7
  end

  def play
    until @guesses == 0 || player_won?
      display_guesses_remaining
      get_guess
      compare_guess
    end
    display_result
  end

  private
  def display_guesses_remaining
    puts "You have #{@guesses} guesses remaining."
  end

  def get_guess
    guess = nil
    print "Enter a number between 1 and 100: "
    loop do
      guess = gets.chomp.to_i
      break if (1..100).include? guess
      print "Invalid guess. Enter a number between 1 and 100: "
    end
    @guess = guess
    @guesses -= 1
  end

  def player_won?
    @guess == @num
  end

  def compare_guess
    if @guess > @num
      puts "Your guess is too high."
    elsif @guess < @num
      puts "Your guess is too low."
    elsif @guess == @num
      puts "That's the number!"
    end
  end

  def display_result
    if player_won?
      puts "You won!"
    else
      puts "You have no more guesses. You lost!"
    end
  end
end

game = GuessingGame.new
game.play
