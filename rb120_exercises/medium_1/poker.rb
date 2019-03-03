class Card
  include Comparable
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end

  def <=>(other)
    self.value <=> other.value
  end

  def value
    case self.rank
    when (2..10)
      self.rank
    when 'Jack'
      11
    when 'Queen'
      12
    when 'King'
      13
    when 'Ace'
      14
    end
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  attr_reader :cards
  def initialize
    @cards = []
    reset
  end

  def draw
    reset if @cards.size == 0
    @cards.pop
  end

  def reset
    SUITS.each do |suit|
      RANKS.each do |rank|
        @cards << Card.new(rank, suit)
      end
    end
    @cards.shuffle!
  end
end

class PokerHand
  def initialize(deck)
    begin
      @hand = deck.cards.first(5).sort_by{|card| card.value}
    rescue
      @hand = deck.first(5).sort_by{|card| card.value}
    end
  end

  def print
    puts @hand
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def royal_flush?
    @hand.uniq {|card| card.rank}.size == 5 &&
    @hand.all?{|card| [10, 'Jack', 'Queen', 'King', 'Ace'].include? card.rank}
  end

  def straight_flush?
    @hand.uniq {|card| card.rank}.size == 5 &&
    @hand[0].value == @hand[1].value - 1 &&
    @hand[1].value == @hand[2].value - 1 &&
    @hand[2].value == @hand[3].value - 1 &&
    @hand[3].value == @hand[4].value - 1 &&
    @hand.all?{|card| @hand.first.suit == card.suit}
  end

  def four_of_a_kind?
    @hand.any?{|card| @hand.count{|other_card| card == other_card} == 4}
  end

  def full_house?
    @hand.uniq{|card| card.rank}.size == 2
  end

  def flush?
    @hand.all?{|card| @hand.first.suit == card.suit}
  end

  def straight?
    @hand.uniq{|card| card.rank}.size == 5 &&
    @hand[0].value == @hand[1].value - 1 &&
    @hand[1].value == @hand[2].value - 1 &&
    @hand[2].value == @hand[3].value - 1 &&
    @hand[3].value == @hand[4].value - 1
  end

  def three_of_a_kind?
    @hand.any?{|card| @hand.count{|other_card| card == other_card} == 3}
  end

  def two_pair?
    @hand.uniq{|card| card.rank}.size == 3
  end

  def pair?
    @hand.uniq{|card| card.rank}.size == 4
  end
end

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'
