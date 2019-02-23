class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def >(other_move)
    rock? && (other_move.scissors? || other_move.lizard?) ||
      paper? && (other_move.rock? || other_move.spock?) ||
      scissors? && (other_move.paper? || other_move.lizard?) ||
      lizard? && (other_move.spock? || other_move.paper?) ||
      spock? && (other_move.rock? || other_move.scissors?)
  end

  def <(other_move)
    rock? && (other_move.paper? || other_move.spock?) ||
      paper? && (other_move.scissors? || other_move.lizard?) ||
      scissors? && (other_move.rock? || other_move.spock?) ||
      lizard? && (other_move.rock? || other_move.scissors?) ||
      spock? && (other_move.lizard? || other_move.paper?)
  end

  def to_s
    @value
  end

  def value
    @value
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    n = nil
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value"
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, spock, or lizard:"
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

# Game Orchestration Engine
class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Spock, and Lizard!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Goodbye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end

    return true if answer.downcase == 'y'
    false
  end

  def tally_results(results)
    results << [human.move.value, computer.move.value]
  end

  def display_results(results)
    puts human.name.center(10) + "|" +
         computer.name.center(10)
    puts "-" * 21
    results.each do |result|
      puts result[0].center(10) + "|" +
           result[1].center(10)
    end
  end

  def play
    display_welcome_message
    results = []
    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      tally_results(results)
      display_results(results)
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
