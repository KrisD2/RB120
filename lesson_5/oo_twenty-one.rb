module Hand
  attr_accessor :hand

  def initialize
    @hand = []
  end

  def busted?
    total > 21
  end

  def total
    values = @hand.map do |card|
      if %w(Jack Queen King).include?(card.value)
        10
      elsif (2..10).include?(card.value.to_i)
        card.value.to_i
      elsif (card.value) == 'Ace'
        11
      end
    end
    values = values.inject(:+)
    if values > 21 && @hand.map(&:value).include?('Ace')
      @hand.map(&:value).count('Ace').times do
        if values > 21
          values -= 10
        end
      end
    end
    values
  end

  def joinor(cards)
    if cards.size == 2
      cards.join(" and ")
    else
      cards[0..-2].join(', ') + " and #{cards[-1]}"
    end
  end

  def cards_in_hand
    joinor(@hand)
  end
end

class Player
  include Hand

  def hit_output
    puts "You hit!"
  end

  def stay_output
    puts "You stay at a total of #{total}."
  end
end

class Dealer
  include Hand

  def hit_output
    puts "Dealer hits!"
  end

  def stay_output
    puts "Dealer stays at #{total}."
  end

  def stay?
    total > 16
  end

  def first_card
    @hand[0]
  end
end

class Deck
  SUITS = ['Diamonds', 'Hearts', 'Clubs', 'Spades']
  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10',
            'Jack', 'Queen', 'King', 'Ace']

  def initialize
    @cards = SUITS.map do |suit|
      VALUES.map do |value|
        Card.new(value, suit)
      end
    end.flatten(1)
    @cards.shuffle!
  end

  def deal
    @cards.pop
  end
end

class Card
  attr_accessor :value, :suit

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def to_s
    "#{@value} of #{@suit}"
  end
end

class Game
  def initialize
    @deck = Deck.new
    @dealer = Dealer.new
    @player = Player.new
  end

  def deal_cards
    @dealer.hand << @deck.deal << @deck.deal
    @player.hand << @deck.deal << @deck.deal
  end

  def show_initial_cards
    show_initial_dealer_cards
    show_player_cards
  end

  def show_initial_dealer_cards
    puts "Dealer has: #{@dealer.first_card} and an unknown card."
  end

  def show_dealer_cards
    puts "Dealer has: #{@dealer.cards_in_hand}."
    puts "Dealer has a total of #{@dealer.total}."
  end

  def show_player_cards
    puts "You have: #{@player.cards_in_hand}."
    puts "You have a total of #{@player.total}."
  end

  def player_turn
    until @player.busted?
      answer = nil
      loop do
        puts "Would you like to hit or stay? (h/s)"
        answer = gets.chomp.downcase[0]
        break if %w(h s).include?(answer[0])
        puts "Sorry, invalid response."
      end
      if answer == 's'
        @player.stay_output
        break
      elsif answer == 'h'
        @player.hit_output
        @player.hand << @deck.deal
      end
      show_player_cards
    end
  end

  def dealer_turn
    return if @player.busted?
    show_dealer_cards
    until @dealer.busted? || @dealer.stay?
      @dealer.hit_output
      @dealer.hand << @deck.deal
      show_dealer_cards
    end
    if @dealer.stay?
      @dealer.stay_output
    end
  end

  def show_result
    if @player.busted?
      puts "You busted at a total of #{@player.total}!"
    elsif @dealer.busted?
      puts "Dealer busts! You win!"
    elsif @dealer.total > @player.total
      puts "Dealer wins with a total of #{@dealer.total}!"
    elsif @player.total > @dealer.total
      puts "You win with a total of #{@player.total}!"
    else
      puts "It's a tie! You and the dealer both have #{@player.total}."
    end
  end

  def start
    system 'clear'
    deal_cards
    show_initial_cards
    player_turn
    dealer_turn
    show_result
  end
end

game = Game.new
game.start
