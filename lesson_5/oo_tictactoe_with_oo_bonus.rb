class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def [](num)
    @squares[num]
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def find_at_risk_square(marker)
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      current_line_state = squares.map(&:marker)
      if current_line_state.count(marker) == 2 &&
         current_line_state.count(Square::INITIAL_MARKER) == 1
        return line[current_line_state.index(Square::INITIAL_MARKER)]
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_accessor :score
  attr_reader :marker, :name

  def initialize(marker, name = "Player")
    @marker = marker
    @score = 0
    @name = name
  end
end

class TTTGame
  SCORE_LIMIT = 5
  COMPUTER_NAMES = %w(R2D2 HAL9000 Skynet J.A.R.V.I.S Friday VIKI)

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
  end

  def set_human_identity_and_initialize_player
    player_name = set_player_name
    puts "#{player_name}, would you like to be 'X' or 'O'? (X/O)"
    marker = nil
    loop do
      marker = gets.chomp.upcase
      break if %w(X O).include? marker
      puts "Sorry, invalid choice. Please pick 'X' or 'O'."
    end
    @human_marker = marker
    @human = Player.new(@human_marker, player_name)
  end

  def set_player_name
    puts "What is your name?"
    player_name = nil
    loop do
      player_name = gets.chomp
      break unless player_name.empty?
      puts "Please enter a name."
    end
    player_name
  end

  def set_computer_identity_and_initialize_player
    case @human_marker
    when 'X'
      @computer_marker = 'O'
    when 'O'
      @computer_marker = 'X'
    end
    @computer = Player.new(@computer_marker, COMPUTER_NAMES.sample)
  end

  def set_first_to_move
    @first_to_move = @human_marker
    @current_marker = @first_to_move
  end

  def game_set_up
    clear
    display_welcome_message
    set_human_identity_and_initialize_player
    set_computer_identity_and_initialize_player
    set_first_to_move
  end

  def play
    game_set_up

    loop do
      loop do
        clear_screen_and_display_board

        loop do
          current_player_moves
          break if board.someone_won? || board.full?
          clear_screen_and_display_board
        end

        increment_score
        display_match_result
        break if current_winning_score == SCORE_LIMIT
        press_enter_to_start_next_match
        reset_board
      end
      display_game_result
      break unless play_again?
      reset_score
      reset_board
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def press_enter_to_start_next_match
    puts "Press enter to start the next match."
    gets
  end

  def current_winning_score
    [human.score, computer.score].max
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts "First player to #{SCORE_LIMIT} wins!"
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_board
    display_score
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def joinor(arr, delimit = ', ', joining_word = 'or')
    case arr.size
    when 1
      arr[0]
    when 2
      arr.join(joining_word)
    when 3..9
      arr[0..-2].join(delimit) << ", #{joining_word} #{arr[-1]}"
    end
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    if board[5].unmarked?
      board[5] = computer.marker
    elsif !!board.find_at_risk_square(computer.marker)
      offensive_square = board.find_at_risk_square(computer.marker)
      board[offensive_square] = computer.marker
    elsif !!board.find_at_risk_square(human.marker)
      defending_square = board.find_at_risk_square(human.marker)
      board[defending_square] = computer.marker
    else
    board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def current_player_moves
    if @current_marker == @human_marker
      human_moves
      @current_marker = @computer_marker
    else
      computer_moves
      @current_marker = @human_marker
    end
  end

  def display_match_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "#{human.name} won!"
    when computer.marker
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def display_game_result
    if human.score == 5
      puts "#{human.name} has reached 5 wins!"
    else
      puts "#{computer.name} has reached 5 wins!"
    end
  end

  def increment_score
    case board.winning_marker
    when human.marker
      human.score += 1
    when computer.marker
      computer.score += 1
    end
  end

  def display_score
    puts "#{human.name}: #{human.score} | #{computer.name}: #{computer.score}"
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def clear
    system "clear"
  end

  def reset_board
    board.reset
    @current_marker = @first_to_move
    clear
  end

  def reset_score
    human.score = 0
    computer.score = 0
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
end

game = TTTGame.new
game.play
